//
//  MarkupCategory.swift
//  ExamKit
//
//  Created by CT4TuEI3 on 13.10.2025.
//

import Foundation

/// Категория дорожной разметки
public struct MarkupCategory: Identifiable {
    public let name: String
    public let markups: [Markup]
    
    public var id: String {
        return name
    }
    
    public init(name: String, markups: [Markup]) {
        self.name = name
        self.markups = markups
    }
}
