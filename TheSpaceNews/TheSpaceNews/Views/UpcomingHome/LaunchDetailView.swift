//
//  LaunchDetailView.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//

import SwiftUI

struct LaunchDetailView: View {
    @State var launchDetails: LaunchDetails
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: launchDetails.image.imageUrl)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .aspectRatio(3 / 2, contentMode: .fit)
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

#Preview {
    //    LaunchDetailView()
}
