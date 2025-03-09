//
//  ArticleListView.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/7/25.
//

import SwiftUI
import SafariServices

struct ArticleListView: View {
    
    @State private var backend = NewsAPI(backendAPIKey: Bundle.main.infoDictionary!["NFNewsAPIKey"] as! String) // Force-unwrapping is safe because these are defined at compile-time and counts as a programmer error if it's missing
    @State private var loadingTask: Task<Void, any Error>? = nil
    @State private var lastError: (any Error)? = nil
    @State private var currentArticle: Article? = nil
    
    @SceneStorage("lastRefresh") private var lastRefresh = Date.distantPast
    @Environment(\.calendar) private var calendar
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                
                if let error = lastError {
                    ErrorBanner(error: error)
                }
                
                if backend.articles.isEmpty {
                    if loadingTask == nil {
                        NoArticlesView()
                            .frame(minHeight: geometry.size.height)
                    }
                    else {
                        ProgressView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
                else {
                    Grid(articles: backend.articles, currentArticle: $currentArticle)
                        .padding(.horizontal, 8)
                        .environment(\.loadAction, LoadAction(action: {
                            load(task: backend.loadNextPage)
                        }))
                    
                    if !backend.hasReachedEnd {
                        ProgressView()
                            .padding()
                    }
                }
            }
            .sheet(item: $currentArticle) { article in
                SafariView(url: article.url)
                    .ignoresSafeArea()
            }
        }
        .refreshable {
            try? await load(task: backend.refresh).value
        }
        .onAppear {
            // This block does 2 things: Load the articles for the first time when launching the app and refreshes the list if it's been at least 20 minutes since you left the app and came back
            
            let refreshMinuteThreshold = 20
            let refreshThreshold = calendar.date(byAdding: DateComponents(minute: refreshMinuteThreshold), to: lastRefresh) ?? lastRefresh + TimeInterval(refreshMinuteThreshold * 60) // 20 minutes calculated the right way if possible, or 20 minutes in seconds if not
            
            if backend.articles.isEmpty && !backend.hasReachedEnd || refreshThreshold < .now {
                load(task: backend.refresh)
            }
        }
    }
    
    @discardableResult func load(task: @escaping () async throws -> Void) -> Task<Void, any Error> {
        loadingTask?.cancel()
        
        let task: Task<Void, any Error> = Task {
            do {
                try await task()
            } catch let error {
                lastError = error
            }
            
            loadingTask = nil
        }
        
        loadingTask = task
        
        return task
    }
}

#Preview {
    ArticleListView()
}
