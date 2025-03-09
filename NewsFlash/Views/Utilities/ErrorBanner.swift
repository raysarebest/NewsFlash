//
//  ErrorBanner.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/9/25.
//

import SwiftUI

struct ErrorBanner: View {
    
    let error: any Error
    
    var body: some View {
        HStack {
            Label {
                Text(error.localizedDescription)
            } icon: {
                Image(systemName: "exclamationmark.triangle.fill")
            }
            .padding()
            .foregroundStyle(.white)
            
            Spacer()
        }
        .background(.red)
    }
}

#Preview {
    ErrorBanner(error: CancellationError())
}
