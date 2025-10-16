//
//  Markup.swift
//  ExamKit
//
//  Created by CT4TuEI3 on 13.10.2025.
//

import Foundation
import UIKit

/// Дорожная разметка
public struct Markup: Codable, Identifiable {
    public let number: String
    public let imagePath: String
    public let description: String
    public let image: UIImage?
    
    public var id: String {
        return number
    }
    
    enum CodingKeys: String, CodingKey {
        case number
        case imagePath = "image"
        case description
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        number = try container.decode(String.self, forKey: .number)
        imagePath = try container.decode(String.self, forKey: .imagePath)
        description = try container.decode(String.self, forKey: .description)
        
        image = ImageService.shared.loadImage(from: imagePath)
    }
    
    public init(number: String, imagePath: String, description: String) {
        self.number = number
        self.imagePath = imagePath
        self.description = description
        self.image = ImageService.shared.loadImage(from: imagePath)
    }
}
