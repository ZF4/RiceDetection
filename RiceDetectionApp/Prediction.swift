//
//  Item.swift
//  RiceDetectionApp
//
//  Created by Zachary Farmer on 10/24/24.
//

import Foundation
import SwiftData

struct Prediction: Codable {
    var x: Double?
    var y: Double?
    var width: Int?
    var height: Int?
    var className: String?
    var confidence: Double?
//    var detectionID: String
    
    enum CodingKeys: String, CodingKey {
        case x = "x"
        case y = "y"
        case width = "width"
        case height = "height"
        case className = "class"
        case confidence = "confidence"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        x = try values.decodeIfPresent(Double.self, forKey: .x)
        y = try values.decodeIfPresent(Double.self, forKey: .y)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        className = try values.decodeIfPresent(String.self, forKey: .className)
        confidence = try values.decodeIfPresent(Double.self, forKey: .confidence)
    }
    
}

struct PredictionBase: Codable {
    let predictions: [Prediction]?

    enum CodingKeys: String, CodingKey {
        case predictions = "predictions"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        predictions = try values.decodeIfPresent([Prediction].self, forKey: .predictions)
    }

}
