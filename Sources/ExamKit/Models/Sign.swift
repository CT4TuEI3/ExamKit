//
//  Sign.swift
//  ExamKit
//
//  Created by CT4TuEI3 on 10.10.2025.
//

import Foundation
import UIKit

/// Дорожный знак
public struct Sign: Codable, Identifiable {
    public let number: String
    public let title: String
    public let imagePath: String
    public let description: String
    public let image: UIImage?
    
    public var id: String {
        return number
    }
    
    enum CodingKeys: String, CodingKey {
        case number
        case title
        case imagePath = "image"
        case description
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        number = try container.decode(String.self, forKey: .number)
        title = try container.decode(String.self, forKey: .title)
        imagePath = try container.decode(String.self, forKey: .imagePath)
        description = try container.decode(String.self, forKey: .description)
        
        image = ImageService.shared.loadImage(from: imagePath)
    }
    
    public init(number: String, title: String, imagePath: String, description: String) {
        self.number = number
        self.title = title
        self.imagePath = imagePath
        self.description = description
        self.image = ImageService.shared.loadImage(from: imagePath)
    }
}
