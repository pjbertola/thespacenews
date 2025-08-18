//
//  UpcomingHomeView.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//

import SwiftUI

struct UpcomingHomeView: View {
    var viewModel: ViewModel
    @State private var error: Error?

    init(repository: UpcomingRepository = SpaceNewsRepositoryDefault()) {
        self.viewModel = ViewModel(repository: repository)
    }
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                LoadingView()
            } else {
                List {
                    Text("Lunches")
                        .font(.headline)
                    TabView {
                        ForEach(viewModel.launches, id: \.self) { launch in
                            NavigationLink(value: launch) {
                                LaunchCard(launchDetails: launch)
                            }
                        }
                    }
                    .tabViewStyle(.page)
                    .aspectRatio(3 / 2, contentMode: .fit)
                    .listRowInsets(EdgeInsets())
                    
                    Text("Events")
                        .font(.headline)
                    TabView {
                        ForEach(viewModel.events, id: \.self) { event in
                            NavigationLink(value: event) {
                                EventCard(eventDetails: event)
                            }
                        }
                    }
                    .tabViewStyle(.page)
                    .aspectRatio(3 / 2, contentMode: .fit)
                    .listRowInsets(EdgeInsets())
                }
                .listStyle(.inset)
                .navigationTitle("Upcoming")
                .navigationDestination(for: LaunchDetails.self) { launchDetails in LaunchDetailView(launchDetails: launchDetails)
                }
                .navigationDestination(for: EventDetails.self) { eventDetails in EventDetailView(eventDetails: eventDetails)
                }
                .refreshable {
                    await viewModel.onRefresh(viewError: $error)
                }
                .errorAlert(error: $error) {
                    Task {
                        await viewModel.onAppear(viewError: $error)
                    }
                }
            }
        }
        .task {
            await viewModel.onAppear(viewError: $error)
        }
    }
}

#Preview {
    UpcomingHomeView()
}
