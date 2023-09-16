//
//  AddCardBackView.swift
//  myADD
//
//  
//

import SwiftUI
import EmojiPicker


// MARK: - BACK VIEW

struct AddCardBackView: View {
    @Binding var card: Card
    @ObservedObject var viewModel: CardViewModel

    @Environment(\.colorScheme) var colorScheme
    @State private var selectedEmoji: Emoji?
    @State private var displayEmojiPicker: Bool = false
    
    @FocusState private var isTitleFieldFocused: Bool
    @FocusState private var isPlatformFieldFocused: Bool
    @FocusState private var isGenreFieldFocused: Bool
    @FocusState private var isMemoFieldFocused: Bool
    
    @State private var showingMemoModal = false
    
    @State private var selectedPlatform: String = "넷플릭스"
    let platforms: [String] = ["넷플릭스", "티빙", "쿠팡 플레이", "디즈니 플러스", "라프텔", "웨이브", "왓챠", "기타"]


    // MARK: - BODY
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    TextField("제목을 입력하세요", text: Binding<String>(
                        get: { self.card.title ?? "" },
                        set: { self.card.title = $0 }
                    ))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .focused($isTitleFieldFocused)
                        .submitLabel(.next)
                        .onSubmit {
                            isPlatformFieldFocused = true
                        }
                    
                    Spacer()
                    
                    Button(action: {
                        displayEmojiPicker = true
                    }) {
                        Text(selectedEmoji?.value ?? "🙂")
                            .font(.largeTitle)
                    }
                    .sheet(isPresented: $displayEmojiPicker) {
                        NavigationView {
                            EmojiPickerView(selectedEmoji: $selectedEmoji, selectedColor: .orange)
                                .navigationTitle("Emojis")
                                .navigationBarTitleDisplayMode(.inline)
                                .onDisappear {
                                    if let emoji = selectedEmoji {
                                        card.emoji = emoji.value
                                    }
                                }
                        }
                    } //: Emoji
                } //: HSTACK
                .ignoresSafeArea(.keyboard, edges: .bottom)
                
                HStack {
                    Picker("플랫폼 선택", selection: $selectedPlatform) {
                        ForEach(platforms, id: \.self) { platform in
                            Text(platform).tag(platform)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedPlatform) { newValue in
                        card.platform = newValue
                        isGenreFieldFocused = true
                    }
                        
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 1, height: 20)
                        .padding(.horizontal, 10)
                    
                    let genreBinding = Binding<String>(
                        get: { self.card.genre ?? "" },
                        set: { if $0.count <= 10 { self.card.genre = $0 } }
                    )
                    
                    TextField("장르", text: genreBinding)
                        .font(.body)
                        .foregroundColor(.gray)
                        .focused($isGenreFieldFocused)
                        .submitLabel(.next)
                } //: HSTACK

                DatePicker(
                    "시청기간 시작일",
                    selection: Binding<Date>(
                        get: { self.card.startedAt?.toDate() ?? Date() },
                        set: { self.card.startedAt = $0.toString() }
                    ),
                    displayedComponents: .date
                )
                .font(.body)
                .foregroundColor(.gray)
                
                DatePicker(
                    "시청기간 종료일",
                    selection: Binding<Date>(
                        get: { self.card.endedAt?.toDate() ?? Date() },
                        set: { self.card.endedAt = $0.toString() }
                    ),
                    displayedComponents: .date
                )
                .font(.body)
                .foregroundColor(.gray)

                HStack {
                    Text("시청 횟수")
                        .font(.body)
                        .foregroundColor(.gray)
                        .frame(alignment: .leading)
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            if let currentViews = self.card.views, currentViews > 0 {
                                self.card.views = currentViews - 1
                            }
                        }) {
                            Text("-")
                                .font(.title)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .frame(width: 20)
                                .padding(.all, 5)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                                .padding(.trailing, 5)

                        }
                        
                        Text("\(self.card.views ?? 0) 회")
                            .font(.body)
                        
                        Button(action: {
                            if let currentViews = self.card.views {
                                self.card.views = currentViews + 1
                            } else {
                                self.card.views = 1
                            }
                        }) {
                            Text("+")
                                .font(.title)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .frame(width: 20)
                                .padding(.all, 5)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                                .padding(.leading, 5)
                        }
                    }
                    .frame(alignment: .leading)
                } //: HSTACK



                Divider()
                    .background(Color.gray)

                // MEMO
                HStack {
                    Button(action: {
                        showingMemoModal = true
                    }) {
                        Text(card.memo?.isEmpty ?? true ? "메모를 작성해주세요" : card.memo!)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding()
                            .foregroundColor(.gray)

                    }
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .submitLabel(.done)
                }
                .sheet(isPresented: $showingMemoModal) {
                    NavigationView {
                        MemoInputView(memo: $card.memo)
                            .navigationBarTitle("메모 작성", displayMode: .inline)
                            .navigationBarItems(trailing: Button("완료") {
                                showingMemoModal = false
                            })
                    }
                }
                Spacer()
            }
        }
        .padding([.horizontal, .vertical])
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? [.gray.opacity(0.3), .white] : [.gray.opacity(0.7), .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea(.all)
            .opacity(0.85)
        )
        .onTapGesture {
            hideKeyboard()
        }
    } //: BODY
}
