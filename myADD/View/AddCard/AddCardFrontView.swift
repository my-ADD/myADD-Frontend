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
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer()
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                        .padding()
                        .onTapGesture { // 추가
                            isShowingImagePicker = true
                        }
                } else {
                    Image(systemName: "camera") // Default image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            isShowingImagePicker = true
                        }
                }
                Spacer()
                
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
                .padding(.bottom)
                .padding(.horizontal)   // 텍스트 뷰 가로 공간 확보
                
                Spacer()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? [.gray.opacity(0.3), .white] : [.gray.opacity(0.7), .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea(.all)
            .opacity(0.85)
        )
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: $image)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

