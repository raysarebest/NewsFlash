//
//  NoArticlesView.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/9/25.
//

import SwiftUI

struct NoArticlesView: View {
    
    var body: some View {
        ContentUnavailableView {
            Image(systemName: "newspaper.fill")
                .foregroundStyle(.secondary)
            
            Text("article-list.no-content.title",
                 comment: "The title of the screen displayed when there are no articles to show in the list")
        } description: {
            Text("article-list.no-content.description",
                 comment: "The description of the screen displayed when there are no articles to show in the list")
        }
    }
}

#Preview {
    NoArticlesView()
}
