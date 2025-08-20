//
//  ContentView.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 15/08/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .upcoming
    private var upcomingApiClient: ServiceApiClient = {
        .live
    }()
    private var newsApiClient: ServiceApiClient = .live
    
    enum Tab {
        case upcoming
        case list
    }
    
    var body: some View {
        TabView(selection: $selection) {
            #if DEBUG
            // Check if the app is running in a custom UI test environment
            UpcomingHomeView(repository: SpaceNewsRepositoryDefault(apiClient: ProcessInfo().customUITestedUpcoming))
                .tabItem {
                    Label("Upcoming", systemImage: "star")
                }
                .tag(Tab.upcoming)
            
            NewsListView(repository: SpaceNewsRepositoryDefault(apiClient: ProcessInfo().customUITestedNews))
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
                .tag(Tab.list)
            #else
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
            #endif
        }
    }
}

#Preview {
    ContentView()
}

#if DEBUG
//  Check if the app is running in a custom UI test environment
extension ProcessInfo {
    var customUITestedUpcoming: ServiceApiClient {
        return getCustomUITestedApi(raw: environment["customUITestedUpcoming"])
    }
    var customUITestedNews: ServiceApiClient {
        return getCustomUITestedApi(raw: environment["customUITestedNews"])
    }
    private func getCustomUITestedApi(raw: String?) -> ServiceApiClient {
        guard let raw = raw else {
            return .live
        }
        if let serviceApi = ServiceApiClient(rawValue: raw) {
            return serviceApi
        } else {
            return .live
        }
    }
}
#endif
