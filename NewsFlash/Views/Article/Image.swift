//
//  Image.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/9/25.
//

import SwiftUI

extension ArticleCard {
    struct Thumbnail: View {
        
        let imageURL: URL?
        
        var body: some View {
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(maxHeight: 100, alignment: .center)
            .clipped()
        }
    }
}
