////
////  RoboFlowAPI.swift
////  RiceDetectionApp
////
////  Created by Zachary Farmer on 10/24/24.
////
//
//import Foundation
//import UIKit
//
//class RoboflowAPI {
//    private static let apiKey = "LNPq7CWUdJi48M3Q3M1C"
//    private static let modelEndpoint = "rice-detection-3"
//    private static let modelVersion = "1"
//
//    static func detectObjects(image: UIImage) async throws -> (predictions: [String: Any], image: UIImage?) {
//        guard let imageData = image.jpegData(compressionQuality: 0.8),
//              let base64String = imageData.base64EncodedString().data(using: .utf8) else {
//            throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to process image"])
//        }
//
//        let urlString = "https://detect.roboflow.com/\(modelEndpoint)/\(modelVersion)?api_key=\(apiKey)&format=image_and_json&stroke=15"
//        guard let url = URL(string: urlString) else {
//            throw NSError(domain: "URLError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.httpBody = base64String
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                return
//            }
//
//            do {
//                if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                   let predictions = dict["predictions"] as? [[String: Any]],
//                   let visualizationBase64 = dict["visualization"] as? String,
//                   let imageData = Data(base64Encoded: visualizationBase64),
//                   let image = UIImage(data: imageData) {
//
//                    // Convert the predictions to proper JSON format with all values as strings
//                    let formattedPredictions = predictions.map { prediction -> [String: String] in
//                        return [
//                            "class": "\(prediction["class"] ?? "")",
//                            "confidence": "\(prediction["confidence"] ?? 0.0)",
//                            "x": "\(prediction["x"] ?? 0)",
//                            "y": "\(prediction["y"] ?? 0)",
//                            "width": "\(prediction["width"] ?? 0)",
//                            "height": "\(prediction["height"] ?? 0)",
//                            "class_id": "\(prediction["class_id"] ?? 0)",
//                            "detection_id": "\(prediction["detection_id"] ?? "")"
//                        ]
//                    }
//
//                    let result: [String: Any] = ["predictions": formattedPredictions]
//                    completion(.success((predictions: result, image: image)))
//                } else {
//                    throw NSError(domain: "JSONError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON or create image"])
//                }
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//}

//import Foundation
//import UIKit
//
//class RoboflowAPI {
//    private static let apiKey = "LNPq7CWUdJi48M3Q3M1C"
//    private static let modelEndpoint = "rice-detection-3"
//    private static let modelVersion = "1"
//
//    static func detectObjects(image: UIImage, completion: @escaping (Result<(predictions: [String: Any], image: UIImage?), Error>) -> Void) {
//        guard let imageData = image.jpegData(compressionQuality: 0.8),
//              let base64String = imageData.base64EncodedString().data(using: .utf8) else {
//            completion(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to process image"])))
//            return
//        }
//
//        let urlString = "https://detect.roboflow.com/\(modelEndpoint)/\(modelVersion)?api_key=\(apiKey)&format=image_and_json&stroke=15"
//        guard let url = URL(string: urlString) else {
//            completion(.failure(NSError(domain: "URLError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.httpBody = base64String
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                return
//            }
//
//            do {
//                if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                   let predictions = dict["predictions"] as? [[String: Any]],
//                   let visualizationBase64 = dict["visualization"] as? String,
//                   let imageData = Data(base64Encoded: visualizationBase64),
//                   let image = UIImage(data: imageData) {
//                    let result: [String: Any] = ["predictions": predictions]
//                    print(predictions)
//                    completion(.success((predictions: result, image: image)))
//                } else {
//                    throw NSError(domain: "JSONError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON or create image"])
//                }
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//}
