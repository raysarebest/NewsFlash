//
//  Source.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/8/25.
//

extension Article {
    struct Source: Decodable {
        let id: String?
        let name: String
    }
}
