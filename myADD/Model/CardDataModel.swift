//
//  CardDataModel.swift
//  myADD
//
//  
//

import SwiftUI

// MARK: - CARDS DATA MODEL

struct Card: Identifiable {
    var id = UUID()
    var title: String?
    var platform: String?
    var genre: String?
    var review: String?
    var image: UIImage?
    var emotion: String
    var date: Date?
    var watchPeriodStart: Date?
    var watchPeriodEnd: Date?
    var watchCount: Int
    var memo: String?
}



// MARK: - CARD TYPE

enum CardType: String, CaseIterable {
    case animation = "애니메이션"
    case drama = "드라마"
    case documentary = "다큐멘터리"
}

