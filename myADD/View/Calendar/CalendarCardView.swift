//
//  CalendarCardView.swift
//  myADD
//
//  
//

import SwiftUI
import SwiftUIPager

struct CalendarCardView: View {
    var createdAt: String

    @ObservedObject private var viewModel = CardViewModel()
    @State private var selectedCardIndex: Page = .first()
    @State private var cardsForDate: [Card] = []

    var body: some View {
        VStack(spacing: 20) {
         
            HStack {
                let dateComponents = createdAt.split(separator: "-").map(String.init)
                if dateComponents.count == 3 {
                    let year = dateComponents[0]
                    let month = dateComponents[1]
                    let day = dateComponents[2]
                    VStack(alignment: .leading, spacing: 20) {
                        Text("\(year)년 \(month)월 \(day)일,")
                            .font(.headline)
                            .fontWeight(.semibold)
                                                                    
                        Text("\(cardsForDate.count) 가지 ADD 기록")
                            .font(.title2)
                            .fontWeight(.bold)
//                            .foregroundColor(.red)
                    }
                    
                }
                Spacer()
            }
            .padding([.top, .horizontal])
            
            Divider()
            
            if cardsForDate.isEmpty {
                Text("해당 날짜에는 기록한 myADD 카드가 없습니다.")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
            } else {
                Pager(page: selectedCardIndex, data: cardsForDate, id: \.calendarViewID) { card in
                    FlippableCardView(card: card)
                        .environmentObject(viewModel)
                }
                .itemSpacing(10)
                .itemAspectRatio(0.85)
                .interactive(scale: 0.9)
                .onPageChanged { newPageIndex in
                    print("Current Page: \(newPageIndex)")
                }
            }
        }
        .padding(.bottom)
        .onAppear {
            viewModel.getCalendar(createdAt: createdAt) { result in
                switch result {
                case .success(let response):
                    self.cardsForDate = response.result
                case .failure(let error):
                    print("Error loading cards for date: \(error)")
                }
            }
        }
    }
}

struct CalendarCardView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarCardView(createdAt: "2023-08-21")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

