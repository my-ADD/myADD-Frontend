//
//  FlippableCardView.swift
//  myADD
//
//
//

import SwiftUI

struct FlippableCardView: View {
    // MARK: - PROPERTY
    
    @Binding var card: Card
    @Binding var cards: [Card]
    @ObservedObject var viewModel = CardViewModel()

    // MARK: - BODY
    
    var body: some View {
        ZStack {
            CardFrontView(card: card)
                .rotation3DEffect(.degrees(viewModel.frontDegrees), axis: (x: 0, y: 1, z: 0))
                .opacity(viewModel.frontOpacity)
            
            CardBackView(card: $card, cards: $cards)
                .rotation3DEffect(.degrees(viewModel.backDegrees), axis: (x: 0, y: 1, z: 0))
                .opacity(viewModel.backOpacity)
        }
        .onTapGesture {
            viewModel.flipCard()
        }
    }
}

// MARK: - PREVIEW

struct FlippableCardView_Previews: PreviewProvider {
    @State static var card = animationCardsData[1]
    @State static var cards = animationCardsData

    static var previews: some View {
        FlippableCardView(card: $card, cards: $cards)
    }
}
