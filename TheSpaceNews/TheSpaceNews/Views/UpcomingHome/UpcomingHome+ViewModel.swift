//
//  UpcomingHome+ViewModel.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//

import Foundation
import Combine

extension UpcomingHomeView {
    @Observable
    class ViewModel {
        private let repository: UpcomingRepository
        var launches: [LaunchDetails] = []
        var events: [EventDetails] = []
        var isLoading: Bool = true
        var error: Error?

        init(repository: UpcomingRepository = SpaceNewsRepositoryDefault()) {
            self.repository = repository
        }

        func onAppear() async {
            do {
                async let launchDetails = try await repository.fetchLaunches()
                async let eventDetails = try await repository.fetchEvents()
                launches = try await launchDetails
                events = try await eventDetails
                isLoading = false
            } catch {
                self.error = error
            }
        }
    }
}
