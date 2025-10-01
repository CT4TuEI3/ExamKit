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
    
    private init() {}
}

// MARK: - Public Methods

public
extension DataService {
    func loadTickets(for category: ExamCategory) throws -> [Ticket] {
        let ticketsResourcePath = "questions/\(category.folderName)/tickets"
        
        guard BundleHelper.directoryExists(atResourcePath: ticketsResourcePath) else {
            throw ExamKitError.ticketsDirectoryNotFound
        }
        
        guard let ticketsURL = BundleHelper.url(forResource: ticketsResourcePath) else {
            throw ExamKitError.ticketsDirectoryNotFound
        }
        
        let ticketFiles = try getTicketFiles(from: ticketsURL)
        return try loadTicketsFromFiles(ticketFiles, in: ticketsURL, for: category)
    }
    
    func loadTopics(for category: ExamCategory) throws -> [Topic] {
        let topicsResourcePath = "questions/\(category.folderName)/topics"
        
        guard BundleHelper.directoryExists(atResourcePath: topicsResourcePath) else {
            throw ExamKitError.topicsDirectoryNotFound
        }
        
        guard let topicsURL = BundleHelper.url(forResource: topicsResourcePath) else {
            throw ExamKitError.topicsDirectoryNotFound
        }
        
        let topicFiles = try getTopicFiles(from: topicsURL)
        return try loadTopicsFromFiles(topicFiles, in: topicsURL, for: category)
    }
}

// MARK: - Private Methods

private
extension DataService {
    func getTicketFiles(from url: URL) throws -> [String] {
        return try fileManager.contentsOfDirectory(atPath: url.path)
            .filter { $0.hasSuffix(".json") }
            .sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }
    
    func getTopicFiles(from url: URL) throws -> [String] {
        return try fileManager.contentsOfDirectory(atPath: url.path)
            .filter { $0.hasSuffix(".json") }
            .sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }
    
    func loadTicketsFromFiles(_ files: [String],
                              in url: URL,
                              for category: ExamCategory) throws -> [Ticket] {
        var tickets: [Ticket] = []
        
        for file in files {
            let ticketURL = url.appendingPathComponent(file)
            let ticketData = try Data(contentsOf: ticketURL)
            let questions = try JSONDecoder().decode([Question].self, from: ticketData)
            
            let ticketNumber = file.replacingOccurrences(of: ".json", with: "")
            let ticket = Ticket(number: ticketNumber, category: category, questions: questions)
            tickets.append(ticket)
        }
        
        return tickets
    }
    
    func loadTopicsFromFiles(_ files: [String], in url: URL, for category: ExamCategory) throws -> [Topic] {
        var topics: [Topic] = []
        
        for file in files {
            let topicURL = url.appendingPathComponent(file)
            let topicData = try Data(contentsOf: topicURL)
            let questions = try JSONDecoder().decode([Question].self, from: topicData)
            
            let topicTitle = file.replacingOccurrences(of: ".json", with: "")
            let topic = Topic(title: topicTitle, category: category, questions: questions)
            topics.append(topic)
        }
        
        return topics
    }
}
