//
//  GridLayoutView.swift
//  myADD
//
//  
// 

import SwiftUI

struct GridLayoutView: View {
    
    // MARK: - PROPERTY
    
    var cards: [Card]
    @EnvironmentObject var viewModel: CardViewModel
    
    @State private var selectedCard: Card? = nil

    let gridLayout: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    
    // MARK: - BODY
    var body: some View {
        Group {
            if let card = selectedCard {
                FlippableCardView(card: card)
                    .environmentObject(viewModel)
                    .onTapGesture {
                        withAnimation(.easeIn) {
                            selectedCard = nil // Tap to close
                        }
                    }
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                        ForEach(cards, id: \.id) { card in
                            GridItemView(card: card)
                                .environmentObject(viewModel)
                                .onTapGesture {
                                    withAnimation(.easeIn) {
                                        selectedCard = card
                                    }
                                }
                        }
                    } //: GRID
                    .padding(10)
                } //: SCROLL
            }
        }
    }
}
