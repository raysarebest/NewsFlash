//
//  Article.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/8/25.
//

import Foundation

struct Article: Decodable, Identifiable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: URL
    let imageURL: URL?
    let publishedAt: Date
    let content: String?
    
    var id: URL {
        get {
            return url
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case description
        case url
        case imageURL = "urlToImage"
        case publishedAt
        case content
    }
}
