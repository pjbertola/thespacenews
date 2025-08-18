//
//  EventDetailView.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//


import SwiftUI

struct EventDetailView: View {
    @State var eventDetails: EventDetails
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: eventDetails.image.imageUrl)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(3 / 2, contentMode: .fit)
                Text(eventDetails.name)
                    .font(.title)
                    .bold()
                    .padding()
                Text(eventDetails.date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.bottom)
                Text(eventDetails.description)
                    .padding()
                
            }
        }
    }
}

#Preview {
//    EventDetailView()
}
