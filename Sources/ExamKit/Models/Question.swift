//
//  Question.swift
//  ExamKit
//
//  Created by CT4TuEI3 on 19.09.2025.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Вопрос
public struct Question: Codable {
    public let title: String
    public let ticketNumber: String
    public let ticketCategory: String
    public let imagePath: String
    public let question: String
    public let answers: [Answer]
    public let correctAnswer: String
    public let answerTip: String
    public let topic: [String]
    public let id: String
    
#if canImport(UIKit)
    public let image: UIImage?
#endif
    
    enum CodingKeys: String, CodingKey {
        case title
        case ticketNumber = "ticket_number"
        case ticketCategory = "ticket_category"
        case imagePath = "image"
        case question
        case answers
        case correctAnswer = "correct_answer"
        case answerTip = "answer_tip"
        case topic
        case id
    }
    
#if canImport(UIKit)
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        ticketNumber = try container.decode(String.self, forKey: .ticketNumber)
        ticketCategory = try container.decode(String.self, forKey: .ticketCategory)
        imagePath = try container.decode(String.self, forKey: .imagePath)
        question = try container.decode(String.self, forKey: .question)
        answers = try container.decode([Answer].self, forKey: .answers)
        correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        answerTip = try container.decode(String.self, forKey: .answerTip)
        topic = try container.decode([String].self, forKey: .topic)
        id = try container.decode(String.self, forKey: .id)
        
        image = ImageService.shared.loadImage(from: imagePath)
    }
#else
    
    /// Custom initializer for non-UIKit platforms
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        ticketNumber = try container.decode(String.self, forKey: .ticketNumber)
        ticketCategory = try container.decode(String.self, forKey: .ticketCategory)
        imagePath = try container.decode(String.self, forKey: .imagePath)
        question = try container.decode(String.self, forKey: .question)
        answers = try container.decode([Answer].self, forKey: .answers)
        correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        answerTip = try container.decode(String.self, forKey: .answerTip)
        topic = try container.decode([String].self, forKey: .topic)
        id = try container.decode(String.self, forKey: .id)
    }
#endif
}
