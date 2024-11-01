import Foundation
import UIKit

class RoboflowAPI {
    private static let apiKey = "LNPq7CWUdJi48M3Q3M1C"
    private static let modelEndpoint = "rice-detection-3"
    private static let modelVersion = "1"
    
    static func detectObjects(image: UIImage) async throws -> (predictions: [String: Any], image: UIImage?) {
        // Convert the UIImage to JPEG data with a compression quality of 0.8
        guard let imageData = image.jpegData(compressionQuality: 0.8),
              // Encode the image data to a Base64 string
              let base64String = imageData.base64EncodedString().data(using: .utf8) else {
            // Throw an error if image processing fails
            throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to process image"])
        }
        
        // Construct the URL for the API request using the model endpoint and version
        let urlString = "https://detect.roboflow.com/\(modelEndpoint)/\(modelVersion)?api_key=\(apiKey)&format=image_and_json&stroke=15"
        guard let url = URL(string: urlString) else {
            // Throw an error if the URL is invalid
            throw NSError(domain: "URLError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        // Create a URLRequest for the API call
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // Set the request method to POST
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Set the content type
        request.httpBody = base64String // Set the body of the request to the Base64 string
        
        // Perform the API request and wait for the response
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Parse the JSON response
        if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let predictions = dict["predictions"] as? [[String: Any]],
           let visualizationBase64 = dict["visualization"] as? String,
           let imageData = Data(base64Encoded: visualizationBase64),
           let image = UIImage(data: imageData) {
            let result: [String: Any] = ["predictions": predictions]
            print(predictions)
            // Return the predictions and the visualized image
            return (predictions: result, image: image)
        } else {
            // Throw an error if JSON parsing or image creation fails
            throw NSError(domain: "JSONError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON or create image"])
        }
    }
}

