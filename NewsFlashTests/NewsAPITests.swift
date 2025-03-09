//
//  NewsAPITests.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/9/25.
//

import Testing
import Foundation
@testable import NewsFlash

struct NewsAPITests {
    
    @Test func requestsIncludeAPIKeyFromBundle() async throws {
        
        class ExpectingSession: TestURLSession {
            override func data(from locator: URL) async throws -> (Data, URLResponse) {
                #expect(dump(locator.query())?.contains("apiKey=\(TestBundle.testAPIKey)") ?? false)
                return try await super.data(from: locator)
            }
        }
        
        let testAPI = NewsAPI(bundle: TestBundle(), networkSession: ExpectingSession())
        try await testAPI.loadNextPage()
    }
    
    @Test func refusesToPageBeyondResultsBeforeRefresh() async throws {
        let testAPI = NewsAPI(bundle: TestBundle(), networkSession: TestURLSession())
        
        // The test data declares the total response size to be 33, but includes 20 articles
        
        #expect(testAPI.articles.isEmpty)
        #expect(testAPI.nextPageOrdinal == 1)
        #expect(!testAPI.hasReachedEnd)
        
        try await testAPI.loadNextPage()
        
        #expect(testAPI.articles.count == testAPI.pageSize)
        #expect(testAPI.nextPageOrdinal == 2)
        #expect(!testAPI.hasReachedEnd)
        
        try await testAPI.loadNextPage()
        
        #expect(testAPI.articles.count == testAPI.pageSize * 2)
        #expect(testAPI.nextPageOrdinal == 2)
        #expect(testAPI.hasReachedEnd)
        
        try await testAPI.loadNextPage()
        
        // Should not increase since the last call
        #expect(testAPI.articles.count == testAPI.pageSize * 2)
        #expect(testAPI.nextPageOrdinal == 2)
        #expect(testAPI.hasReachedEnd)
        
        try await testAPI.refresh()
        
        // Should now match the totals after loading the first page
        #expect(testAPI.articles.count == testAPI.pageSize)
        #expect(testAPI.nextPageOrdinal == 2)
        #expect(!testAPI.hasReachedEnd)
    }
}
