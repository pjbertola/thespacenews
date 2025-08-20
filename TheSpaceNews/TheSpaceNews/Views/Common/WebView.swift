//
//  WebView.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//


import SwiftUI
import WebKit

/// Wraps a WKWebView to display web content from a URL.
struct WebView: UIViewRepresentable {
    let urlString: String

    /// Creates and returns a WKWebView instance.
    /// - Parameter context: The context for coordinating with UIKit.
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    /// Updates the WKWebView with a new URL request if the URL is valid.
    /// - Parameters:
    ///   - uiView: The WKWebView instance to update.
    ///   - context: The context for coordinating with UIKit.
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
