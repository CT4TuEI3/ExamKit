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
    case topicsDirectoryNotFound
    case signsFileNotFound
    case imageNotFound(String)
    case invalidData

    public var errorDescription: String? {
        switch self {
        case .bundleNotFound:
            return "Bundle не найден"
        case .ticketsDirectoryNotFound:
            return "Не найдена директория билетов"
        case .topicsDirectoryNotFound:
            return "Не найдена директория тем"
        case .signsFileNotFound:
            return "Файл signs.json не найден"
        case .imageNotFound(let name):
            return "Изображение не найдено: \(name)"
        case .invalidData:
            return "Некорректный формат данных"
        }
    }
}
