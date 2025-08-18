//
//  PageView.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 17/08/2025.
//

import SwiftUI

struct PageView<Page: View>: View {
    var pages: [Page]
    @State private var currentPage = 0

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PageViewController(pages: pages, currentPage: $currentPage)
            PageControl(numberOfPages: pages.count, currentPage: $currentPage)
                .frame(width: CGFloat(pages.count * 18))
                .padding(.trailing)
        }
        .aspectRatio(3 / 2, contentMode: .fit)
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
    let details2 = LaunchDetails(name: "Long March 4C | Shiyan 28 B-02 (SECOND)",
                  image: imageArticle, status: status, net: net, mission: mission)
    let details3 = LaunchDetails(name: "Long March 4C | Shiyan 28 B-02 (THIRD)",
                  image: imageArticle, status: status, net: net, mission: mission)
    let launchCard = LaunchCard(launchDetails: details)
    let launchCard2 = LaunchCard(launchDetails: details2)
    let launchCard3 = LaunchCard(launchDetails: details3)
    
    PageView(pages:[launchCard, launchCard2, launchCard3] )
}
