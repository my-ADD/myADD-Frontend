//
//  OnboardingData.swift
//  myADD
//
//  Created by 이융의 on 2023/09/03.
//

import SwiftUI

struct OnboardingData {
    var image: UIImage
    var title: String
    var description: String
}

let defaultImage = UIImage(systemName: "questionmark.circle")!

let onboardingData = [
    OnboardingData(
        image: UIImage(named: "AppIcon") ?? defaultImage,
        title: "환영합니다",
        description: "나의 시청물 컬렉션 서비스\nmy ADD"
    ),
    
    OnboardingData(
        image: UIImage(named: "onboarding1") ?? defaultImage,
        title: "my ADD 는..",
        description: "중구난방 흩어진 기억을 하나로 모아줄 서비스가 필요하다!!"
    ),
    
    OnboardingData(
        image: UIImage(named: "onboarding2") ?? defaultImage,
        title: "기록 모아보기",
        description: "내가 작성한 모든 기록은 언제든지 수정 가능"
    ),
    
    OnboardingData(
        image: UIImage(named: "onboarding3") ?? defaultImage,
        title: "기록 남기기",
        description: "포토카드를 스와이프로 뒤집어서 기록"
    ),
    OnboardingData(
        image: UIImage(named: "onboarding4") ?? defaultImage,
        title: "마이 페이지",
        description: "캘린더로 어느 날짜에 어떤 기록을 남겼는지 확인 가능"
    ),

    OnboardingData(
        image: UIImage(named: "AppIcon") ?? defaultImage,
        title: "my ADD 시작",
        description: "아래 버튼을 눌러서 기억을 기록해주세요."
    )
]



