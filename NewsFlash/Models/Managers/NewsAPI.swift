//
//  NewsAPI.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/8/25.
//

import Foundation
import Observation

@Observable class NewsAPI {
    private(set) var articles = [Article]()
    private(set) var nextPageOrdinal = startPageOrdinal
    private(set) var hasReachedEnd = false
    
    private static let startPageOrdinal = 1
    private static let baseURL = URL(string: "https://newsapi.org/v2/top-headlines")! // Force-unwrapping is safe since the URL is hand-typed and known to be good
    
    private let backendAPIKey: String
    let networkSession: URLSession
    
    @ObservationIgnored var pageSize = 20 {
        didSet {
            articles = []
            nextPageOrdinal = Self.startPageOrdinal
            hasReachedEnd = false
        }
    }
    
    init(backendAPIKey: String, networkSession: URLSession = .shared) {
        self.backendAPIKey = backendAPIKey
        self.networkSession = networkSession
    }
    
    func loadNextPage() async throws {
        
        guard !hasReachedEnd else {
            return
        }
        
        articles += try await nextPage.articles
    }
    
    func refresh() async throws {
        nextPageOrdinal = Self.startPageOrdinal
        hasReachedEnd = false
        
        articles = try await nextPage.articles
    }
    
    private var nextPage: ResultPage {
        get async throws {
            let preferredLanguage = Bundle.preferredLocalizations(from: ["ar", "de", "en", "es", "fr", "he", "it", "nl", "no", "pt", "ru", "sv", "ud", "zh"]).first ?? Bundle.main.developmentLocalization ?? "en"
            let (pageData, rawResponse) = try await networkSession.data(from: Self.baseURL.appending(queryItems: [URLQueryItem(name: "apiKey", value: backendAPIKey),
                                                                                                                  URLQueryItem(name: "page", value: String(nextPageOrdinal)),
                                                                                                                  URLQueryItem(name: "pageSize", value: String(pageSize)),
                                                                                                                  URLQueryItem(name: "language", value: preferredLanguage)]))
            try Task.checkCancellation()
            
            guard let response = rawResponse as? HTTPURLResponse else {
                throw LoadingError.unexpectedResponseFormat
            }
            
            guard (200..<300).contains(response.statusCode) else {
                throw LoadingError.requestUnsuccessful(httpCode: response.statusCode)
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let page = try decoder.decode(ResultPage.self, from: pageData)
            
            let ended = pageSize * nextPageOrdinal >= page.totalResults
            
            if !ended {
                nextPageOrdinal += 1
            }
            
            hasReachedEnd = ended
            
            return page
        }
    }
}

extension NewsAPI {
    private struct ResultPage: Decodable {
        let totalResults: Int
        let articles: [Article]
        
        enum CodingKeys: CodingKey {
            case status
            case totalResults
            case articles
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let status = try container.decode(String.self, forKey: .status)
            
            guard case "ok" = status else {
                throw switch status { // Switch inside the else block rather than just one switch because I like signaling the intent of "ok" meaning "everything's good, this whole thing wasn't really necessary" and the compiler-enforced requirement to exit scope rather than just writing "break" to kind of fake a guard and risk forgetting to exit in the other cases. I can also throw for every case in the switch this way and move that statement up to the whole expression instead of rewriting it for each case
                case "error":
                    try NewsAPI.SystemError(from: decoder) // Passing in the decoder instead of decoding it through the container because its properties are at the same level we're at right now
                default:
                    DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath,
                                                                      debugDescription: String(localized: "newsapi.decoder.error.unexpected-status: \(status)", // I generally like giving data that can be useful for debugging an error message to the message itself. It gives us more options for helping in case something breaks
                                                                                               comment: #"The message of the error that occurs when the News API returns something other than "ok" or "error" for the "status" key of a response. This is given the actual status generated by the server"#)))
                }
            }
            
            self.totalResults = try container.decode(Int.self, forKey: .totalResults)
            self.articles = try container.decode([Article].self, forKey: .articles)
        }
    }
}
