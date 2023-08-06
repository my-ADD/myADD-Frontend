//
//  CardBackView.swift
//  myADD
//
//
//

import SwiftUI

struct CardBackView: View {
    // MARK: - PROPERTIES
    
    @Binding var card: Card
    @Binding var cards: [Card]

    @Environment(\.colorScheme) var colorScheme
    
    @State private var showingActionSheet = false
    @State private var showingEditCardView = false
    @State private var showingDeleteAlert = false
    
    // MARK: - BODY
    
    var body: some View {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        // MARK: - EDIT BUTTON
                        Spacer()
                        Button(action: {
                            showingActionSheet = true
                        }) {
                            Image(systemName: "ellipsis")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 5)
                                .foregroundColor(.primary)
                        }
                        .actionSheet(isPresented: $showingActionSheet) {
                            ActionSheet(title: Text("선택"), buttons: [
                                .default(Text("수정하기")) {
                                    showingEditCardView = true
                                },
                                .destructive(Text("삭제하기")) {
                                    showingDeleteAlert = true
                                },
                                .cancel()
                            ])
                        }
                        .fullScreenCover(isPresented: $showingEditCardView) {
                            EditCardView(card: $card)
                        }
                        .alert(isPresented: $showingDeleteAlert) {
                            Alert(
                                title: Text("확인"),
                                message: Text("정말로 삭제하시겠습니까?"),
                                primaryButton: .destructive(Text("삭제")) {
                                    deleteCard()
                                },
                                secondaryButton: .cancel(Text("취소"))
                            )
                        }
                    } //: HSTACK
                    .padding(.top)
                    
                    // TITLE
                    HStack {
                        Text(card.title ?? "제목 없음")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        Spacer()
                        
                        Text(card.emotion)
                            .font(.title)
                    }
                    
                    // HEADLINE
                    HStack {
                        Text("\((card.platform ?? "플랫폼")) | \((card.genre ?? "장르"))")
                            .font(.body)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        if let date = card.date {
                            Text(dateFormatter.string(from: date))
                                .font(.body)
                                .foregroundColor(.gray)
                        } else {
                            Text("기록 날짜")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top)
                    
                    HStack {
                        if let start = card.watchPeriodStart {
                            Text(dateFormatter.string(from: start))
                                .font(.body)
                                .foregroundColor(.gray)
                        } else {
                            Text("시청 기간")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        
                        Text("~")
                            .font(.body)
                            .foregroundColor(.gray)
                        
                        if let end = card.watchPeriodEnd {
                            Text(dateFormatter.string(from: end))
                                .font(.body)
                                .foregroundColor(.gray)
                        } else {
                            Text("")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Text("\(card.watchCount) 회")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    
                    Divider()
                            .background(Color.gray)
                        // MEMO
                        ScrollView {
                            Text(card.memo ?? "메모")
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.primary)
                                .lineSpacing(5)
                                .padding(.bottom)
//                                .lineLimit(8)
//                                .truncationMode(.tail)
                            // 더 보기 기능 추후 추가.
                        }
                } //: VSTACK (CONTENT)
                .padding([.horizontal, .vertical]) // 내용 간 간격
                .offset(y: 20) // 내용을 좀 더 아래로 조정
        
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                .background(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? [.white, .gray] : [.gray, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea(.all)
                    .opacity(0.2))
                .cornerRadius(20)
                .padding(.horizontal, 20) // 카드 간 간격
    } //: BODY
    
    // MARK: - METHOD
    
    func deleteCard() {
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            cards.remove(at: index)
        }
    }
} //: VIEW

// MARK: - PREVIEW

struct CardBackView_Previews: PreviewProvider {
    @State static var card = animationCardsData[1]
    @State static var cards = animationCardsData

    static var previews: some View {
        CardBackView(card: $card, cards: $cards)
    }
}
