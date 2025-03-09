//
//  DataLoader.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/9/25.
//

import Foundation

protocol DataLoader {
    func data(from: URL) async throws -> (Data, URLResponse)
}

extension URLSession: DataLoader {}
