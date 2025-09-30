//
//  BundleHelper.swift
//  ExamKit
//
//  Created by CT4TuEI3 on 30.09.2025.
//

import Foundation

/// Утилитный класс для работы с ресурсами
/// Использует #file подход для избежания проблем с Bundle кодподписанием на симуляторе
internal final class BundleHelper {
    
    /// Получает базовый путь к ресурсам используя #file
    /// - Returns: Путь к папке Resources
    private static var resourcesBasePath: String {
        let currentFile = #file
        let currentDir = URL(fileURLWithPath: currentFile).deletingLastPathComponent()
        let examKitDir = currentDir.deletingLastPathComponent()
        return "\(examKitDir.path)/Resources"
    }
    
    /// Получает URL для ресурса
    /// - Parameters:
    ///   - resourcePath: Путь к ресурсу относительно Resources
    ///   - pathExtension: Расширение файла (nil если уже включено в путь)
    /// - Returns: URL ресурса или nil если не найден
    static func url(forResource resourcePath: String, withExtension pathExtension: String? = nil) -> URL? {
        let fullPath = "\(resourcesBasePath)/\(resourcePath)"
        
        if FileManager.default.fileExists(atPath: fullPath) {
            return URL(fileURLWithPath: fullPath)
        }
        
        return nil
    }
    
    /// Проверяет существование директории ресурсов
    /// - Parameter resourcePath: Путь к директории относительно Resources
    /// - Returns: true если директория существует
    static func directoryExists(atResourcePath resourcePath: String) -> Bool {
        let fullPath = "\(resourcesBasePath)/\(resourcePath)"
        
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
}
