//
//  OnBoardingView.swift
//  myADD
//
//  
//

import SwiftUI

struct OnboardingView: View {
   // MARK: - PROPERTY
    
   @Binding var cards: [Card]

   // MARK: - BODY
    
   var body: some View {
       TabView {
           ForEach(cards) { card in
               if let cardIndex = cards.firstIndex(where: { $0.id == card.id }) {
                   NavigationLink(destination: CardBackView(card: $cards[cardIndex], cards: $cards)) {
                       FlippableCardView(card: $cards[cardIndex], cards: $cards)
                   }
                   .buttonStyle(PlainButtonStyle())
               }
           }
       }
       .tabViewStyle(PageTabViewStyle())
       .ignoresSafeArea(.all)
//       .padding(.vertical)
//       .padding(.horizontal)
       .padding(.bottom, 10)
   }
}


// MARK: - PREVIEW

struct OnboardingView_Previews: PreviewProvider {
    @State static var cards = animationCardsData

    static var previews: some View {
        OnboardingView(cards: $cards)
    }
}
