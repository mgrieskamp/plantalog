//
//  VisionAPIWebDetectionModel.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 8/22/23.
//

import Foundation

struct Annotation: Codable {
    let mid: String
    let description: String
    let score: Double
    let topicality: Double
    enum CodingKeys: String, CodingKey {
        case mid = "mid"
        case description = "description"
        case score = "score"
        case topicality = "topicality"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mid = try container.decode(String.self, forKey: .mid)
        description = try container.decode(String.self, forKey: .description)
        score = try container.decode(Double.self, forKey: .score)
        topicality = try container.decode(Double.self, forKey: .topicality)
    }
}


struct WebResult: Codable {
    let annotations: [Annotation]
    enum CodingKeys: String, CodingKey {
        case annotations = "labelAnnotations"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        annotations = try container.decode([Annotation].self, forKey: .annotations)
    }
}

struct VisionAPIWebDetectionResponse: Codable {
    let responses: [WebResult]
    enum CodingKeys: String, CodingKey {
        case responses = "responses"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        responses = try container.decode([WebResult].self, forKey: .responses)
    }
}
