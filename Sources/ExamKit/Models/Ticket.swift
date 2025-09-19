//
//  Ticket.swift
//  ExamKit
//
//  Created by CT4TuEI3 on 19.09.2025.
//

import Foundation

/// Билет с 20-ю вопросами
public struct Ticket {
    public let number: String
    public let category: ExamCategory
    public let questions: [Question]
    
    init(number: String, category: ExamCategory, questions: [Question]) {
        self.number = number
        self.category = category
        self.questions = questions
    }
}
