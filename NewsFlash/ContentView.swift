//
//  ContentView.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/7/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if let info = Bundle.main.infoDictionary {
            if let keyData = info["NFNewsAPIKey"] {
                if let key = keyData as? String {
                    if !key.isEmpty {
                        Text(key)
                    }
                    else {
                        Text(verbatim: "Key empty")
                    }
                }
                else {
                    Text(verbatim: "Key in wrong format")
                }
            }
            else {
                Text(verbatim: "No key")
            }
        }
        else {
            Text(verbatim: "No info")
        }
    }
}

#Preview {
    ContentView()
}
