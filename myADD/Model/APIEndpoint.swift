//
//  APIEndpoint.swift
//  myADD
//
//
//

import Foundation

// MARK: - END POINT

struct APIEndpoint {
    
    static let baseURL = "http://3.34.68.145"

    // 포토카드 등록 post
    static let  addCardURL = baseURL + "/posts/add-post"
    
//    // 포토카드 앞장 조회 (상세 페이지) get
//    static let  getCardFrontURL = baseURL + "/posts/get-post/front"
//
//    // 포토카드 뒷장 조회 get
//    static let  getCardBackURL = baseURL + "/posts/get-post/back"

    // 포토카드 전체 목록 조회 (기록순) get
    static let getListAllURL = baseURL + "/posts/get-post-listAll/createdAt"
    
    // 포토카드 수정 put
    static let  updateCardURL = baseURL + "/posts/update-post"
    
    // 포토카드 삭제 delete
    static let  deleteCardURL = baseURL + "/posts/delete-post"
    
    // 캘린더 get
    static let calendarURL = baseURL + "/posts/calendar"
    
    // 캘린더 날짜 조회 createdAt
    static let getCreatedAtURL = baseURL + "/posts/createdAt"
    
    // OTT 플랫폼 선택 및 카테고리에 따른 포토카드 리스트 조회 (기록순) get
    static let categoryListURL = baseURL + "/posts/get-post-list/createdAt"
    
}
