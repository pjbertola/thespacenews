//
//  LaunchCard+ViewModel.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 17/08/2025.
//

import Foundation
import Combine

extension LaunchCard {
    @Observable
    class ViewModel {
        private let details: LaunchDetails
        let name: String
        let statusAbbrev: String
        var netCounter: String = ""
        let imageUrl: URL?
        private var timer: AnyCancellable?

        init(details: LaunchDetails) {
            self.details = details
            self.name = details.name
            self.statusAbbrev = details.status.abbrev
            self.imageUrl = URL(string: details.image.imageUrl)
            setUpTimer()
        }

        private func setUpTimer() {
            guard let netDate = Date.fromFormattedISO8601(details.net) else { return }
            timer?.cancel()
            timer = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    let now = Date()
                    let diff = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: netDate)
                    if let day = diff.day, let hour = diff.hour, let min = diff.minute, let sec = diff.second {
                        if now < netDate {
                            self.netCounter = "T - \(day)d \(hour)h \(min)m \(sec)s"
                        } else {
                            self.netCounter = "Launched"
                            self.timer?.cancel()
                        }
                    }
                }
        }

        deinit {
            timer?.cancel()
        }
    }

}

