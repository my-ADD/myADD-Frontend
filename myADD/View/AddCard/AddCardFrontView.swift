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
    @ObservedObject var viewModel: CardViewModel

    // 이미지 관련
    @Binding var image: UIImage?
    @State private var isShowingImagePicker = false
    @Environment(\.colorScheme) var colorScheme
    @State private var presentAlert = false
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            // 이미지 추가 부분
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 330)  // 이미지 크기 조정
                    .cornerRadius(20)
                    .clipped()
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
                    get: { card.comment ?? "" },
                    set: {
                        if $0.count > 25 {
                            card.comment = String($0.prefix(25))
                        } else {
                            card.comment = $0
                        }
                    }
                ))
                .multilineTextAlignment(.center)
                .font(.headline)
                .fontWeight(.black)
                .foregroundColor(.primary)
                .opacity(0.85)
                
                Text("\(card.comment?.count ?? 0)/25")
                    .font(.footnote)
                    .foregroundColor((card.comment?.count ?? 0) >= 20 ? .red : .secondary)
            }
            .padding(.bottom, 100)
            .padding(.horizontal, 20)   // 텍스트 뷰 가로 공간 확보
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? [.gray, .white] : [.gray, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea(.all)
            .opacity(0.15)
        )
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: $image)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

