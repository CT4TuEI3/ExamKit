//
//  ImageService.swift
//  ExamKit
//
//  Created by CT4TuEI3 on 19.09.2025.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif

/// Сервис для загрузки изображений из ресурсов пакета
public final class ImageService {
    public static let shared = ImageService()
    
    private init() {}
}

// MARK: - Public Methods

public
extension ImageService {
#if canImport(UIKit)
    /// Загружает изображение для вопроса
    /// - Parameter question: Экземпляр вопроса (`Question`)
    /// - Returns: `UIImage`, если картинка найдена, или `nil` если картинка отсутствует
    func loadImage(for question: Question) -> UIImage? {
        loadImage(from: question.imagePath)
    }
    
    /// Загружает изображение из строки пути
    /// - Parameter imagePath: Путь из JSON (например `"./images/A_B/xxx.jpg"`)
    /// - Returns: `UIImage`, если картинка найдена, или `nil`
    func loadImage(from imagePath: String) -> UIImage? {
        guard !imagePath.contains("no_image") else {
            return nil
        }
        
        // Извлекаем имя файла без расширения
        let fileName = URL(fileURLWithPath: imagePath).lastPathComponent
        let nameWithoutExt = (fileName as NSString).deletingPathExtension
        
        // Пробуем загрузить через UIImage(named:) из Bundle.module
        if let image = UIImage(named: nameWithoutExt, in: Bundle.module, compatibleWith: nil) {
            return image
        }
        
        // Fallback: загружаем через Data
        do {
            let data = try Self.loadImageData(from: imagePath)
            return UIImage(data: data)
        } catch {
#if DEBUG
            print("⚠️ ImageService: не удалось загрузить \(imagePath), ошибка: \(error)")
#endif
            return nil
        }
    }
#endif
    
    /// Загружает бинарные данные изображения
    /// - Parameter imagePath: Путь из JSON (например `"./images/C_D/abc.jpg"`)
    /// - Returns: `Data` с содержимым картинки
    /// - Throws: `ImageServiceError.imageNotFound`, если файл не найден
    static func loadImageData(from imagePath: String) throws -> Data {
        let fileName = URL(fileURLWithPath: imagePath).lastPathComponent
        let fileExtension = (fileName as NSString).pathExtension
        let nameWithoutExt = (fileName as NSString).deletingPathExtension
        
        guard let url = Bundle.module.url(forResource: nameWithoutExt, withExtension: fileExtension) else {
            throw ExamKitError.imageNotFound(fileName)
        }
        
        return try Data(contentsOf: url)
    }
}
