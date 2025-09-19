//
//  DataService.swift
//  ExamKit
//
//  Created by CT4TuEI3 on 19.09.2025.
//

import Foundation

public final class DataService {
    public static let shared = DataService()
    
    private let fileManager = FileManager.default
    private var basePath: String {
        // Получаем путь к текущему файлу и поднимаемся до Sources/ExamKit/Resources
        let currentFile = #file
        let currentDir = URL(fileURLWithPath: currentFile).deletingLastPathComponent()
        let examKitDir = currentDir.deletingLastPathComponent()
        return "\(examKitDir.path)/Resources"
    }
    
    private init() {}
    
    /// Load tickets for a specific category
    /// - Parameter category: The exam category
    /// - Returns: Array of tickets
    /// - Throws: ExamKitError if loading fails
    public func loadTickets(for category: ExamCategory) throws -> [Ticket] {
        let ticketsPath = "\(basePath)/questions/\(category.folderName)/tickets"
        
        guard fileManager.fileExists(atPath: ticketsPath) else {
            throw ExamKitError.ticketsDirectoryNotFound
        }
        
        let ticketFiles = try getTicketFiles(from: ticketsPath)
        return try loadTicketsFromFiles(ticketFiles, in: ticketsPath, for: category)
    }
    
    // MARK: - Private Methods
    
    private func getTicketFiles(from path: String) throws -> [String] {
        return try fileManager.contentsOfDirectory(atPath: path)
            .filter { $0.hasSuffix(".json") }
            .sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }
    
    private func loadTicketsFromFiles(_ files: [String], in path: String, for category: ExamCategory) throws -> [Ticket] {
        var tickets: [Ticket] = []
        
        for file in files {
            let ticketPath = "\(path)/\(file)"
            let ticketData = try Data(contentsOf: URL(fileURLWithPath: ticketPath))
            let questions = try JSONDecoder().decode([Question].self, from: ticketData)
            
            let ticketNumber = file.replacingOccurrences(of: ".json", with: "")
            let ticket = Ticket(number: ticketNumber, category: category, questions: questions)
            tickets.append(ticket)
        }
        
        return tickets
    }
}
