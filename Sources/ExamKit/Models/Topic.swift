//
//  Topic.swift
//  ExamKit
//
//  Created by CT4TuEI3 on 23.09.2025.
//

import Foundation

/// Тема экзаменационных вопросов
public struct Topic: Identifiable {
    public let title: String
    public let category: ExamCategory
    public let questions: [Question]
    
    /// Уникальный идентификатор
    public var id: String {
        return "\(category.rawValue)_\(title)"
    }
    
    init(title: String, category: ExamCategory, questions: [Question]) {
        self.title = title
        self.category = category
        self.questions = questions
    }
}
