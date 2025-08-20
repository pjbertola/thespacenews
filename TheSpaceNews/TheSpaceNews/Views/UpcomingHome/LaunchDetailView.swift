//
//  LaunchDetailView.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//

import SwiftUI

/// A view that displays detailed information about a specific launch.
struct LaunchDetailView: View {
    @State var launchDetails: LaunchDetails
    var body: some View {
        ScrollView {
            VStack {
                CachedAsyncImage(url: URL(string: launchDetails.image.imageUrl))
                .aspectRatio(3 / 2, contentMode: .fit)
                // Overlay showing the launch status in the top-right corner.
                .overlay(alignment: .topTrailing) {
                    Text(launchDetails.status.name)
                        .padding(3)
                        .background(Color.cyan)
                        .cornerRadius(10)
                        .foregroundStyle(.white)
                        .padding(5)
                }
                Text(launchDetails.name)
                    .font(.title)
                    .bold()
                    .padding()
                Text(launchDetails.net)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.bottom)
                Text(launchDetails.mission.description)
                    .padding()
                
            }
        }
    }
}

#Preview {
    //    LaunchDetailView()
}
