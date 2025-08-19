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
            // Check if the app is running in a custom UI test environment
            if ProcessInfo().isCustomUITestedView {
                UpcomingHomeView(repository: SpaceNewsRepositoryDefault(apiClient: .mock))
                    .tabItem {
                        Label("Upcoming", systemImage: "star")
                    }
                    .tag(Tab.upcoming)
                
                NewsListView(repository: SpaceNewsRepositoryDefault(apiClient: .mock))
                    .tabItem {
                        Label("List", systemImage: "list.bullet")
                    }
                    .tag(Tab.list)
            } else {
                UpcomingHomeView()
                    .tabItem {
                        Label("Upcoming", systemImage: "star")
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
}

#Preview {
    ContentView()
}

//  Check if the app is running in a custom UI test environment
extension ProcessInfo {
    var isCustomUITestedView: Bool {
        return environment["MyUITestsCustomView"] == "true"
    }
}
