//
//  DataService.swift
//  ExamKit
//
//  Created by CT4TuEI3 on 19.09.2025.
//

import Foundation

/// Сервис загрузки JSON-данных (билеты и темы)
public final class DataService {
    public static let shared = DataService()
    
    private init() {}
}

// MARK: - Public Methods

public
extension DataService {
    /// Загружает все билеты для указанной категории
    /// - Parameter category: Категория экзамена (`ExamCategory`)
    /// - Returns: Массив билетов (`[Ticket]`), отсортированных по номеру
    /// - Throws: `ExamKitError.ticketsDirectoryNotFound`, если билеты не найдены
    func loadTickets(for category: ExamCategory) throws -> [Ticket] {
        let files = try getTicketFiles(for: category)
        
        var tickets: [Ticket] = []
        tickets.reserveCapacity(files.count)
        
        for url in files {
            let data = try Data(contentsOf: url)
            let questions = try JSONDecoder().decode([Question].self, from: data)
            
            let rawName = url.deletingPathExtension().lastPathComponent
            let ticketNumber = cleanName(rawName, for: category)
            
            tickets.append(Ticket(number: ticketNumber, category: category, questions: questions))
        }
        
        return tickets.sorted { lhs, rhs in
            extractNumber(lhs.number) < extractNumber(rhs.number)
        }
    }
    
    /// Загружает все темы для указанной категории
    /// - Parameter category: Категория экзамена (`ExamCategory`)
    /// - Returns: Массив тем (`[Topic]`)
    /// - Throws: `ExamKitError.topicsDirectoryNotFound`, если темы не найдены
    func loadTopics(for category: ExamCategory) throws -> [Topic] {
        let files = try getTopicFiles(for: category)
        
        var topics: [Topic] = []
        topics.reserveCapacity(files.count)
        
        for url in files {
            let data = try Data(contentsOf: url)
            let questions = try JSONDecoder().decode([Question].self, from: data)
            
            let rawName = url.deletingPathExtension().lastPathComponent
            let topicTitle = cleanName(rawName, for: category)
            
            topics.append(Topic(title: topicTitle, category: category, questions: questions))
        }
        
        return topics
    }
    
    /// Загружает все дорожные знаки с сохранением порядка категорий из JSON
    /// - Returns: Отсортированный массив категорий знаков
    /// - Throws: `ExamKitError.signsFileNotFound`, если файл отсутствует или повреждён
    func loadSigns() throws -> [SignCategory] {
        guard let fileURL = Bundle.module.url(forResource: "signs", withExtension: "json") else {
            throw ExamKitError.signsFileNotFound
        }
        
        let data = try Data(contentsOf: fileURL)
        
        // Загружаем JSON с сохранением порядка ключей
        guard let orderedCategories = try parseOrderedJSON(from: data) else {
            throw ExamKitError.signsFileNotFound
        }
        
        var categories: [SignCategory] = []
        categories.reserveCapacity(orderedCategories.count)
        
        for (categoryName, categoryData) in orderedCategories {
            guard let signsDict = categoryData as? [String: [String: Any]] else { continue }
            
            let signs = parseSigns(from: signsDict)
            let sortedSigns = sortSignsByNumber(signs)
            categories.append(SignCategory(name: categoryName, signs: sortedSigns))
        }
        
        return categories
    }
}

// MARK: - Private Methods

private
extension DataService {
    /// Возвращает список файлов билетов для категории
    func getTicketFiles(for category: ExamCategory) throws -> [URL] {
        guard let allFiles = Bundle.module.urls(forResourcesWithExtension: "json", subdirectory: nil) else {
            throw ExamKitError.ticketsDirectoryNotFound
        }
        
        let prefix = "\(category.folderName)_Билет"
        let files = allFiles.filter { $0.lastPathComponent.hasPrefix(prefix) }
        
        if files.isEmpty {
            throw ExamKitError.ticketsDirectoryNotFound
        }
        
        return files
    }
    
    /// Возвращает список файлов тем для категории
    func getTopicFiles(for category: ExamCategory) throws -> [URL] {
        guard let allFiles = Bundle.module.urls(forResourcesWithExtension: "json", subdirectory: nil) else {
            throw ExamKitError.topicsDirectoryNotFound
        }
        
        let prefix = "\(category.folderName)_"
        let files = allFiles.filter {
            $0.lastPathComponent.hasPrefix(prefix) &&
            !$0.lastPathComponent.contains("Билет")
        }
        
        if files.isEmpty {
            throw ExamKitError.topicsDirectoryNotFound
        }
        
        return files
    }
    
    func cleanName(_ filename: String, for category: ExamCategory) -> String {
        filename.replacingOccurrences(of: "\(category.folderName)_", with: "")
    }
    
    func extractNumber(_ name: String) -> Int {
        let digits = name.compactMap { $0.wholeNumberValue }
        return digits.isEmpty ? 0 : Int(digits.map(String.init).joined()) ?? 0
    }
    
    func parseOrderedJSON(from data: Data) throws -> [(String, Any)]? {
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
            return nil
        }
        
        return jsonObject.compactMap { key, value in
            guard let key = key as? String else { return nil }
            return (key, value)
        }
    }
    
    func parseSigns(from dict: [String: [String: Any]]) -> [Sign] {
        dict.compactMap { (_, signData) in
            guard let number = signData["number"] as? String,
                  let title = signData["title"] as? String,
                  let image = signData["image"] as? String,
                  let description = signData["description"] as? String else {
                return nil
            }
            return Sign(number: number, title: title, imagePath: image, description: description)
        }
    }
    
    func sortSignsByNumber(_ signs: [Sign]) -> [Sign] {
        signs.sorted { lhs, rhs in
            compareSignNumbers(lhs.number, rhs.number)
        }
    }
    
    func compareSignNumbers(_ lhs: String, _ rhs: String) -> Bool {
        let lhsParts = lhs.split(separator: ".").compactMap { Int($0) }
        let rhsParts = rhs.split(separator: ".").compactMap { Int($0) }
        
        for (l, r) in zip(lhsParts, rhsParts) {
            if l != r {
                return l < r
            }
        }
        return lhsParts.count < rhsParts.count
    }
}
