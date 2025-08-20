//
//  Coordinator.swift
//  TheSpaceNews
//
//  Created by Pablo Bertoia      on 19/08/2025.
//
import SwiftUI

extension NewsListView {
    class Coordinator {
        @ViewBuilder
        func getDestination(data: NavigationData) -> some View {
            if let details = data as? Article {
                WebView(urlString: details.url)
                    .accessibilityIdentifier("ArticleWebView")
            }
        }
    }
}
