//
//  GridItemView.swift
//  myADD
//
//
//

import SwiftUI

struct GridItemView: View {
    // MARK: - PROPERTY
    @Binding var card: Card
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - BODY
    var body: some View {
        if let image = card.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 160) // 프레임의 크기를 작게 조정
                .background(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? [.white, .gray] : [.gray, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea(.all)
                    .opacity(0.5))
                .cornerRadius(12)
                .padding(.horizontal, 10)
        } else {
            Image(systemName: "camera") // Default image
                .resizable()
                .scaledToFit()
                .padding(20)
                .frame(width: 100, height: 160) // 프레임의 크기를 작게 조정
                .background(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? [.white, .gray] : [.gray, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea(.all)
                    .opacity(0.5))
                .foregroundColor(.secondary)
                .cornerRadius(12)
                .padding(.horizontal, 10)
        }
    }
}



// MARK: - PREVIEW

struct GridItemView_Previews: PreviewProvider {
    
    @State static var card = animationCardsData[1]
    
    static var previews: some View {
        GridItemView(card: $card)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
