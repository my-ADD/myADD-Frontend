//
//  OnBoardingView.swift
//  myADD
//
//  
//

import SwiftUI
import SwiftUIPager

struct OnboardingView: View {
    var cards: [Card]

    @State private var selectedCardIndex: Page = .first()
    @EnvironmentObject var viewModel: CardViewModel

    var body: some View {
        VStack {
            Pager(page: selectedCardIndex, data: cards, id: \.onboardingViewID) { card in
                FlippableCardView(card: card)
                    .environmentObject(viewModel)
            }
            .itemSpacing(10) // 카드 사이의 간격을 조절
            .itemAspectRatio(0.85) // 카드의 가로/세로 비율을 조절
            .interactive(scale: 0.9)  // 스케일 값을 조정
            .onPageChanged { newPageIndex in
                print("Current Page: \(newPageIndex)")
            }
        }
    }
}
