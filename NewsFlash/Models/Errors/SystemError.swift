//
//  SystemError.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/8/25.
//

import Foundation

extension NewsAPI {
    public struct SystemError: CustomNSError, Decodable {
        
        public static let errorDomain = "tech.hulet.newsflash.newsapi"
        
        public let errorCode: Int
        public let localizedDescription: String
        
        let systemCode: String
        
        enum CodingKeys: CodingKey {
            case code
            case message
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            systemCode = try container.decode(String.self, forKey: .code)
            
            var hasher = Hasher()
            hasher.combine(systemCode)
            errorCode = hasher.finalize()
            
            localizedDescription = try container.decode(String.self, forKey: .message)
        }
    }
}
