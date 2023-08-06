//
//  CardViewModel.swift
//  myADD
//
//  
//

import SwiftUI

class CardViewModel: ObservableObject {
    @Published var flipped: Bool = false
    @Published var frontDegrees: Double = 0
    @Published var backDegrees: Double = -90
    @Published var frontOpacity: Double = 1
    @Published var backOpacity: Double = 0
    let duration: Double = 0.25

    func flipCard() {
        flipped.toggle()
        if flipped {
            withAnimation(.easeInOut(duration: duration)) {
                frontDegrees = 90
                frontOpacity = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration / 2) {
                withAnimation(.easeInOut(duration: self.duration)) {
                    self.backDegrees = 0
                    self.backOpacity = 1
                }
            }
        } else {
            withAnimation(.easeInOut(duration: duration)) {
                backDegrees = 90
                backOpacity = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration / 2) {
                withAnimation(.easeInOut(duration: self.duration)) {
                    self.frontDegrees = 0
                    self.frontOpacity = 1
                }
            }
        }
    }
}
