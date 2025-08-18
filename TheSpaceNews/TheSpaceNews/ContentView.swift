//
//  ContentView.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 15/08/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .upcoming

    enum Tab {
        case upcoming
        case list
    }

    var body: some View {
        TabView(selection: $selection) {
            UpcomingHomeView()
                .tabItem {
                    Label("Featured", systemImage: "star")
                }
                .tag(Tab.upcoming)

            NewsListView()
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
                .tag(Tab.list)
        }
    }
}

#Preview {
    ContentView()
}
