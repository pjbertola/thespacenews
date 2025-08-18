//
//  ArticleRowView.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 17/08/2025.
//

import SwiftUI

struct ArticleRowView: View {
    @State private var viewModel: ViewModel
    init(article: Article) {
        self.viewModel = ArticleRowView.ViewModel(article: article)
    }
    var body: some View {
        HStack {
            AsyncImage(url: viewModel.thumbnailUrl) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
            } placeholder: {
                ProgressView()
            }

            VStack {
                HStack {
                    Text(viewModel.name)
                        .font(.headline)
                        .bold()
                    Text(viewModel.statusAbbrev)
                        .padding(3)
                        .background(Color.cyan)
                        .cornerRadius(10)
                        
                        
                }
                Text(viewModel.netCounter)
                    .font(.headline)
                Text(viewModel.net)
                    .font(.caption)
                
            }
        }
    }
}

#Preview {
    let image = ImageArticle(name: "Launch", imageUrl: "https://thespacedevs-dev.nyc3.digitaloceanspaces.com/media/images/falcon2520925_image_20221009234147.png", thumbnailUrl: "https://thespacedevs-dev.nyc3.digitaloceanspaces.com/media/images/255bauto255d__image_thumbnail_20240305192320.png")

    let article = Article(id: "1", url: "asd", name: "Test Article", status: Status(abbrev: "GO", name: "GO"), net: "2025-10-20T17:13:00Z", image: image)
    ArticleRowView(article: article)
}
