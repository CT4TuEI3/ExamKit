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

/// Сервис, отвечающий за загрузку изображений
public final class ImageService {
    
    // MARK: - Singleton
    
    public static let shared = ImageService()
    
    // MARK: - Private properties
    
    private let fileManager = FileManager.default
    
    // MARK: - Init
    
    private init() {}
}

// MARK: - Public Methods

#if canImport(UIKit)
public
extension ImageService {
    func loadImage(for question: Question) -> UIImage? {
        return loadImage(from: question.imagePath)
    }
    
    func loadImage(from imagePath: String) -> UIImage? {
        guard !imagePath.contains("no_image.jpg") else {
            return nil
        }
        
        guard let filename = extractFilename(from: imagePath),
              let categoryFolder = extractCategoryFolder(from: imagePath) else {
            return nil
        }
        
        let imageResourcePath = "images/\(categoryFolder)/\(filename)"
        
        guard let imageURL = BundleHelper.url(forResource: imageResourcePath) else {
            return nil
        }
        
        return UIImage(contentsOfFile: imageURL.path)
    }
}
#endif

// MARK: - Private Methods

private
extension ImageService {
    func extractFilename(from imagePath: String) -> String? {
        return imagePath.components(separatedBy: "/").last
    }
    
    func extractCategoryFolder(from imagePath: String) -> String? {
        if imagePath.contains("A_B") {
            return "A_B"
        } else if imagePath.contains("C_D") {
            return "C_D"
        }
        return nil
    }
}
