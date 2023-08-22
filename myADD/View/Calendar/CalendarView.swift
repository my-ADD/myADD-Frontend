//
//  CalendarView.swift
//  myADD
//
//  
//

import SwiftUI
import FSCalendar

struct CalendarView: UIViewRepresentable {
    
    @Binding var selectedDate: Date?
    var datesWithEvents: [String] = [] {
        didSet {
            calendar.reloadData()
        }
    }
    
    private let calendar = FSCalendar()
    
    func makeUIView(context: Context) -> FSCalendar {
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        //언어 한국어로 변경
        calendar.locale = Locale(identifier: "ko_KR")
            
            
        //MARK: -상단 헤더 뷰 관련
        calendar.headerHeight = 66 // YYYY년 M월 표시부 영역 높이
        calendar.weekdayHeight = 45 // 날짜 표시부 행의 높이
        calendar.appearance.headerTitleAlignment = .center
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0 //헤더 좌,우측 흐릿한 글씨 삭제
        calendar.appearance.headerDateFormat = "YYYY년 M월" //날짜(헤더) 표시 형식
        calendar.appearance.headerTitleColor = .black //2021년 1월(헤더) 색
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24) //타이틀 폰트 크기
        
        //MARK: -캘린더(날짜 부분) 관련
        calendar.backgroundColor = .white // 배경색
        calendar.appearance.weekdayTextColor = .black //요일(월,화,수..) 글씨 색
        calendar.appearance.selectionColor = .red //선택 된 날의 동그라미 색
        calendar.appearance.titleWeekendColor = .black //주말 날짜 색
        calendar.appearance.titleDefaultColor = .black //기본 날짜 색
        
        //MARK: -오늘 날짜(Today) 관련
        calendar.appearance.titleTodayColor = .blue //Today에 표시되는 특정 글자색
        calendar.appearance.todayColor = .clear //Today에 표시되는 선택 전 동그라미 색
        calendar.appearance.todaySelectionColor = .none  //Today에 표시되는 선택 후 동그라미 색
        
        self.calendar.placeholderType = .none
        
        // Month 폰트 설정
        calendar.appearance.headerTitleFont = UIFont(name: "NotoSansCJKKR-Medium", size: 16)
        
        // day 폰트 설정
        calendar.appearance.titleFont = UIFont(name: "Roboto-Regular", size: 14)
        
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.reloadData()
    }

    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: CalendarView
        
        init(_ parent: CalendarView) {
            self.parent = parent
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }
        
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "yyyy-MM-dd"
            dayFormatter.timeZone = TimeZone(identifier: "Asia/Seoul") // 한국 시간대를 사용
            let dateString = dayFormatter.string(from: date)
            
            let containsDate = parent.datesWithEvents.contains(dateString)
//            print("Checking date: \(dateString), is contained: \(containsDate), current datesWithEvents: \(parent.datesWithEvents)")
            
            return containsDate ? 1 : 0
        }


    }
}

