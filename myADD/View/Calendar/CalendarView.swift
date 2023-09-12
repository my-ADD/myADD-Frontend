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
        calendar.locale = Locale(identifier: "ko_KR")
        
        if UITraitCollection.current.userInterfaceStyle == .dark {
            // 다크 모드 설정
            calendar.appearance.weekdayTextColor = .white
            calendar.appearance.headerTitleColor = .white
            calendar.appearance.titleWeekendColor = .white
            calendar.appearance.titleDefaultColor = .white
            calendar.backgroundColor = .clear
        } else {
            // 라이트 모드 설정
            calendar.appearance.weekdayTextColor = .black
            calendar.appearance.headerTitleColor = .black
            calendar.appearance.titleWeekendColor = .black
            calendar.appearance.titleDefaultColor = .black
            calendar.backgroundColor = .clear
        }
            
        // MARK: - 상단 헤더 뷰 관련
        calendar.headerHeight = 66
        calendar.weekdayHeight = 45
        calendar.appearance.headerTitleAlignment = .center
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)

        self.calendar.placeholderType = .none

        calendar.appearance.headerTitleFont = UIFont(name: "NotoSansCJKKR-Medium", size: 16)
        
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
            dayFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            let dateString = dayFormatter.string(from: date)
            
            let containsDate = parent.datesWithEvents.contains(dateString)
            return containsDate ? 1 : 0
        }

    }
}
