//
//  AddCardView.swift
//  myADD
//
//  
// @ iOS 15.0 +

import SwiftUI

struct AddCardView: View {
    // MARK: - PROPERTIES
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = CardViewModel()
    @State private var selectedCardType = CardType.animation
    
    @State private var isCardFlipped = false // 여기에 새로운 상태 변수를 추가
    
    @State private var card: Card = Card(
        title: nil,
        platform: nil,
        genre: nil,
        review: nil,
        image: nil,
        emotion: "",
        date: nil,
        watchPeriodStart: nil,
        watchPeriodEnd: nil,
        watchCount: 0,
        memo: nil
    )
    
    @Binding var animationCardsData: [Card]
    @Binding var dramaCardsData: [Card]
    @Binding var documentaryCardsData: [Card]
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            VStack {
                Picker("카드 유형", selection: $selectedCardType) {
                    ForEach(CardType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Spacer()

                ZStack {
                    AddCardFrontView(card: $card)
                        .opacity(viewModel.frontOpacity)
                        .rotation3DEffect(.degrees(viewModel.frontDegrees), axis: (x: 0, y: 1, z: 0))

                    AddCardBackView(card: $card)
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
            .navigationBarTitle("기록 하기", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("취소")
                },
                trailing: Button(action: {
                    // 선택된 카드 타입에 따른 '데이터' 세트에 카드를 추가
                    switch selectedCardType {
                    case .animation:
                        animationCardsData.append(card)
                    case .drama:
                        dramaCardsData.append(card)
                    case .documentary:
                        documentaryCardsData.append(card)
                    }
                    self.presentationMode.wrappedValue.dismiss() // 저장 후 화면 닫기
                }) {
                    Text("완료")
                }
            )
        } //: NAVIGATION
    }
}

// MARK: - PREVIEW

struct AddCardView_Previews: PreviewProvider {
    static var previews: some View {
        // 예시용 데이터
        let animationCards = [Card(title: "Sample Animation", platform: "Netflix", genre: "Animation", review: "Good", image: nil, emotion: "Happy", date: nil, watchPeriodStart: nil, watchCount: 1, memo: "Sample")]
        let dramaCards = [Card(title: "Sample Drama", platform: "Netflix", genre: "Drama", review: "Good", image: nil, emotion: "Happy", date: nil, watchPeriodStart: nil, watchCount: 1, memo: "Sample")]
        let documentaryCards = [Card(title: "Sample Documentary", platform: "Netflix", genre: "Documentary", review: "Good", image: nil, emotion: "Happy", date: nil, watchPeriodStart: nil, watchCount: 1, memo: "Sample")]

        AddCardView(animationCardsData: .constant(animationCards), dramaCardsData: .constant(dramaCards), documentaryCardsData: .constant(documentaryCards))
    }
}
