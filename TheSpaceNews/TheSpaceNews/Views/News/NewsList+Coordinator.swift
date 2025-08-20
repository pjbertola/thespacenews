//
//  Coordinator.swift
//  TheSpaceNews
//
//  Created by Pablo Bertoia      on 19/08/2025.
//
import SwiftUI

extension NewsListView {
    /// Coordinator responsible for handling navigation from the news list to detail views.
    class Coordinator {
        /// Returns the destination view for a given navigation data object.
        /// - Parameter data: The navigation data, typically an `Article`.
        /// - Returns: A SwiftUI view for the navigation destination.

        @ViewBuilder
        func getDestination(data: NavigationData) -> some View {
            if let details = data as? Article {
                WebView(urlString: details.url)
                    .accessibilityIdentifier("ArticleWebView")
            }
        }
    }
}
