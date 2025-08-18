//
//  ViewModel.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//

import Foundation
import Combine

extension EventCard {
    @Observable
    class ViewModel {
        private let details: EventDetails
        let name: String
        var dateCounter: String = ""
        let imageUrl: URL?
        private var timer: AnyCancellable?

        init(details: EventDetails) {
            self.details = details
            self.name = details.name
            self.imageUrl = URL(string: details.image.imageUrl)
            setUpTimer()
        }

        private func setUpTimer() {
            guard let netDate = Date.fromFormattedISO8601(details.date) else { return }
            timer?.cancel()
            timer = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    let now = Date()
                    let diff = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: netDate)
                    if let day = diff.day, let hour = diff.hour, let min = diff.minute, let sec = diff.second {
                        if now < netDate {
                            self.dateCounter = "T - \(day)d \(hour)h \(min)m \(sec)s"
                        } else {
                            self.dateCounter = "Launched"
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

