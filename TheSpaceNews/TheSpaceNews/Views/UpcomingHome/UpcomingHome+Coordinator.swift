//
//  UpcomingHome+Coordinator.swift
//  TheSpaceNews
//
//  Created by Pablo Bertoia      on 19/08/2025.
//

import Foundation
import SwiftUI

protocol NavigationData {
    // Used only as identifier
}

extension UpcomingHomeView {
    class Coordinator {
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
