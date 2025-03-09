//
//  Thumbnail.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/9/25.
//

import SwiftUI

extension ArticleCard {
    struct Thumbnail: View {
        
        let imageURL: URL?
        
        @ScaledMetric private var imageHeight: CGFloat = 100
        
        var body: some View {
            AsyncImage(url: imageURL) { image in
                placeholderBackground
                    .overlay {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .clipped()
                
            } placeholder: {
                placeholderBackground
            }
            .frame(height: imageHeight, alignment: .center)
        }
        
        @ViewBuilder var placeholderBackground: some View {
            Color.gray
        }
    }
}

#Preview {
    ArticleCard.Thumbnail(imageURL: URL(string: "https://wtop.com/wp-content/uploads/2025/03/APTOPIX_97th_Academy_Awards_91183-scaled.jpg"))
}
