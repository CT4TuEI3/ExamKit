//
//  ExamCategory.swift
//  ExamKit
//
//  Created by CT4TuEI3 on 19.09.2025.
//

import Foundation

/// Категории билетов экзамена
public enum ExamCategory: String, CaseIterable {
    case abm = "A,B"
    case cd = "C,D"
    
    var folderName: String {
        switch self {
            case .abm:
                "A_B"
            case .cd:
                "C_D"
        }
    }
}
