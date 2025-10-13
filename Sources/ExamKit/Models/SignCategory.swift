//
//  SignCategory.swift
//  ExamKit
//
//  Created by CT4TuEI3 on 10.10.2025.
//

import Foundation

/// Категория дорожных знаков
public struct SignCategory: Identifiable {
    public let name: String
    public let signs: [Sign]
    
    public var id: String {
        return name
    }
    
    public init(name: String, signs: [Sign]) {
        self.name = name
        self.signs = signs
    }
}
