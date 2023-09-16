//
//  OnboardingData.swift
//  myADD
//
//
//

import SwiftUI

struct OnboardingData {
    var imageName: String
    var title: String
    var description: String
}

let onboardingData: [OnboardingData] = [
    OnboardingData(imageName: "logo", title: "환영합니다", description: "나의 시청물 컬렉션 서비스\nmy ADD"),
    OnboardingData(imageName: "onboarding1", title: "my ADD 는..", description: "중구난방 흩어진 기억을 하나로 모아줄 서비스가 필요하다!!"),
    OnboardingData(imageName: "onboarding2", title: "기록 남기기", description: "포토카드를 스와이프로 뒤집어서 기록\n내가 작성한 모든 기록은 언제든지 수정할 수 있어요."),
    OnboardingData(imageName: "onboarding3", title: "기록 모아보기", description: "기록한 카드를 포토카드/갤러리 뷰 형식으로 확인할 수 있어요."),
    OnboardingData(imageName: "logo", title: "my ADD 시작", description: "아래 버튼을 눌러서 기억을 기록해주세요."),
]
