//
//  GridLayoutView.swift
//  myADD
//
//  
// onboardingView 와 호환

import SwiftUI

struct GridLayoutView: View {
    // MARK: - PROPERTY
    @Binding var cards: [Card]
    let gridLayout: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    
    // MARK: - BODY
    var body: some View {
        withAnimation(.easeIn) {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                    ForEach(cards) { item in
                        if let itemIndex = cards.firstIndex(where: { $0.id == item.id }) {
                            NavigationLink(destination: FlippableCardView(card: $cards[itemIndex], cards: $cards)) {
                                GridItemView(card: $cards[itemIndex])
                            } //: LINK
                        }
                    } //: LOOP
                } //: GRID
                .padding(10)
            } //: SCROLL
        }
    }
}



// MARK: - PREVIEW

struct GridLayoutView_Previews: PreviewProvider {

    @State static var cards = animationCardsData

    static var previews: some View {
        GridLayoutView(cards: $cards)
    }
}
