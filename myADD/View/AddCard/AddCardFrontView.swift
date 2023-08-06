//
//  AddCardFrontView.swift
//  myADD
//
//  
//

import SwiftUI

// MARK: - FRONT VIEW

struct AddCardFrontView: View {
    // MARK: - PROPERTY

    @Binding var card: Card
    @State private var isShowingImagePicker = false
    @Environment(\.colorScheme) var colorScheme
    @State private var presentAlert = false
    
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
//                    .padding(.horizontal, 10)
                    .onTapGesture { // 추가
                        isShowingImagePicker = true
                    }
            } else {
                Image(systemName: "camera") // Default image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 250)
                    .onTapGesture {
                        isShowingImagePicker = true
                    }
            }
            
            VStack {
                TextField("한 줄 평을 입력해주세요", text: Binding<String>(
                    get: { card.review ?? "" },
                    set: {
                        if $0.count > 25 {
                            card.review = String($0.prefix(25))
                        } else {
                            card.review = $0
                        }
                    }
                ))
                .multilineTextAlignment(.center)
                .font(.headline)
                .fontWeight(.black)
                .foregroundColor(.primary)
                .opacity(0.85)
                
                Text("\(card.review?.count ?? 0)/25")
                    .font(.footnote)
                    .foregroundColor((card.review?.count ?? 0) >= 20 ? .red : .secondary)
            }
            .padding(.bottom, 100)
            .padding(.horizontal, 20)   // 텍스트 뷰 가로 공간 확보
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? [.white, .gray] : [.gray, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea(.all)
            .opacity(0.2))
        .cornerRadius(20)
        .padding(.horizontal, 20) // 카드 간 간격
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: $card.image)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}
