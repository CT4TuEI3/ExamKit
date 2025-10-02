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
    public func loadImage(for question: Question) -> UIImage? {
        return loadImage(from: question.imagePath)
    }
    
    /// Загружает изображение из строки пути
    /// - Parameter imagePath: Путь из JSON (например `"./images/A_B/xxx.jpg"`)
    /// - Returns: `UIImage`, если картинка найдена, или `nil`
    public func loadImage(from imagePath: String) -> UIImage? {
        guard !imagePath.contains("no_image") else {
            return nil
        }
        
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
    public static func loadImageData(from imagePath: String) throws -> Data {
        let fileName = URL(fileURLWithPath: imagePath).lastPathComponent
        let fileExtension = (fileName as NSString).pathExtension
        let nameWithoutExt = (fileName as NSString).deletingPathExtension
        
        guard let url = Bundle.module.url(forResource: nameWithoutExt, withExtension: fileExtension) else {
            throw ExamKitError.imageNotFound(fileName)
        }
        
        return try Data(contentsOf: url)
    }
}
