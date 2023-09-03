//
//  CardDataModel.swift
//  myADD
//
//  
//

import SwiftUI
import Foundation

// MARK: - CATEGORY

enum CardCategory: String, Codable, CaseIterable {
    case animation = "애니메이션"
    case drama = "드라마"
    case documentary = "다큐멘터리"
}

// MARK: - API RESPONSE MODEL

struct EmptyResult: Decodable {}

struct APIResponse<T: Decodable>: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: T?
}

// MARK: - CARDS DATA MODEL

struct Card: Codable, Identifiable, Equatable {
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id &&
               lhs.postId == rhs.postId &&
               lhs.userId == rhs.userId &&
               lhs.image == rhs.image &&
               lhs.comment == rhs.comment &&
               lhs.title == rhs.title &&
               lhs.emoji == rhs.emoji &&
               lhs.platform == rhs.platform &&
               lhs.genre == rhs.genre &&
               lhs.views == rhs.views &&
               lhs.memo == rhs.memo &&
               lhs.category == rhs.category &&
               lhs.createdAt == rhs.createdAt &&
               lhs.modifiedAt == rhs.modifiedAt &&
               lhs.startedAt == rhs.startedAt &&
               lhs.endedAt == rhs.endedAt
    }

    
    // ID
    var id: Int? { postId }
    let postId: Int?
    let userId: Int?
    
    var onboardingViewID: String {
        return "Onboarding-\(id ?? 0)"
    }
    
    var calendarViewID: String {
        return "Calendar-\(id ?? 0)"
    }
    
    // Card Front
    var image: String?
    var comment: String?
    
    // Card Back
    var title: String?
    var emoji: String?
    var platform: String?
    var genre: String?
    var views: Int?
    var memo: String?
    var category: CardCategory?
    var createdAt: String?
    var modifiedAt: String?
    var startedAt: String?
    var endedAt: String?
    
    // INITIALIZER
    init() {
        self.postId = nil
        self.userId = nil

        self.image = nil
        self.comment = nil

        self.title = nil
        self.emoji = nil
        self.platform = nil
        self.genre = nil
        self.views = nil
        self.memo = nil
        self.category = nil

        self.createdAt = nil
        self.modifiedAt = nil
        self.startedAt = nil
        self.endedAt = nil
    }
}

// MARK: - EXTENSION

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
    
    func encodedImageURL() -> URL? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed).flatMap { URL(string: $0) }
    }
    
    func asFormattedDate() -> String? {
        let dateFormatter = DateFormatter()
        
        // 입력 형식 설정
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
        
        return nil
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}


