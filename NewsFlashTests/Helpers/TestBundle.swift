//
//  TestBundle.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/10/25.
//

import Foundation

class TestBundle: Bundle, @unchecked Sendable {
    
    static let testAPIKey = "ExampleKey"
    
    override var infoDictionary: [String : Any]? {
        get {
            return ["NFNewsAPIKey": Self.testAPIKey]
        }
    }
}
