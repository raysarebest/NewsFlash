//
//  ArticleCard.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/9/25.
//

import SwiftUI

struct ArticleCard: View {
    
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading) {

            Thumbnail(imageURL: article.imageURL)

            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(titleLineLimit)
                    .foregroundStyle(.primary)
                
                if let description = article.description {
                    Text(description)
                        .font(.body)
                        .lineLimit(4)
                        .foregroundStyle(.secondary)
                }
            
                Spacer(minLength: 0)
            
                if let author = article.author {
                    Divider()
                    
                    Text("article-list.card.author: \(author)", comment: "The format of the line that displays the author in a card in the article list. This is given the names of the article's author(s), potentially in a comma-separated list")
                        .font(.caption)
                        .truncationMode(.head)
                }
                    
            }
            .truncationMode(.tail)
            .padding(8)
        }
        .frame(minHeight: 300)
        .multilineTextAlignment(.leading)
        .clipShape(borderShape)
        .clipped()
        .overlay {
            borderShape
                .stroke(.gray, lineWidth: 1)
        }
    }
    
    var borderShape: some Shape {
        RoundedRectangle(cornerRadius: 8)
    }
    
    var titleLineLimit: Int {
        get {
            return if article.description?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true { // If there's no content to show
                6
            }
            else {
                2
            }
        }
    }
}
