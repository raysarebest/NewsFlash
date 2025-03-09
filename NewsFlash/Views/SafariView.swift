//
//  SafariView.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/9/25.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    
    let url: URL
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ controller: UIViewControllerType, context: Context) {}
}
