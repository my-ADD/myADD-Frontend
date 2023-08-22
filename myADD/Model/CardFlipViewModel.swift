//
//  CardFlipViewModel.swift
//  myADD
//
//  
//

import SwiftUI

class CardFlipViewModel: ObservableObject {
    @Published var flipped: Bool = false
    @Published var degrees: Double = 0
    let duration: Double = 0.25

    func flipCard() {
        withAnimation(.easeInOut(duration: duration)) {
            degrees = flipped ? 0 : 180
            flipped.toggle()
        }
    }
}

