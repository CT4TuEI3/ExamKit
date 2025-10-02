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
}

// MARK: - Private Helpers

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
    
    /// Убирает префикс категории из имени файла
    func cleanName(_ filename: String, for category: ExamCategory) -> String {
        filename.replacingOccurrences(of: "\(category.folderName)_", with: "")
    }
    
    /// Извлекает числовую часть из названия билета
    func extractNumber(_ name: String) -> Int {
        let digits = name.compactMap { $0.wholeNumberValue }
        return digits.isEmpty ? 0 : Int(digits.map(String.init).joined()) ?? 0
    }
}
