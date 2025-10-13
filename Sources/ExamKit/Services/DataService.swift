//
//  DataService.swift
//  ExamKit
//
//  Created by CT4TuEI3 on 19.09.2025.
//

import Foundation

/// Сервис загрузки JSON-данных
public final class DataService {
    public static let shared = DataService()
    
    private init() {}
}

// MARK: - Internal Methods

extension DataService {
    
    /// Загружает все билеты для выбранной категории экзамена.
    /// - Parameter category: Категория экзамена.
    /// - Returns: Массив билетов, отсортированных по номеру.
    /// - Throws: Ошибку, если файлы билетов не найдены.
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
        
        return tickets.sorted { extractNumber($0.number) < extractNumber($1.number) }
    }
    
    /// Загружает все темы для выбранной категории экзамена.
    /// - Parameter category: Категория экзамена.
    /// - Returns: Массив тем.
    /// - Throws: Ошибку, если файлы тем не найдены.
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
    
    /// Загружает все дорожные знаки в фиксированном порядке категорий и номеров.
    /// - Returns: Массив категорий знаков.
    /// - Throws: Ошибку, если файл не найден или повреждён.
    func loadSigns() throws -> [SignCategory] {
        guard let fileURL = Bundle.module.url(forResource: "signs", withExtension: "json") else {
            throw ExamKitError.signsFileNotFound
        }
        
        let data = try Data(contentsOf: fileURL)
        guard let dict = try JSONSerialization.jsonObject(with: data,
                                                          options: [.allowFragments]) as? [String: Any] else {
            throw ExamKitError.invalidData
        }
        
        let categoryOrder = [
            "Предупреждающие знаки",
            "Знаки приоритета",
            "Запрещающие знаки",
            "Предписывающие знаки",
            "Знаки особых предписаний",
            "Информационные знаки",
            "Знаки сервиса",
            "Знаки дополнительной информации (таблички)"
        ]
        
        var categories: [SignCategory] = []
        categories.reserveCapacity(categoryOrder.count)
        
        for categoryName in categoryOrder {
            guard let categoryData = dict[categoryName] as? [String: Any] else { continue }
            
            let sortedKeys = categoryData.keys.sorted { compareSignNumbers($0, $1) }
            var signs: [Sign] = []
            signs.reserveCapacity(sortedKeys.count)
            
            for key in sortedKeys {
                guard let sign = categoryData[key] as? [String: Any],
                      let number = sign["number"] as? String,
                      let title = sign["title"] as? String,
                      let image = sign["image"] as? String,
                      let description = sign["description"] as? String
                else { continue }
                
                signs.append(Sign(number: number, title: title, imagePath: image, description: description))
            }
            
            categories.append(SignCategory(name: categoryName, signs: signs))
        }
        
        return categories
    }
    
    /// Загружает всю дорожную разметку в фиксированном порядке категорий и номеров.
    /// - Returns: Массив категорий разметки.
    /// - Throws: Ошибку, если файл не найден или повреждён.
    func loadMarkups() throws -> [MarkupCategory] {
        guard let fileURL = Bundle.module.url(forResource: "markup", withExtension: "json") else {
            throw ExamKitError.markupFileNotFound
        }
        
        let data = try Data(contentsOf: fileURL)
        guard let dict = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            throw ExamKitError.invalidData
        }
        
        let categoryOrder = [
            "Горизонтальная разметка",
            "Вертикальная разметка"
        ]
        
        var categories: [MarkupCategory] = []
        categories.reserveCapacity(categoryOrder.count)
        
        for categoryName in categoryOrder {
            guard let categoryData = dict[categoryName] as? [String: Any] else { continue }
            
            let sortedKeys = categoryData.keys.sorted { compareMarkupNumbers($0, $1) }
            var markups: [Markup] = []
            markups.reserveCapacity(sortedKeys.count)
            
            for key in sortedKeys {
                guard let markup = categoryData[key] as? [String: Any],
                      let number = markup["number"] as? String,
                      let image = markup["image"] as? String,
                      let description = markup["description"] as? String
                else { continue }
                
                markups.append(Markup(number: number, imagePath: image, description: description))
            }
            
            categories.append(MarkupCategory(name: categoryName, markups: markups))
        }
        
        return categories
    }
}

// MARK: - Private Methods

private
extension DataService {
    
    /// Возвращает список файлов билетов для выбранной категории.
    func getTicketFiles(for category: ExamCategory) throws -> [URL] {
        guard let allFiles = Bundle.module.urls(forResourcesWithExtension: "json", subdirectory: nil) else {
            throw ExamKitError.ticketsDirectoryNotFound
        }
        
        let prefix = "\(category.folderName)_Билет"
        let files = allFiles.filter { $0.lastPathComponent.hasPrefix(prefix) }
        
        guard !files.isEmpty else {
            throw ExamKitError.ticketsDirectoryNotFound
        }
        
        return files
    }
    
    /// Возвращает список файлов тем для выбранной категории.
    func getTopicFiles(for category: ExamCategory) throws -> [URL] {
        guard let allFiles = Bundle.module.urls(forResourcesWithExtension: "json", subdirectory: nil) else {
            throw ExamKitError.topicsDirectoryNotFound
        }
        
        let prefix = "\(category.folderName)_"
        let files = allFiles.filter {
            $0.lastPathComponent.hasPrefix(prefix) &&
            !$0.lastPathComponent.contains("Билет")
        }
        
        guard !files.isEmpty else {
            throw ExamKitError.topicsDirectoryNotFound
        }
        
        return files
    }
    
    /// Удаляет префикс категории из имени файла.
    func cleanName(_ filename: String, for category: ExamCategory) -> String {
        filename.replacingOccurrences(of: "\(category.folderName)_", with: "")
    }
    
    /// Извлекает числовое значение из строки.
    func extractNumber(_ name: String) -> Int {
        let digits = name.compactMap { $0.wholeNumberValue }
        return Int(digits.map(String.init).joined()) ?? 0
    }
    
    /// Сравнивает номера дорожных знаков (например, "1.2" < "1.11").
    func compareSignNumbers(_ lhs: String, _ rhs: String) -> Bool {
        let lhsParts = lhs.split(separator: ".").compactMap { Int($0) }
        let rhsParts = rhs.split(separator: ".").compactMap { Int($0) }
        for (l, r) in zip(lhsParts, rhsParts) where l != r {
            return l < r
        }
        return lhsParts.count < rhsParts.count
    }
    
    /// Сравнивает номера элементов дорожной разметки.
    func compareMarkupNumbers(_ lhs: String, _ rhs: String) -> Bool {
        let lhsParts = lhs.split(separator: ".").compactMap { Int($0) }
        let rhsParts = rhs.split(separator: ".").compactMap { Int($0) }
        for (l, r) in zip(lhsParts, rhsParts) where l != r {
            return l < r
        }
        return lhsParts.count < rhsParts.count
    }
}
