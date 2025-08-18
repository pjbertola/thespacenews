//
//  UpcomingHomeView.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//

import SwiftUI

struct UpcomingHomeView: View {
    var viewModel: ViewModel
    init(repository: UpcomingRepository = SpaceNewsRepositoryDefault()) {
        self.viewModel = ViewModel(repository: repository)
    }
    var body: some View {
        NavigationSplitView {
            List {
                Text("Lunches")
                    .font(.headline)
                TabView {
                    ForEach(viewModel.launches, id: \.self) { launch in
                        LaunchCard(launchDetails: launch)
                    }
                }
                .tabViewStyle(.page)
                .aspectRatio(3 / 2, contentMode: .fit)
                .listRowInsets(EdgeInsets())
                Text("Events")
                    .font(.headline)
                TabView {
                    ForEach(viewModel.events, id: \.self) { event in
                        EventCard(eventDetails: event)
                    }
                }
                .tabViewStyle(.page)
                .aspectRatio(3 / 2, contentMode: .fit)
                .listRowInsets(EdgeInsets())
                }
            .listStyle(.inset)
            .navigationTitle("Upcoming")
        } detail: {
            Text("Select an upcoming lunch or event.")
        }.task {
            await viewModel.onAppear()
        }
    }
}

#Preview {
    UpcomingHomeView()
}
