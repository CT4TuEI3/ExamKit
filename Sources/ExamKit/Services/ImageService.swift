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

/// Service responsible for loading images
public final class ImageService {
    public static let shared = ImageService()
    
    private let fileManager = FileManager.default
    private var basePath: String {
        // Получаем путь к текущему файлу и поднимаемся до Sources/ExamKit/Resources/images
        let currentFile = #file
        let currentDir = URL(fileURLWithPath: currentFile).deletingLastPathComponent()
        let examKitDir = currentDir.deletingLastPathComponent()
        return "\(examKitDir.path)/Resources/images"
    }
    
    private init() {}
    
    #if canImport(UIKit)
    /// Load image for a question
    /// - Parameter question: The question containing image path
    /// - Returns: UIImage if found, nil otherwise
    public func loadImage(for question: Question) -> UIImage? {
        return loadImage(from: question.imagePath)
    }
    
    /// Load image from image path string
    /// - Parameter imagePath: The image path string
    /// - Returns: UIImage if found, nil otherwise
    public func loadImage(from imagePath: String) -> UIImage? {
        guard !imagePath.contains("no_image.jpg") else {
            return nil
        }
        
        guard let filename = extractFilename(from: imagePath),
              let categoryFolder = extractCategoryFolder(from: imagePath) else {
            return nil
        }
        
        let fullImagePath = "\(basePath)/\(categoryFolder)/\(filename)"
        
        guard fileManager.fileExists(atPath: fullImagePath) else {
            return nil
        }
        
        return UIImage(contentsOfFile: fullImagePath)
    }
    #endif
    
    // MARK: - Private Methods
    
    private func extractFilename(from imagePath: String) -> String? {
        return imagePath.components(separatedBy: "/").last
    }
    
    private func extractCategoryFolder(from imagePath: String) -> String? {
        if imagePath.contains("A_B") {
            return "A_B"
        } else if imagePath.contains("C_D") {
            return "C_D"
        }
        return nil
    }
}
