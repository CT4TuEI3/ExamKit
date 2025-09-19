//
//  ExamKitError.swift
//  ExamKit
//
//  Created by CT4TuEI3 on 19.09.2025.
//

import Foundation

public enum ExamKitError: Error, LocalizedError {
    case bundleNotFound
    case ticketsDirectoryNotFound
    case imageNotFound
    case invalidData
    
    public var errorDescription: String? {
        switch self {
            case .bundleNotFound:
                "Bundle not found"
            case .ticketsDirectoryNotFound:
                "Tickets directory not found"
            case .imageNotFound:
                "Image not found"
            case .invalidData:
                "Invalid data format"
        }
    }
}
