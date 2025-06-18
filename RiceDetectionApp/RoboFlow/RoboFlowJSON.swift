import Foundation
import UIKit
import SwiftyJSON

class RoboflowJSON {
    private static let apiKey = "Hi1MZWFdQ5zXo1OhdRVz"
    private static let sizeModelEndpoint = "tws-rice-segmentation"
//    private static let sizeModelEndpoint = "rice-segmentation-kie0f"
//    private static let sizeModelVersion = "2"
    private static let sizeModelVersion = "1"
    
    static func detectObjects(image: UIImage,  modelType: Prediction.modelType) async throws -> [Prediction] {
        // Convert the UIImage to JPEG data with a compression quality of 0.8
        guard let imageData = image.jpegData(compressionQuality: 0.1),
              let base64String = imageData.base64EncodedString().data(using: .utf8) else {
            throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to process image"])
        }

        let urlString = "https://detect.roboflow.com/\(sizeModelEndpoint)/\(sizeModelVersion)?api_key=\(apiKey)&format=json"

        guard let url = URL(string: urlString) else {
            throw NSError(domain: "URLError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = base64String

        let (data, _) = try await URLSession.shared.data(for: request)
        print(data)
        let json = try JSON(data: data) // Use SwiftyJSON to parse the response
        print(json)

        var fetchedPredictions: [Prediction] = []
        for (_, item) in json["predictions"] {
            let x = item["x"].doubleValue
            let y = item["y"].doubleValue
            let width = item["width"].intValue
            let height = item["height"].intValue
            let className = item["class"].stringValue
            let confidence = item["confidence"].doubleValue
            
            let prediction = Prediction(x: x, y: y, width: width, height: height, className: className, confidence: confidence)
            fetchedPredictions.append(prediction)
        }
        return fetchedPredictions
    }
}

