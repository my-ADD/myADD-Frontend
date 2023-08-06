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
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedEmoji: Emoji?
    @State private var displayEmojiPicker: Bool = false
    
    @FocusState private var isTitleFieldFocused: Bool
    @FocusState private var isPlatformFieldFocused: Bool
    @FocusState private var isGenreFieldFocused: Bool
    @FocusState private var isMemoFieldFocused: Bool
    
    @State private var showingMemoModal = false

    // MARK: - BODY
    var body: some View {
            VStack(alignment: .leading, spacing: 20) {
//                Spacer()
                // TITLE
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
                        Text(selectedEmoji?.value ?? "🙂") // Display the selected emoji when available
                            .font(.largeTitle)
                    }
                    .sheet(isPresented: $displayEmojiPicker) {
                        NavigationView {
                            EmojiPickerView(selectedEmoji: $selectedEmoji, selectedColor: .orange)
                                .navigationTitle("Emojis")
                                .navigationBarTitleDisplayMode(.inline)
                                .onDisappear {
                                    if let emoji = selectedEmoji {
                                        card.emotion = emoji.value
                                    }
                                }
                        }
                    } //: Emoji
                    
                } //: HSTACK
//                .padding(.top)

                HStack {
                    let platformBinding = Binding<String>(
                        get: { self.card.platform ?? "" },
                        set: { if $0.count <= 10 { self.card.platform = $0 } }
                    )
                    
                    TextField("플랫폼", text: platformBinding)
                        .font(.body)
                        .foregroundColor(.gray)
                        .focused($isPlatformFieldFocused)
                        .submitLabel(.next)
                        .onSubmit {
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
                }

                DatePicker(
                    "기록 날짜",
                    selection: Binding<Date>(
                        get: { self.card.date ?? Date() },
                        set: { self.card.date = $0 }
                    ),
                    displayedComponents: .date
                )
                .font(.body)
                .foregroundColor(.gray)

                DatePicker(
                    "시청기간 시작일",
                    selection: Binding<Date>(
                        get: { self.card.watchPeriodStart ?? Date() },
                        set: { self.card.watchPeriodStart = $0 }
                    ),
                    displayedComponents: .date
                )
                .font(.body)
                .foregroundColor(.gray)
                
                DatePicker(
                    "시청기간 종료일",
                    selection: Binding<Date>(
                        get: { self.card.watchPeriodEnd ?? Date() },
                        set: { self.card.watchPeriodEnd = $0 }
                    ),
                    displayedComponents: .date
                )
                .font(.body)
                .foregroundColor(.gray)

                HStack {
                    // "Number of views" on the left
                    Text("시청 횟수")
                        .font(.body)
                        .foregroundColor(.gray)
                        .frame(alignment: .leading)
                    
                    Spacer()
                    
                    // Picker on the right
                    Picker(selection: $card.watchCount, label: Text("회")) {
                        ForEach(0..<100) { index in
                            Text("\(index)").tag(index)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 60, height: 50, alignment: .center)
                    
                    // "times" on the right of the Picker
                    Text("회")
                        .font(.body)
                        .frame(alignment: .leading)
                }


                Divider()
                    .background(Color.gray)

                // MEMO
                HStack {
                    Button(action: {
                        showingMemoModal = true
                    }) {
                        Text(card.memo ?? "메모를 작성해주세요")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding()
                            .foregroundColor(.gray)
//                            .lineLimit(2)  // Limits the number of lines
//                            .truncationMode(.tail)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50)  // Sets the maximum dimensions for the frame
                    .submitLabel(.done)
                }
                .padding(.bottom)
                .sheet(isPresented: $showingMemoModal) {
                    NavigationView {
                        MemoInputView(memo: $card.memo)
                            .navigationBarTitle("메모 작성", displayMode: .inline)
                            .navigationBarItems(trailing: Button("완료") {
                                showingMemoModal = false
                            })
                    }
                }
            }
            .padding([.horizontal, .vertical]) // 내용 간 간격
            .offset(y: 20) // 내용을 좀 더 아래로 조정
    
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .background(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? [.white, .gray] : [.gray, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea(.all)
                .opacity(0.2))
            .cornerRadius(20)
            .padding(.horizontal, 20) // 카드 간 간격
        
        .onTapGesture {
            hideKeyboard()
        }
//        .ignoresSafeArea(.keyboard, edges: .bottom)
    } //: BODY
}
