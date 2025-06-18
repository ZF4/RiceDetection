import Foundation
import UIKit

class RoboflowImage {
    private static let apiKey = "Hi1MZWFdQ5zXo1OhdRVz"
//    private static let sizeModelEndpoint = "rice-detection-3"
    private static let sizeModelEndpoint = "tws-rice-segmentation"
    private static let sizeModelVersion = "1"
//    private static let colorModelEndpoint = "rice-color"
//    private static let colorModelVersion = "1"
    
    static func detectObjects(image: UIImage, modelType: Prediction.modelType) async throws -> (UIImage?) {
        // Convert the UIImage to JPEG data with a compression quality of 0.8
        guard let imageData = image.jpegData(compressionQuality: 0.1),
              // Encode the image data to a Base64 string
              let base64String = imageData.base64EncodedString().data(using: .utf8) else {
            // Throw an error if image processing fails
            throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to process image"])
        }
        // Construct the URL for the API request using the model endpoint and version
        let urlString: String = "https://detect.roboflow.com/\(sizeModelEndpoint)/\(sizeModelVersion)?api_key=\(apiKey)&format=image_and_json&stroke=3"
//        var urlString = ""
//        //MARK: Take out both types, only use size
//        if modelType == .color {
//            urlString = "https://detect.roboflow.com/\(colorModelEndpoint)/\(colorModelVersion)?api_key=\(apiKey)&format=image_and_json&stroke=15"
//        } else if modelType == .size {
//            urlString = "https://detect.roboflow.com/\(sizeModelEndpoint)/\(sizeModelVersion)?api_key=\(apiKey)&format=image_and_json&stroke=15"
//        }
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
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check the HTTP response status code
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Response Status Code: \(httpResponse.statusCode)")
        }
        
        // Log the raw response data for debugging
        if let responseString = String(data: data, encoding: .utf8) {
            print("API Response: \(responseString)")
        }
        
        // Parse the JSON response
        if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let visualizationBase64 = dict["visualization"] as? String,
           let imageData = Data(base64Encoded: visualizationBase64),
           let image = UIImage(data: imageData) {
            // Return the predictions and the visualized image
            return (image)
        } else {
            // Throw an error if the response does not contain the expected data
            throw NSError(domain: "ResponseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response"])
        }
    }
}
