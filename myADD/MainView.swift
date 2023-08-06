//
//  MainView.swift
//  myADD
//
//
//

import SwiftUI

struct MainView: View {
    // MARK: - PROPERTY
    @State var animationCards: [Card] = animationCardsData
    @State var dramaCards: [Card] = dramaCardsData
    @State var documentaryCards: [Card] = documentaryCardsData
    
    @State private var selectedTab = 1
    @State private var showingAddCardView: Bool = false

    // GRID
    let haptics = UIImpactFeedbackGenerator(style: .medium)
    @State private var isGridViewActive: Bool = false

    // MARK: - BODY
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    HStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                        Spacer()
                        
                        NavigationLink(destination: StoryboardMyPageView()) {
                            Image(systemName: "person")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                                .accentColor(Color.primary)
                        }
                    } //: HSTACK
                    .padding(.horizontal)
                    
                    HStack {
                        Text(getHeaderText())
                            .multilineTextAlignment(.leading)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            // card 형식으로 바꾸는 코드
                            print("Card View is activated.")
                            isGridViewActive = false
                            haptics.impactOccurred()
                        }) {
                            Image(systemName: "square.3.layers.3d.down.backward")
                                .font(.title2)
                                .foregroundColor(isGridViewActive ? .primary : .accentColor)
                        }
                        

                        Button(action: {
                            // grid (gallery) 형식으로 바꾸는 코드
                            print("Grid View is activated.")
                            isGridViewActive = true
                            haptics.impactOccurred()
                        }) {
                            Image(systemName: "square.grid.2x2")
                                .font(.title2)
                                .foregroundColor(isGridViewActive ? .accentColor : .primary)
                        }
                    } //: HSTACK
                    .padding([.top, .horizontal])
                    
                    // 갤러리 뷰의 카드 선택 시 -> 포토카드 뷰로 이동 (이때, 버튼 UI도 변경)
                    
                    
                    // MARK: - GROUP (MAIN CONTENT)
                    Group {
                        if !isGridViewActive {
                            TabView(selection: $selectedTab) {
                                OnboardingView(cards: $animationCards)
                                    .tabItem {
                                        Image(systemName: "a.square.fill")
                                        Text(self.selectedTab == 1 ? "Animation" : "")
                                    }
                                    .tag(1)
                                    .onTapGesture {
                                        self.selectedTab = 1
                                    }
                                
                                OnboardingView(cards: $dramaCards)
                                    .tabItem {
                                        Image(systemName: "d.square.fill")
                                        Text(self.selectedTab == 2 ? "Drama" : "")
                                    }
                                    .tag(2)
                                    .onTapGesture {
                                        self.selectedTab = 2
                                    }
                                
                                OnboardingView(cards: $documentaryCards)
                                    .tabItem {
                                        Image(systemName: "d.square.fill")
                                        Text(self.selectedTab == 3 ? "Documentary" : "")
                                    }
                                    .tag(3)
                                    .onTapGesture {
                                        self.selectedTab = 3
                                    }
                            } //: TAB

                        } else {
                            TabView(selection: $selectedTab) {
                                GridLayoutView(cards: $animationCards)
                                    .tabItem {
                                        Image(systemName: "a.square.fill")
                                        Text(self.selectedTab == 1 ? "Animation" : "")
                                    }
                                    .tag(1)
                                    .onTapGesture {
                                        self.selectedTab = 1
                                    }
                                
                                GridLayoutView(cards: $dramaCards)
                                    .tabItem {
                                        Image(systemName: "d.square.fill")
                                        Text(self.selectedTab == 2 ? "Drama" : "")
                                    }
                                    .tag(2)
                                    .onTapGesture {
                                        self.selectedTab = 2
                                    }
                                
                                GridLayoutView(cards: $documentaryCards)
                                    .tabItem {
                                        Image(systemName: "d.square.fill")
                                        Text(self.selectedTab == 3 ? "Documentary" : "")
                                    }
                                    .tag(3)
                                    .onTapGesture {
                                        self.selectedTab = 3
                                    }
                            } //: TAB
                        } //: CONDITION
                    } //: GROUP
                } //: VSTACK
            } //: NAVIGATION
            
            // MARK: - ADD BUTTON
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        self.showingAddCardView.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundColor(.accentColor)
                            .background(Color.white.clipShape(Circle()))

                    }
                    .padding()
                    .padding(.bottom, 50)
                    .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                    .fullScreenCover(isPresented: $showingAddCardView) {
                        AddCardView(animationCardsData: $animationCards, dramaCardsData: $dramaCards, documentaryCardsData: $documentaryCards)
                    }
                } //: HSACK
            } //: VSTACK
        } //: ZSTACK (ADD BUTTON)
    } //: BODY
    
    // MARK: - METHOD
    
    func getHeaderText() -> String {
        switch selectedTab {
        case 1:
            return "회원님의 \n\(animationCards.count)가지 애니메이션 기록"
        case 2:
            return "회원님의 \n\(dramaCards.count)가지 드라마 기록"
        case 3:
            return "회원님의 \n\(documentaryCards.count)가지 다큐멘터리 기록"
        default:
            return "회원님의 기록"
        }
    }
} //: VIEW

// MARK: - PREVIEW

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct StoryboardMyPageView : UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyPageViewController")
        
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
    }
}
