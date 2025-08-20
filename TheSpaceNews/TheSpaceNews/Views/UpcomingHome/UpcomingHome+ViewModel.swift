//
//  UpcomingHome+ViewModel.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//

import Foundation
import Combine
import SwiftUI

extension UpcomingHomeView {
    @Observable
    class ViewModel {
        private let repository: UpcomingRepository
        private let coordinator: Coordinator = Coordinator()
        var launches: [LaunchDetails] = []
        var events: [EventDetails] = []
        var isLoading: Bool = true
        
        /// Initializes the ViewModel with a repository.
        /// - Parameter repository: The repository to fetch data from. Defaults to SpaceNewsRepositoryDefault.
        init(repository: UpcomingRepository = SpaceNewsRepositoryDefault()) {
            self.repository = repository
        }

        /// Refreshes the data by clearing the cache and reloading launches and events.
        /// - Parameter viewError: Binding to an error object for error handling.
        func onRefresh(viewError: Binding<Error?>) async {
            repository.clearCache()
            await onAppear(viewError: viewError)
        }

        /// Loads launches and events asynchronously, updating the loading state and handling errors.
        /// - Parameter viewError: Binding to an error object for error handling.
        func onAppear(viewError: Binding<Error?>) async {
            do {
                isLoading = true
                async let launchDetails = try await repository.fetchLaunches()
                async let eventDetails = try await repository.fetchEvents()
                launches = try await launchDetails
                events = try await eventDetails
                isLoading = false
            } catch {
                isLoading = false
                viewError.wrappedValue = error
            }
        }

        /// Returns the destination view for navigation based on the provided data.
        /// - Parameter data: Navigation data to determine the destination.
        func getDestination(data: NavigationData) -> some View {
            coordinator.getDestination(data: data)
        }
    }
}
