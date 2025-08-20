//
//  LaunchCard.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 17/08/2025.
//

import Foundation
import SwiftUI

/// A card view displaying a launch image with overlayed launch information.
struct LaunchCard: View {
    var viewModel: ViewModel
    /// Initializes the card with launch details.
    /// - Parameter launchDetails: The details of the launch to display.
    init(launchDetails: LaunchDetails) {
        self.viewModel = ViewModel(details: launchDetails)
    }
    var body: some View {
        CachedAsyncImage(url: viewModel.imageUrl)
        .overlay {
            TextOverlay(viewModel: viewModel)
        }


    }
}
extension LaunchCard {
    /// An overlay view displaying launch status, name, and countdown on top of the image.
    struct TextOverlay: View {
        var viewModel: ViewModel
        
        var gradient: LinearGradient {
            .linearGradient(
                Gradient(colors: [.black.opacity(0.6), .black.opacity(0)]),
                startPoint: .bottom,
                endPoint: .center)
        }
        
        var body: some View {
            ZStack (alignment: .topTrailing) {
                Text(viewModel.statusAbbrev)
                    .padding(3)
                    .background(Color.cyan)
                    .cornerRadius(10)
                    .foregroundStyle(.white)
                    .padding(5)
                ZStack(alignment: .bottomLeading) {
                    gradient
                    VStack(alignment: .leading) {
                        Text(viewModel.name)
                            .font(.title)
                            .bold()
                        Text(viewModel.netCounter)
                    }
                    .padding()
                }
                .foregroundStyle(.white)
            }
        }
    }
}
#Preview {
    let imageArticle = ImageArticle(name: "[AUTO] Long March 4C - image",
                                    imageUrl: "https://thespacedevs-dev.nyc3.digitaloceanspaces.com/media/images/long_march_4c_image_20230801172338.jpeg",
                                    thumbnailUrl: "https://thespacedevs-dev.nyc3.digitaloceanspaces.com/media/images/255bauto255d__image_thumbnail_20240305193732.jpeg")
    let status = Status(abbrev: "Success", name: "Launch Successful")
    let net = "2025-09-17T08:55:00Z"
    let mission = Mission(description: "Satellite officially named for \"space environment detection\" purposes, exact details unknown.")
    let details = LaunchDetails(name: "Long March 4C | Shiyan 28 B-02",
                  image: imageArticle, status: status, net: net, mission: mission)

    LaunchCard(launchDetails: details)
        .aspectRatio(3 / 2, contentMode: .fit)
}
