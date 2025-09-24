//
//  Answer.swift
//  ExamKit
//
//  Created by CT4TuEI3 on 19.09.2025.
//

import Foundation

/// Вариант ответа
public struct Answer: Codable {
    public let answerText: String
    public let isCorrect: Bool
    
    enum CodingKeys: String, CodingKey {
        case answerText = "answer_text"
        case isCorrect = "is_correct"
    }
}
