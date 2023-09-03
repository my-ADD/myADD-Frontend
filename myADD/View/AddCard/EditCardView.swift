//
//  EditCardView.swift
//  myADD
//
//  
//

import SwiftUI
import UIKit
import EmojiPicker
import SDWebImageSwiftUI

struct EditCardView: View {
    // MARK: - PROPERTIES
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var FlipViewModel = CardFlipViewModel()
    @EnvironmentObject var viewModel: CardViewModel
    @State private var isCardFlipped = false
    
    @State private var selectedImage: UIImage?
    
    let card: Card
    @State private var workingCard: Card
    let postId: Int

    init(card: Card, postId: Int) {
        self.card = card
        self._workingCard = State(initialValue: card)
        self.postId = postId
    }
    
    @State private var isButtonPressed = false

    // MARK: - BODY
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {

                    Spacer()

                    ZStack {
                        EditCardFrontView(card: $workingCard, selectedImageFromPicker: $selectedImage)
                            .environmentObject(viewModel)
                            .rotation3DEffect(.degrees(FlipViewModel.degrees <= 90 ? FlipViewModel.degrees : 0), axis: (x: 0, y: 1, z: 0))
                            .opacity(FlipViewModel.degrees <= 90 ? 1 : 0)

                        EditCardBackView(card: $workingCard)
                            .environmentObject(viewModel)
                            .rotation3DEffect(.degrees(FlipViewModel.degrees > 90 ? FlipViewModel.degrees - 180 : -180), axis: (x: 0, y: 1, z: 0))
                            .opacity(FlipViewModel.degrees > 90 ? 1 : 0)
                    }
                    .frame(width: geometry.size.width * 0.85, height: geometry.size.height * 0.7)
                    .cornerRadius(20)
                    .gesture(
                        DragGesture(minimumDistance: 30, coordinateSpace: .local)
                            .onEnded { value in
                                let horizontalAmount = value.translation.width as CGFloat
                                let swipeLength = abs(horizontalAmount)
                                if swipeLength > 100 {
                                    self.isCardFlipped.toggle()
                                    FlipViewModel.flipCard()
                                }
                            }
                    )
                    Spacer()
                    
                    // MARK: - BUTTON
                    
                    Button(action: {
                        if let selectedImage = selectedImage {
                            viewModel.updateCard(postId: postId, image: selectedImage, card: workingCard) { result in
                                switch result {
                                case .success:
                                    self.presentationMode.wrappedValue.dismiss()
                                case .failure:
                                    // 에러 처리는 viewModel에서 진행. Alert는 아래에서 설정.
                                    break
                                }
                            }
                        } else if let imageUrl = workingCard.image?.encodedImageURL() {
                            SDWebImageManager.shared.loadImage(with: imageUrl, options: .highPriority, progress: nil) { (image, _, _, _, _, _) in
                                viewModel.updateCard(postId: postId, image: image, card: workingCard) { result in
                                    switch result {
                                    case .success:
                                        self.presentationMode.wrappedValue.dismiss()
                                    case .failure:
                                        // 에러 처리는 viewModel에서 진행. Alert는 아래에서 설정.
                                        break
                                    }
                                }
                            }
                        }
                    }) {
                        Text("완료")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                Group {
                                    if isButtonPressed {
                                        LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.9), Color.red.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                                    } else {
                                        Color.red
                                    }
                                }
                            )
                            .cornerRadius(15)
                    }

                    .scaleEffect(isButtonPressed ? 0.97 : 1.0)
                    .onLongPressGesture(minimumDuration: isButtonPressed ? 0 : 0.5, pressing: { pressing in
                        withAnimation {
                            self.isButtonPressed = pressing
                        }
                    }, perform: {})
                    .padding([.horizontal, .bottom])
                }
                .navigationBarTitle("기록 수정하기", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.primary)
                    }
                )
            }
        }
        .alert(isPresented: $viewModel.isError, content: {
            Alert(title: Text("Error"),
                  message: Text(viewModel.errorMessage),
                  dismissButton: .default(Text("OK")))
        })
    }
}





// MARK: - FRONT VIEW

struct EditCardFrontView: View {
    
    // MARK: - PROPERTIES
    
    @Binding var card: Card
    @EnvironmentObject var viewModel: CardViewModel
    
    // 이미지 관련
    @State private var isShowingImagePicker = false
    
    @Environment(\.colorScheme) var colorScheme
    @State private var presentAlert = false
    @Binding var selectedImageFromPicker: UIImage?


    // MARK: - BODY

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer()
                if let uiImage = selectedImageFromPicker {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                        .padding()
                        .onTapGesture {
                            isShowingImagePicker = true
                        }
                } else {
                    WebImage(url: card.image?.encodedImageURL())
                        .onFailure { _ in }
                        .resizable()
                        .placeholder {
                            Image(systemName: "camera")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                    
                        .indicator { _, _ in
                            ProgressView() // 이미지 로딩 중에 ProgressView
                        }
                        .transition(.fade(duration: 0.5))
                        .scaledToFit()
                        .cornerRadius(20)
                        .padding()
                        .onTapGesture {
                            isShowingImagePicker = true
                        }
                }
                Spacer()

                VStack {
                    TextField("한 줄 평을 입력해주세요", text: Binding<String>(
                        get: { card.comment ?? "" },
                        set: {
                            if $0.count > 25 {
                                card.comment = String($0.prefix(25))
                            } else {
                                card.comment = $0
                            }
                        }
                    ))
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .opacity(0.85)
                    
                    Text("\(card.comment?.count ?? 0)/25")
                        .font(.footnote)
                        .foregroundColor((card.comment?.count ?? 0) >= 20 ? .red : .secondary)
                }
                .padding(.bottom)
                .padding(.horizontal)   // 텍스트 뷰 가로 공간 확보
                
                Spacer()
            } //: VSTACK
        } //: GEO
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? [.gray.opacity(0.3), .white] : [.gray.opacity(0.7), .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea(.all)
            .opacity(0.85)
        )
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: $selectedImageFromPicker)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}




// MARK: - BACK VIEW

struct EditCardBackView: View {
    
    @Binding var card: Card
    @EnvironmentObject var viewModel: CardViewModel

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
                    
                    Picker(
                        selection: Binding<Int>(
                            get: { self.card.views ?? 0 },
                            set: { self.card.views = $0 }),
                        label: Text("회")
                    ) { ForEach(0..<100) { index in
                        Text("\(index)").tag(index)}
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 60, height: 50, alignment: .center)
                    
                    Text("회")
                        .font(.body)
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
                Spacer()
            }
        }
        .padding([.horizontal, .vertical]) // 내용 간 간격
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
