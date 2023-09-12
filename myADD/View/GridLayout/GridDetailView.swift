//
//  GridDetailView.swift
//  myADD
//
//
//

import SwiftUI

struct GridDetailView: View {
    // MARK: - PROPERTY

    @StateObject var FlipViewModel = CardFlipViewModel()
    @EnvironmentObject var viewModel: CardViewModel

    var card: Card

    // MARK: - BODY

    var body: some View {
        ZStack {
            // Front
            CardFrontView(card: card)
                .rotation3DEffect(.degrees(FlipViewModel.degrees <= 90 ? FlipViewModel.degrees : 0), axis: (x: 0, y: 1, z: 0))
                .opacity(FlipViewModel.degrees <= 90 ? 1 : 0)

            // Back
            CardBackView(card: card)
                .environmentObject(viewModel)
                .rotation3DEffect(.degrees(FlipViewModel.degrees > 90 ? FlipViewModel.degrees - 180 : -180), axis: (x: 0, y: 1, z: 0))
                .opacity(FlipViewModel.degrees > 90 ? 1 : 0)
        }
        .onTapGesture {
            FlipViewModel.flipCard()
        }
        .cornerRadius(20)
    }
}

