//
//  ArticleGrid.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/9/25.
//

import SwiftUI

extension ArticleListView {
    struct Grid<Articles: RandomAccessCollection<Article>>: View {
        
        let articles: Articles
        @Binding private(set) var currentArticle: Article?
        
        @Environment(\.loadAction) private var loadMoreArticles
        @Environment(\.dynamicTypeSize) private var dynamicTypeSize
        
        var body: some View {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8, alignment: .top), count: columnCount)) {
                ForEach(articles) { article in
                    Button {
                        currentArticle = article
                    } label: {
                        ArticleCard(article: article)
                            .onAppear {
                                if article.id == articles.last?.id {
                                    loadMoreArticles()
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        
        var columnCount: Int {
            get {
                return if dynamicTypeSize.isAccessibilitySize {
                    1
                }
                else {
                    2
                }
            }
        }
    }
}

#Preview {
    let articles = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try! decoder.decode([Article].self, from: NSDataAsset(name: "Articles")!.data)
    }()
    
    ArticleListView.Grid(articles: articles, currentArticle: .constant(nil))
}
