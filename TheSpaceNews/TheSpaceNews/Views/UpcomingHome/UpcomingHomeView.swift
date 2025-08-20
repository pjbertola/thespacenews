//
//  UpcomingHomeView.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//

import SwiftUI

/// The main view displaying upcoming launches and events.
struct UpcomingHomeView: View {
    /// The view model managing launches, events, and loading state.
    var viewModel: ViewModel
    
    /// Holds any error that occurs during data loading.
    @State private var error: Error?

    /// Initializes the view with a repository, defaulting to SpaceNewsRepositoryDefault.
    /// - Parameter repository: The repository to fetch data from.
    init(repository: UpcomingRepository = SpaceNewsRepositoryDefault()) {
        self.viewModel = ViewModel(repository: repository)
    }
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                LoadingView()
            } else {
                List {
                    // Section for upcoming launches.
                    Text("Lunches")
                        .font(.headline)
                    TabView {
                        ForEach(viewModel.launches, id: \.self) { launch in
                            NavigationLink(value: launch) {
                                LaunchCard(launchDetails: launch)
                                    .accessibilityIdentifier(launch.name)
                            }
                        }
                    }
                    .accessibilityIdentifier("TabViewLaunches")
                    .tabViewStyle(.page)
                    .aspectRatio(3 / 2, contentMode: .fit)
                    .listRowInsets(EdgeInsets())

                    // Section for upcoming events.
                    Text("Events")
                        .font(.headline)
                    TabView {
                        ForEach(viewModel.events, id: \.self) { event in
                            NavigationLink(value: event) {
                                EventCard(eventDetails: event)
                                    .accessibilityIdentifier(event.name)
                            }
                        }
                    }
                    .accessibilityIdentifier("TabViewEvents")
                    .tabViewStyle(.page)
                    .aspectRatio(3 / 2, contentMode: .fit)
                    .listRowInsets(EdgeInsets())
                }
                .listStyle(.inset)
                .navigationTitle("Upcoming")
                .navigationDestination(for: LaunchDetails.self) { launchDetails in
                    // Navigation destination for launch details.
                    viewModel.getDestination(data: launchDetails)
                }
                .navigationDestination(for: EventDetails.self) { eventDetails in
                    // Navigation destination for event details.
                    viewModel.getDestination(data: eventDetails)
                }
                .refreshable {
                    // Pull-to-refresh functionality.
                    Task {
                        await viewModel.onRefresh(viewError: $error)
                    }
                }
                // Error alert handling.
                .errorAlert(error: $error) {
                    Task {
                        await viewModel.onAppear(viewError: $error)
                    }
                }
            }
        }
        // Load data when the view appears.
        .task {
            await viewModel.onAppear(viewError: $error)
        }
    }
}

#Preview {
    UpcomingHomeView()
}
