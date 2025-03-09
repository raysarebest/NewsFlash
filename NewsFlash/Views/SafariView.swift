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
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = false
        configuration.entersReaderIfAvailable = true
        
        return SFSafariViewController(url: url, configuration: configuration)    }
    
    func updateUIViewController(_ controller: UIViewControllerType, context: Context) {}
}

#Preview {
    SafariView(url: URL(string: "https://www.cleferpiano.app")!)
}
