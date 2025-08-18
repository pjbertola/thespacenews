//
//  ArticleRow+ViewModel.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 17/08/2025.
//

import Foundation
import Combine
//
//extension ArticleRowView {
//    @Observable
//    class ViewModel {
//        private let article: Article
//        let name: String
//        let statusAbbrev: String
//        let net: String
//        var netCounter: String = ""
//        let imageName: String
//        let thumbnailUrl: URL?
//        private var timer: AnyCancellable?
//        
//        init(article: Article) {
//            self.article = article
//            self.name = article.name
//            self.statusAbbrev = article.status.abbrev
//            if let date = Date.fromFormattedISO8601(article.net) {
//                self.net = date.formattedDate()
//            } else {
//                self.net = ""
//            }
//            self.imageName = article.image.name
//            self.thumbnailUrl = URL(string: article.image.thumbnailUrl)
//            setUpTimer()
//        }
//
//        private func setUpTimer() {
//            guard let netDate = Date.fromFormattedISO8601(article.net) else { return }
//            timer?.cancel()
//            timer = Timer.publish(every: 1, on: .main, in: .common)
//                .autoconnect()
//                .sink { [weak self] _ in
//                    guard let self = self else { return }
//                    let now = Date()
//                    let diff = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: netDate)
//                    if let day = diff.day, let hour = diff.hour, let min = diff.minute, let sec = diff.second {
//                        if now < netDate {
//                            self.netCounter = "T - \(day)d \(hour)h \(min)m \(sec)s"
//                        } else {
//                            self.netCounter = "Launched"
//                            self.timer?.cancel()
//                        }
//                    }
//                }
//        }
//
//        deinit {
//            timer?.cancel()
//        }
//    }
//
//}
//
