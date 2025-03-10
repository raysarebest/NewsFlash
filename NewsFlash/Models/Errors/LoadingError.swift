//
//  LoadingError.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/9/25.
//

import Foundation

extension NewsAPI {
    enum LoadingError: LocalizedError {
        case unexpectedResponseFormat
        case requestUnsuccessful(httpCode: Int)
        
        var errorDescription: String? {
            get {
                return switch self {
                    case .unexpectedResponseFormat :
                        String(localized: "newsapi.loader.error.unexpected-response-format",
                               comment: "The message of the error displayed when the News API's response wasn't an HTTP response")
                    case .requestUnsuccessful(let httpCode):
                        String(localized: "newsapi.loader.error.request-unsuccessful: \(httpCode), \(HTTPURLResponse.localizedString(forStatusCode: httpCode))",
                               comment: "The message of the error displayed when the News API's request failed")
                }
            }
        }
    }
}
