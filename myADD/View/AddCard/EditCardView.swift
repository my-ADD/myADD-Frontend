//
//  EditCardView.swift
//  myADD
//
//  
//

import SwiftUI

struct EditCardView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = CardViewModel()
    
    @Binding var card: Card
    @State private var tempCard: Card // 원본 카드의 복사본을 만들고 사용자가 카드를 편집하는 동안 이 복사본을 변경

    init(card: Binding<Card>) {
        _card = card
        _tempCard = State(initialValue: card.wrappedValue)
    }
    
    @State private var isCardFlipped = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                // Use tempCard instead of card
                ZStack {
                    AddCardFrontView(card: $tempCard)
                        .opacity(viewModel.frontOpacity)
                        .rotation3DEffect(.degrees(viewModel.frontDegrees), axis: (x: 0, y: 1, z: 0))

                    AddCardBackView(card: $tempCard)
                        .opacity(viewModel.backOpacity)
                        .rotation3DEffect(.degrees(viewModel.backDegrees), axis: (x: 0, y: 1, z: 0))
                }
                .gesture(
                    DragGesture(minimumDistance: 30, coordinateSpace: .local)
                        .onEnded { value in
                            let horizontalAmount = value.translation.width as CGFloat
                            let swipeLength = abs(horizontalAmount) // absolute value to allow for left and right swipes

                            // Check if swipe length is above threshold
                            if swipeLength > 100 {
                                self.isCardFlipped.toggle()
                                viewModel.flipCard()
                            }
                        }
                )
            }
            .navigationBarTitle("기록 수정하기", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    // Don't need to do anything here anymore, just dismiss
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("취소")
                },
                trailing: Button(action: {
                    // Copy the contents of tempCard back to card
                    self.card = self.tempCard
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("완료")
                }
            )
            .onAppear {
                // Copy the contents of card to tempCard
                self.tempCard = self.card
            }
        } //: NAVIGATION
    }
}

//// MARK: - PREVIEW
//
//struct EditCardView_Previews: PreviewProvider {
//
//    @State static var card = animationCardsData[1]
//
//    static var previews: some View {
//        EditCardView(card: $card)
//    }
//}
