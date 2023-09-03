//
//  AddCardView.swift
//  myADD
//
//  
// @ iOS 15.0 +

import SwiftUI
import UIKit


struct AddCardView: View {
    // MARK: - PROPERTIES
    @State private var card = Card()

    @ObservedObject var viewModel: CardViewModel

    @Environment(\.presentationMode) var presentationMode
    @StateObject var FlipViewModel = CardFlipViewModel()

    @State private var isCardFlipped = false

    @State private var image: UIImage?
    
    @State private var selectedCardType: CardCategory?
    @State private var isButtonPressed = false

    // MARK: - BODY
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    Spacer()
                    Picker("카드 유형", selection: $selectedCardType) {
                        ForEach(CardCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category as CardCategory?)
                        }
                    }
                    .onChange(of: selectedCardType) { newValue in
                        card.category = newValue
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding([.top, .horizontal])

                    Spacer()

                    ZStack {
                        AddCardFrontView(card: $card, viewModel: viewModel, image: $image)
                            .rotation3DEffect(.degrees(FlipViewModel.degrees <= 90 ? FlipViewModel.degrees : 0), axis: (x: 0, y: 1, z: 0))
                            .opacity(FlipViewModel.degrees <= 90 ? 1 : 0)

                        AddCardBackView(card: $card, viewModel: viewModel)
                            .rotation3DEffect(.degrees(FlipViewModel.degrees > 90 ? FlipViewModel.degrees - 180 : -180), axis: (x: 0, y: 1, z: 0))
                            .opacity(FlipViewModel.degrees > 90 ? 1 : 0)
                    }
                    .frame(width: geometry.size.width * 0.85, height: geometry.size.height * 0.7)
                    .cornerRadius(20)
                    .gesture(
                        DragGesture(minimumDistance: 30, coordinateSpace: .local)
                            .onEnded { value in
                                let horizontalAmount = value.translation.width as CGFloat
                                let swipeLength = abs(horizontalAmount)
                                if swipeLength > 100 {
                                    self.isCardFlipped.toggle()
                                    FlipViewModel.flipCard()
                                }
                            }
                    )
                    Spacer()
                    
                    // MARK: - BUTTON
                    Button(action: {
                        print("버튼을 클릭하기 전 card 객체의 상태: \(card)")
                        viewModel.addCard(image: image, card: card) { result in
                            switch result {
                            case .success:
                                self.presentationMode.wrappedValue.dismiss()
                            case .failure:
                                // 에러 처리는 viewModel에서 진행. Alert는 아래에서 설정.
                                break
                            }
                        }
                    }) {
                        Text("완료")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                Group {
                                    if isButtonPressed {
                                        LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.9), Color.red.opacity(0.7)]), startPoint: .top, endPoint: .bottom)

                                    } else {
                                        selectedCardType == nil ? Color.gray : Color.red
                                    }
                                }
                            )
                            .cornerRadius(15)
                    }
                    .disabled(selectedCardType == nil)
                    .scaleEffect(isButtonPressed ? 0.97 : 1.0)
                    .onLongPressGesture(minimumDuration: isButtonPressed ? 0 : 0.5, pressing: { pressing in
                        withAnimation {
                            self.isButtonPressed = pressing
                        }
                    }, perform: {})
                    .padding([.horizontal, .bottom])
                }
                .navigationBarTitle("기록 하기", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.primary)
                    }
                )
            } //: NAVIGATION
        }
        .alert(isPresented: $viewModel.isError, content: {
            Alert(title: Text("Error"),
                  message: Text(viewModel.errorMessage),
                  dismissButton: .default(Text("OK")))
        })
    }
}

