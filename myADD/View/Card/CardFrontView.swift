//
//  CardFrontView.swift
//  myADD
//
//  
//

import SwiftUI
import SDWebImageSwiftUI

struct CardFrontView: View {
    // MARK: - PROPERTY
    
    var card: Card
    
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            WebImage(url: card.image?.encodedImageURL())
                .onSuccess { image, data, cacheType in
                    // Success
                }
                .resizable()
                .placeholder {
                    Image(systemName: "camera")
                        .resizable()
                        .foregroundColor(.primary)
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
            
                .indicator { _, _ in
                    ProgressView() // 이미지 로딩 중에 ProgressView
                }
                .transition(.fade(duration: 0.5))
                .scaledToFill()
                .frame(width: 280, height: 400)  // 이미지 크기 조정
                .cornerRadius(20)
                .clipped()
            
            Text(card.comment?.isEmpty ?? true ? "한 줄 평을 작성해주세요." : card.comment!)
                .multilineTextAlignment(.leading)
                .font(.headline)
                .fontWeight(.black)
                .opacity(0.85)
                .padding(.horizontal, 20)
                .padding(.bottom)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? [.gray, .white] : [.gray, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea(.all)
            .opacity(0.15)
                    
        )
    }
}
