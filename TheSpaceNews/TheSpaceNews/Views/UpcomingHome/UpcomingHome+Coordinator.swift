//
//  UpcomingHome+Coordinator.swift
//  TheSpaceNews
//
//  Created by Pablo Bertoia      on 19/08/2025.
//

import Foundation
import SwiftUI

/// Protocol used as a marker for navigation data types.
/// Conforming types are used to identify navigation destinations in the coordinator.
protocol NavigationData {
    // Used only as identifier
}

extension UpcomingHomeView {
    /// Handles navigation logic for UpcomingHomeView.
    class Coordinator {
        /// Returns the destination view based on the provided navigation data.
        /// - Parameter data: An object conforming to `NavigationData` used to determine the destination.
        @ViewBuilder
        func getDestination(data: NavigationData) -> some View {
            if let details = data as? LaunchDetails {
                LaunchDetailView(launchDetails: details)
            } else if let details = data as? EventDetails {
                EventDetailView(eventDetails: details)
            }
        }
    }
}
