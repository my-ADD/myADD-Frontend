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
    
    // ViewModel의 초기화 메서드
    init(selectedPlatform: OTTPlatform? = .전체, selectedTab: CardCategory = .animation) {
        updateContentFor(selectedPlatform: selectedPlatform, selectedTab: selectedTab)
    }
    
    func updateContentFor(selectedPlatform: OTTPlatform?, selectedTab: CardCategory) {
        cards.removeAll()

        // 카드 배열에 중복된 카드는 추가 x
        let completion: (Result<[Card], Error>) -> Void = { [weak self] result in
            switch result {
            case .success(let newCards):
                for card in newCards {
                    if !(self?.cards.contains(where: { $0.id == card.id }) ?? false) {
                        self?.cards.append(card)
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
            getListAll(page: 0, completion: completion)
        } else {
            if let platformValue = selectedPlatform?.rawValue {
                categoryList(category: selectedTab.rawValue, platform: platformValue, page: 0, completion: completion)
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
            updateAction?(data)
            
        case .failure(let error):
            print("error: \(error.localizedDescription)")
            self.isError = true
            self.errorMessage = error.localizedDescription
        }
    }

    // MARK: -  getListAll 메서드
    func getListAll(page: Int, completion: @escaping (Result<[Card], Error>) -> Void) {
        apiClient.getListAll(page: page) { [weak self] result in
            self?.handleAPIResult(result) { cards in
                completion(.success(cards))
            }
        }
    }

    // MARK: -  categoryList 메서드
    func categoryList(category: String, platform: String, page: Int, completion: @escaping (Result<[Card], Error>) -> Void) {
        apiClient.categoryList(category: category, platform: platform, page: page) { [weak self] result in
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
        animationCount = filteredCardsForCategory(.animation, in: platform).count
        dramaCount = filteredCardsForCategory(.drama, in: platform).count
        documentaryCount = filteredCardsForCategory(.documentary, in: platform).count
    }

    func countForCategory(_ category: CardCategory, in platform: OTTPlatform?) -> Int {
        return filteredCardsForCategory(category, in: platform).count
    }

    func getHeaderText(for category: CardCategory, in platform: OTTPlatform?) -> String {
        let count: Int
        
        switch category {
        case .animation:
            count = countForCategory(category, in: platform)
            return "회원님의 \n\(count)가지 애니메이션 기록"
        case .drama:
            count = countForCategory(category, in: platform)
            return "회원님의 \n\(count)가지 드라마 기록"
        case .documentary:
            count = countForCategory(category, in: platform)
            return "회원님의 \n\(count)가지 다큐멘터리 기록"
        }
    }
    
    // MARK: - Calendar
    
    func getCalendar(createdAt: String, completion: @escaping (Result<[Card], Error>) -> Void) {
        apiClient.getCalendar(createdAt: createdAt) { result in
            switch result {
            case .success(let cards):
                self.cards.append(contentsOf: cards)
                completion(.success(cards))
                
            case .failure(let error):
                print("getCalendar API Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }


    @Published var datesWithEvents: [String] = []
    @Published var isLoading: Bool = false

    func fetchDatesFromServer() {
        self.isLoading = true  // <-- API 호출 시작 전에 로딩 상태 설정

        apiClient.getCreatedAt { [weak self] apiResponseResult in
            defer { self?.isLoading = false }  // <-- API 호출 완료 후에 로딩 상태 해제

            switch apiResponseResult {
            case .success(let apiResponse):
                if apiResponse.isSuccess {
                    if let dateStrings = apiResponse.result {
                        let uniqueDates = Set(dateStrings.compactMap { self?.convertToDate($0) })

                        self?.datesWithEvents = Array(uniqueDates)
                    }
                } else {
                    print("getCreatedAt API Error: \(apiResponse.message)")
                }
            case .failure(let error):
                print("Error fetching dates: \(error.localizedDescription)")
            }
        }
    }


    func convertToDate(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateString) {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "yyyy-MM-dd"
            dayFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            return dayFormatter.string(from: date)
        }
        
        return nil
    }
}
