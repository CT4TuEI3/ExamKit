//
//  ExamKit.swift
//  ExamKit
//
//  Created by CT4TuEI3 on 19.09.2025.
//

import Foundation

public final class ExamKit: @unchecked Sendable {
    
    private let dataService: DataService
    
    public static let shared = ExamKit()
    
    private init(dataService: DataService = DataService.shared) {
        self.dataService = dataService
    }
    
    /// Метод возвращает все билеты для категории
    /// - Parameter category: категория билетов
    /// - Returns: массив билетов
    public static func getTickets(for category: ExamCategory) throws -> [Ticket] {
        try shared.dataService.loadTickets(for: category)
    }
    
    /// Метод возвращает все вопросы для категории
    /// - Parameter category: категория билетов
    /// - Returns: массив всех вопросов (800 вопросов для категории)
    public static func getAllQuestions(for category: ExamCategory) throws -> [Question] {
        let tickets = try shared.dataService.loadTickets(for: category)
        return tickets.flatMap { $0.questions }
    }
    
    /// Метод возвращает все темы для категории
    /// - Parameter category: категория билетов
    /// - Returns: массив тем с вопросами
    public static func getTopics(for category: ExamCategory) throws -> [Topic] {
        try shared.dataService.loadTopics(for: category)
    }
}
