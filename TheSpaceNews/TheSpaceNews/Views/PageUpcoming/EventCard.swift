//
//  LaunchCard 2.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//


import Foundation
import SwiftUI

struct EventCard: View {
    var viewModel: ViewModel

    init(eventDetails: EventDetails) {
        self.viewModel = ViewModel(details: eventDetails)
    }
    var body: some View {
        AsyncImage(url: viewModel.imageUrl) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .overlay {
            TextOverlay(viewModel: viewModel)
        }
    }
}
extension EventCard {
    struct TextOverlay: View {
        var viewModel: ViewModel
        
        var gradient: LinearGradient {
            .linearGradient(
                Gradient(colors: [.black.opacity(0.6), .black.opacity(0)]),
                startPoint: .bottom,
                endPoint: .center)
        }
        
        var body: some View {
            ZStack(alignment: .bottomLeading) {
                gradient
                VStack(alignment: .leading) {
                    Text(viewModel.name)
                        .font(.title)
                        .bold()
                    Text(viewModel.dateCounter)
                }
                .padding()
            }
            .foregroundStyle(.white)
        }
    }
}
#Preview {
    let imageArticle = ImageArticle(name: "Crew-10 crew in Dragon",
                                    imageUrl: "https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/crew-10_crew_in_image_20250306075802.jpg",
                                    thumbnailUrl: "https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/crew-10_crew_in_image_thumbnail_20250306075802.jpeg")
    let date = "2025-09-10T08:55:00Z"
    let details = EventDetails(name: "SpaceX Crew-10 Post-Flight News Conference", image: imageArticle, date: date, description: "After spending almost five months.")

    EventCard(eventDetails: details)
        .aspectRatio(3 / 2, contentMode: .fit)
}
