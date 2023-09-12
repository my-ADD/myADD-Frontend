//
//  CardPaperView.swift
//  myADD
//
//  
//

import SwiftUI
import SwiftUIPager


struct CardPaperView: View {
    var cards: [Card]

    @State private var selectedCardIndex: Page = .first()
    @EnvironmentObject var viewModel: CardViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Pager(page: selectedCardIndex, data: cards, id: \.onboardingViewID) { card in
                    FlippableCardView(card: card)
                        .frame(width: geometry.size.width * 0.8, height: (geometry.size.width * 0.8) * 1.5) // 세로 크기를 가로 크기의 1.5배로 조절
                        .environmentObject(viewModel)
                }
                .itemSpacing(10)
                .itemAspectRatio(0.85)
                .interactive(scale: 0.9)
                .onPageChanged { newPageIndex in
                }
            }
        }
    }
}
