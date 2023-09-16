//
//  CardViewModel.swift
//  myADD
//
//  
//

import Foundation
import UIKit
import SwiftUI

class CardViewModel: ObservableObject {
    
    // MARK: - PROPERTIES
    
    @Published private(set) var cards: [Card] = []
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    
    private var apiClient = APIClient()
    
    // MARK: - UPDATE CONTENT
    
    init(selectedPlatform: OTTPlatform? = .전체, selectedTab: CardCategory = .animation) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateContentFor(selectedPlatform: selectedPlatform, selectedTab: selectedTab)
        }
    }
    
    func updateContentFor(selectedPlatform: OTTPlatform?, selectedTab: CardCategory) {
        isError = false
        errorMessage = ""
        var newCards: [Card] = []

        let completion: (Result<[Card], Error>) -> Void = { [weak self] result in
            switch result {
            case .success(let fetchedCards):
                for card in fetchedCards {
                    if !newCards.contains(where: { $0.id == card.id }) {
                        newCards.append(card)
                    }
                }
                
                DispatchQueue.main.async {
                    withAnimation(.easeInOut) {
                        self?.cards = newCards
                    }
                }

                self?.updateCategoryCounts(for: selectedPlatform)
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                self?.isError = true
                self?.errorMessage = error.localizedDescription
            }
        }

        if selectedPlatform == .전체 {
            getListAll(completion: completion)
        } else {
            if let platformValue = selectedPlatform?.rawValue {
                categoryList(category: selectedTab.rawValue, platform: platformValue, completion: completion)
            }
        }
    }


    
    func cardsForSelectedTab(_ category: CardCategory, platform: OTTPlatform?) -> [Card] {
        return cards.filter {
            $0.category == category &&
            (platform == nil || platform == .전체 || $0.platform == platform?.rawValue)
        }
    }
    
    // MARK: - handleAPIResult
    
    private func handleAPIResult<T>(_ result: Result<T, Error>, updateAction: ((T) -> Void)? = nil) {
        switch result {
        case .success(let data):
            DispatchQueue.main.async {
                updateAction?(data)
            }
        case .failure(let error):
            DispatchQueue.main.async {
                print("error: \(error.localizedDescription)")
                self.isError = true
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: -  getListAll 메서드
    func getListAll(completion: @escaping (Result<[Card], Error>) -> Void) {
        apiClient.getListAll { [weak self] result in
            self?.handleAPIResult(result) { cards in
                completion(.success(cards))
            }
        }
    }

    // MARK: -  categoryList 메서드
    func categoryList(category: String, platform: String, completion: @escaping (Result<[Card], Error>) -> Void) {
        apiClient.categoryList(category: category, platform: platform) { [weak self] result in
            self?.handleAPIResult(result) { cards in
                completion(.success(cards))
            }
        }
    }

    // MARK: -  addCard 메서드
    func addCard(image: UIImage?, card: Card, completion: @escaping (Result<APIResponse<EmptyResult>, Error>) -> Void) {
        apiClient.addCard(image: image, card: card) { [weak self] result in
            self?.handleAPIResult(result) { _ in
                if let category = card.category {
                    self?.updateContentFor(selectedPlatform: .전체, selectedTab: category)
                } else {
                }
                completion(result)
            }

        }
    }


    // MARK: -  updateCard 메서드
    func updateCard(postId: Int, image: UIImage?, card: Card, completion: @escaping (Result<APIResponse<EmptyResult>, Error>) -> Void) {
        apiClient.updateCard(postId: postId, image: image, card: card) { [weak self] result in
            self?.handleAPIResult(result) { _ in
                if let category = card.category {
                    self?.updateContentFor(selectedPlatform: .전체, selectedTab: category)
                } else {
                }
                completion(result)
            }
        }
    }


    // MARK: -  deleteCard 메서드
    func deleteCard(postId: Int, completion: @escaping (Result<APIResponse<EmptyResult>, Error>) -> Void) {
        apiClient.deleteCard(postId: postId) { [weak self] result in
            self?.handleAPIResult(result) { _ in
                self?.updateContentFor(selectedPlatform: .전체, selectedTab: .animation)
                completion(result)
            }
        }
    }


    // MARK: - 카테고리 별로 개수 세기
    
    @Published var animationCount: Int = 0
    @Published var dramaCount: Int = 0
    @Published var documentaryCount: Int = 0
    let userDefaults = UserDefaults.standard
    
    private func filteredCardsForCategory(_ category: CardCategory, in platform: OTTPlatform?) -> [Card] {
        let filteredCards: [Card]
        
        if let platform = platform, platform != .전체 {
            filteredCards = cards.filter { $0.platform == platform.rawValue }
        } else {
            filteredCards = cards
        }
        
        return filteredCards.filter { $0.category == category }
    }

    func updateCategoryCounts(for platform: OTTPlatform?) {
        DispatchQueue.main.async {
            self.animationCount = self.filteredCardsForCategory(.animation, in: platform).count
            self.dramaCount = self.filteredCardsForCategory(.drama, in: platform).count
            self.documentaryCount = self.filteredCardsForCategory(.documentary, in: platform).count
        }
    }

    func countForCategory(_ category: CardCategory, in platform: OTTPlatform?) -> Int {
        return filteredCardsForCategory(category, in: platform).count
    }

    func getHeaderText(for category: CardCategory, in platform: OTTPlatform?) -> String {
        let count: Int
        let nickname = userDefaults.object(forKey: "nickname") as? String
        
        switch category {
        case .animation:
            count = countForCategory(category, in: platform)
            return "\(nickname ?? "회원")님의 \n\(count)가지 애니메이션 기록"
        case .drama:
            count = countForCategory(category, in: platform)
            return "\(nickname ?? "회원")님의 \n\(count)가지 드라마 기록"
        case .documentary:
            count = countForCategory(category, in: platform)
            return "\(nickname ?? "회원")님의 \n\(count)가지 다큐멘터리 기록"
        }
    }
    
    func getTitleText() -> String {
        let count: Int
        let nickname = userDefaults.object(forKey: "nickname") as? String
        
        count = cards.count
        return "\(nickname ?? "회원")님의 \n\(count)가지 ADD 기록"
    }
}
