//
//  MainDetection.swift
//  RiceDetectionApp
//
//  Created by Zachary Farmer on 10/24/24.
//

import Foundation
import UIKit

class MainDetection {
    // Function to detect rice in an image
    static func detectRice(imageName: UIImage?) async throws -> (predictions: [String: Any], image: UIImage?) {
        // Ensure the provided image is not nil
        guard let image = imageName else {
            // Throw an error if the image is not found
            throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Image not found"])
        }
        
        // Call the Roboflow API to detect objects in the image
        let result = try await RoboflowAPI.detectObjects(image: image)
        // Return the result containing predictions and the processed image
        return result
    }
}

// The following commented-out code is an alternative implementation of the detectRice function
//class MainDetection {
//    static func detectRice(imageName: UIImage?) async throws -> (predictions: [String: Any], image: UIImage?) {
//        guard let image = imageName else {
//            throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Image not found"])
//        }
//        
//        let result = try await RoboflowAPI.detectObjects(image: image)
//        return result
//    }
//}
