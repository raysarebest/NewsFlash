//
//  TestURLSession.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/10/25.
//

import Foundation
@testable import NewsFlash

class TestURLSession: DataLoader {
    
    func data(from locator: URL) async throws -> (Data, URLResponse) {
        return (NewsAPI.exampleData, HTTPURLResponse())
    }
}
