//
//  LoadingView.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black)
                .opacity(0.75)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                Text("Loading...")
                    .font(.headline)
            }
            .background {
                RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .frame(width: 150, height: 150)
            }
            .offset(y: -70)
        }
    }
}
