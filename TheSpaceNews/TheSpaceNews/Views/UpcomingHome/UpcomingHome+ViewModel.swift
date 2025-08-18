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
        var launches: [LaunchDetails] = []
        var events: [EventDetails] = []
        var isLoading: Bool = true

        init(repository: UpcomingRepository = SpaceNewsRepositoryDefault()) {
            self.repository = repository
        }

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
    }
}
