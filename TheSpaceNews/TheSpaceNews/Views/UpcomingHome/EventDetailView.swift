//
//  EventDetailView.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//


import SwiftUI

/// A view that displays detailed information about a specific event.
struct EventDetailView: View {
    @State var eventDetails: EventDetails
    var body: some View {
        ScrollView {
            VStack {
                CachedAsyncImage(url: URL(string: eventDetails.image.imageUrl))
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
