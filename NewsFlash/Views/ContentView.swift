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
    
//    @SceneStorage("lastRefresh") private var lastRefresh = Date.distantPast
//    @Environment(\.calendar) private var calendar
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(geometry.size.width / 2 - 12), spacing: 8, alignment: .top), count: 2)) {
                    ForEach(backend.articles) { article in
                        Button {
                            currentArticle = article
                        } label: {
                            ArticleCard(article: article)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 8)
                
                if !backend.hasReachedEnd {
                    ProgressView()
                        .padding()
                        .onAppear {
                            print("MHDEBUG: Loading next page")
                            load(task: backend.loadNextPage)
                        }
                }
            }
            .refreshable {
                load(task: backend.refresh)
            }
            .sheet(item: $currentArticle) { article in
                SafariView(url: article.url)
                    .ignoresSafeArea()
            }
        }
//        .onAppear {
//            let refreshMinuteThreshold = 20
//            let refreshThreshold = calendar.date(byAdding: DateComponents(minute: refreshMinuteThreshold), to: lastRefresh) ?? lastRefresh + TimeInterval(refreshMinuteThreshold * 60) // 20 minutes calculated the right way if possible, or 20 minutes in seconds if not
//            if backend.articles.isEmpty && !backend.hasReachedEnd || refreshThreshold < .now {
//                load(task: backend.refresh)
//            }
//        }
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
                lastError = error
            }
        }
    }
}

#Preview {
    ContentView()
}
