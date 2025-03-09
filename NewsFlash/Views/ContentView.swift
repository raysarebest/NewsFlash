//
//  ContentView.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/7/25.
//

import SwiftUI
import SafariServices

struct ContentView: View {
    
    @State private var backend = NewsAPI(backendAPIKey: Bundle.main.infoDictionary!["NFNewsAPIKey"] as! String)
    @State private var loadingTask: Task<Void, any Error>? = nil
    @State private var lastError: (any Error)? = nil
    @State private var currentArticle: Article? = nil
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 200)), count: 2)) {
                    ForEach(backend.articles) { article in
                        Button {
                            currentArticle = article
                        } label: {
                            VStack {
                                AsyncImage(url: article.imageURL)
                                Text(article.title)
                                    .font(.headline)
                            }
                        }
                    }
                }
            }
            .refreshable {
                load(task: backend.refresh)
            }
            .sheet(item: $currentArticle) { article in
                SafariView(url: article.url)
            }
        }
    }
    
    var errorIsPresented: Binding<Bool> {
        get {
            return Binding {
                return lastError == nil
            } set: { _ in
                lastError = nil
            }

        }
    }
    
    func load(task: @escaping () async throws -> Void) -> Void {
        loadingTask?.cancel()
        
        loadingTask = Task {
            do {
                try await task()
            } catch let error {
                lastError = dump(error)
            }
        }
    }
}

#Preview {
    ContentView()
}
