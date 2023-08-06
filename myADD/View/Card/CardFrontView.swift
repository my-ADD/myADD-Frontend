//
//  CardFrontView.swift
//  myADD
//
//  
//

import SwiftUI

struct CardFrontView: View {
    // MARK: - PROPERTY
    
    var card: Card
    @Environment(\.colorScheme) var colorScheme

    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            if let image = card.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 280, height: 400)
                    .cornerRadius(20)
                    .clipped()
//                    .padding(.top, 10)
//                    .padding(.horizontal, 10)
            } else {
                Image(systemName: "camera") // Default image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 250)
            }
            
            Text(card.review ?? "한 줄 평을 작성해주세요.")
                .multilineTextAlignment(.center)
                .font(.headline)
                .fontWeight(.black)
                .opacity(0.85)
                .padding(.horizontal, 20)   // 텍스트 뷰 가로 공간 확보
                .padding(.bottom)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? [.white, .gray] : [.gray, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea(.all)
            .opacity(0.2))
        .cornerRadius(20)
        .padding(.horizontal, 20) // 카드 간 간격
    }
}

// MARK: - PREVIEW

struct CardFrontView_Previews: PreviewProvider {
    static var previews: some View {
        CardFrontView(card: animationCardsData[2])
    }
}

