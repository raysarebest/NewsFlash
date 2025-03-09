//
//  ExampleData.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/9/25.
//

import Foundation
@testable import NewsFlash

extension NewsAPI {
    static var exampleData: Data {
        get {
            // Force-unwrapping throughout this getter is safe because this file is known to exist at compile-time and is therefore a programmer error if it's missing or corrupted
            let dataURL = Bundle(for: BundleFinder.self).path(forResource: "ExampleResponse", ofType: "json")!
            return FileManager.default.contents(atPath: dataURL)!
        }
    }
}

private class BundleFinder {}
