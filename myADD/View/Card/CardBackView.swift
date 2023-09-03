//
//  CardBackView.swift
//  myADD
//
//
//

import SwiftUI

struct CardBackView: View {
    // MARK: - PROPERTIES
    
    var card: Card

    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var viewModel: CardViewModel

    @State private var showingActionSheet = false
    @State private var showingEditCardView = false
    @State private var showingDeleteAlert = false
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // MARK: - EDIT / DELETE
            HStack {
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
                    EditCardView(card: card, postId: card.postId ?? 0)
                        .environmentObject(viewModel)
                }
                .alert(isPresented: $showingDeleteAlert) {
                    Alert(
                        title: Text("확인"),
                        message: Text("정말로 삭제하시겠습니까?"),
                        primaryButton: . destructive(Text("삭제")) {
                            viewModel.deleteCard(postId: card.postId ?? 0) { _ in }
                        },
                        secondaryButton: .cancel(Text("취소"))
                    )
                }
            } //: HSTACK
            .padding(.top)
            // TITLE
            HStack {
                Text(card.title?.isEmpty ?? true ? "제목 없음" : card.title!)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Spacer()

                Text(card.emoji?.isEmpty ?? true ? "😆" : card.emoji!)
                    .font(.title)
            }
            
            // HEADLINE
            HStack {
                Text("\((card.platform?.isEmpty ?? true ? "기타" : card.platform!)) | \((card.genre?.isEmpty ?? true ? "장르" : card.genre!))")
                    .font(.callout)
                    .foregroundColor(.gray)
                
                Spacer()
                
                if let date = card.modifiedAt?.asFormattedDate() ?? card.createdAt?.asFormattedDate() {
                    Text(date)
                        .font(.callout)
                        .foregroundColor(.gray)
                } else {
                    Text("기록 날짜")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
            }
            
            HStack {
                if let start = card.startedAt {
                    Text(start)
                        .font(.callout)
                        .foregroundColor(.gray)
                } else {
                    Text("시청 기간")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                
                Text("~")
                    .font(.callout)
                    .foregroundColor(.gray)
                
                if let end = card.endedAt {
                    Text(end)
                        .font(.callout)
                        .foregroundColor(.gray)
                } else {
                    Text("")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if let views = card.views {
                    Text("\(views) 회")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
                .background(Color.gray)
                .padding(.vertical, 10)
            
            // MEMO
            ScrollView {
                Text(card.memo?.isEmpty ?? true ? "메모를 작성해주세요" : card.memo!)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
                    .lineSpacing(5)
                    .padding(.bottom)
            }
        }
        .padding([.horizontal, .vertical])
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? [.gray.opacity(0.3), .white] : [.gray.opacity(0.7), .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea(.all)
            .opacity(0.85)
        )
        .cornerRadius(20)
    } //: BODY
} //: VIEW
