//
//  WebView.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//


import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        // Optional: Set a coordinator as the navigation delegate
        // webView.navigationDelegate = context.coordinator 
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }

    // Optional: Implement makeCoordinator() and a Coordinator class
    // func makeCoordinator() -> Coordinator {
    //     Coordinator(self)
    // }

    // class Coordinator: NSObject, WKNavigationDelegate {
    //     var parent: WebView
    //     init(_ parent: WebView) {
    //         self.parent = parent
    //     }
    //     // Implement delegate methods here
    // }
}
