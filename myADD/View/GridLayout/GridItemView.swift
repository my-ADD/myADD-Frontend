//
//  GridItemView.swift
//  myADD
//
//
//

import SwiftUI
import SDWebImageSwiftUI


struct GridItemView: View {
    // MARK: - PROPERTY
    var card: Card
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - BODY
    var body: some View {
        
        WebImage(url: card.image?.encodedImageURL())
            .onSuccess { image, data, cacheType in
                // Success
            }
            .resizable()
            .placeholder {
                Image(systemName: "camera")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            }

        
            .indicator { _, _ in
                ProgressView()
            }
            .scaledToFill()
            .frame(width: 100, height: 160)
            .background(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? [.white, .gray] : [.gray, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea(.all)
                .opacity(0.5))
            .cornerRadius(12)
            .padding(.horizontal, 10)
    }
}
