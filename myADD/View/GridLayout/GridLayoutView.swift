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
        GeometryReader { geometry in
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                        ForEach(cards, id: \.id) { card in
                            NavigationLink(
                                destination:
                                    GridItemView(card: card)
                                    //GridDetailView(card: card)
                                    .scaleEffect(0.9)
                                    .frame(width: geometry.size.width * 0.8, height: (geometry.size.width * 0.8) * 1.5)
                                    .environmentObject(viewModel)
                            ){
                                GridItemView(card: card)
                                    .environmentObject(viewModel)
                            }
                            .isDetailLink(false)
                            .buttonStyle(PlainButtonStyle())
                            .navigationTitle("")
                        }
                    } //: GRID
                    .padding(10)
                } //: SCROLL
            } //: NAVIGATION
        }
    }
}

