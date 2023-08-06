//
//  CardData.swift
//  myADD
//
//
//

import SwiftUI

// MARK: - CARDS DATA

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()


let animationCardsData : [Card] = [
    Card(
        title: "귀멸의 칼날",
        platform: "라프텔",
        genre: "애니메이션",
        review: "너무나도 재미있는 애니메이션이다!",
        image: UIImage(named: "anime2"),
        emotion: "😆",
        date: dateFormatter.date(from: "2023-05-01")!,
        watchPeriodStart: dateFormatter.date(from: "2020-01-01")!,
        watchPeriodEnd: dateFormatter.date(from: "2023-01-01")!,
        watchCount: 8,
        memo: "때는 다이쇼 시대. 숯을 파는 마음씨 착한 소년인 카마도 탄지로는, 어느날 도깨비에게 가족을 몰살당한다. 유일하게 살아남은 누이동생 카마도 네즈코마저도 도깨비로 변하고 마는데... 절망적인 현실에 큰 타격을 입은 카마도 탄지로였지만, 동생을 인간으로 돌려놓기 위해, 가족을 죽인 도깨비를 심판하기 위해, 귀살대의 길을 가기로 결의한다. 인간과 도깨비가 엮어낸 애절한 오누이의 이야기가 지금 시작된다!!"
    ),
    Card(
        title: "원피스",
        platform: "라프텔",
        genre: "애니메이션",
        review: "한줄평!",
        image: UIImage(named: "anime3"),
        emotion: "😆",
        date: dateFormatter.date(from: "2023-05-01")!,
        watchPeriodStart: dateFormatter.date(from: "2020-01-01")!,
        watchPeriodEnd: dateFormatter.date(from: "2022-01-01")!,
        watchCount: 2,
        memo: "메모!!"
      ),
    Card(
        title: "나루토",
        platform: "라프텔",
        genre: "애니메이션",
        review: "한줄평!",
        image: UIImage(named: "anime1"),
        emotion: "😆",
        date: dateFormatter.date(from: "2023-05-01")!,
        watchPeriodStart: dateFormatter.date(from: "2020-01-01")!,
        watchPeriodEnd: dateFormatter.date(from: "2022-01-01")!,
        watchCount: 5,
        memo: "메모!!"
    )
]

let dramaCardsData : [Card] = [
    Card(
        title: "어느 날 우리집 현관으로 멸망이 들어왔다",
        platform: "넷플릭스",
        genre: "드라마",
        review: "한줄평!",
        image: UIImage(named: "drama1"),
        emotion: "😆",
        date: dateFormatter.date(from: "2023-05-01")!,
        watchPeriodStart: dateFormatter.date(from: "2020-01-01")!,
        watchPeriodEnd: dateFormatter.date(from: "2022-01-01")!,
        watchCount: 5,
        memo: "메모!!"
      ),
    Card(
        title: "도깨비",
        platform: "티빙",
        genre: "드라마",
        review: "한줄평!",
        image: UIImage(named: "drama2"),
        emotion: "😆",
        date: dateFormatter.date(from: "2023-05-01")!,
        watchPeriodStart: dateFormatter.date(from: "2020-01-01")!,
        watchPeriodEnd: dateFormatter.date(from: "2022-01-01")!,
        watchCount: 8,
        memo: "메모!!"
      ),
    Card(
        title: "사이코지만 괜찮아",
        platform: "왓챠",
        genre: "드라마",
        review: "한줄평!",
        image: UIImage(named: "drama3"),
        emotion: "😆",
        date: dateFormatter.date(from: "2023-05-01")!,
        watchPeriodStart: dateFormatter.date(from: "2020-01-01")!,
        watchPeriodEnd: dateFormatter.date(from: "2022-01-01")!,
        watchCount: 2,
        memo: "메모!!"
      )
]

let documentaryCardsData : [Card] = [
    Card(
        title: "Walk alone",
        platform: "디즈니 플러스",
        genre: "다큐멘터리",
        review: "한줄평!",
        image: UIImage(named: "docu1"),
        emotion: "😆",
        date: dateFormatter.date(from: "2023-05-01")!,
        watchPeriodStart: dateFormatter.date(from: "2020-01-01")!,
        watchPeriodEnd: dateFormatter.date(from: "2022-01-01")!,
        watchCount: 5,
        memo: "메모!!"
      ),
    Card(
        title: "Forest",
        platform: "디즈니 플러스",
        genre: "다큐멘터리",
        review: "한줄평!",
        image: UIImage(named: "docu2"),
        emotion: "😆",
        date: dateFormatter.date(from: "2023-05-01")!,
        watchPeriodStart: dateFormatter.date(from: "2020-01-01")!,
        watchPeriodEnd: dateFormatter.date(from: "2022-01-01")!,
        watchCount: 8,
        memo: "메모!!"
      ),
    Card(
        title: "Time as money",
        platform: "디즈니 플러스",
        genre: "다큐멘터리",
        review: "한줄평!",
        image: UIImage(named: "docu3"),
        emotion: "😆",
        date: dateFormatter.date(from: "2023-05-01")!,
        watchPeriodStart: dateFormatter.date(from: "2020-01-01")!,
        watchPeriodEnd: dateFormatter.date(from: "2022-01-01")!,
        watchCount: 2,
        memo: "메모!!"
      )
]

