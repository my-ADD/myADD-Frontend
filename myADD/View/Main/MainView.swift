//
//  MainView.swift
//  myADD
//
// 
//

import SwiftUI

struct MainView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = CardViewModel()
    @State private var showingAddCardView = false
    
    @State private var isGridViewActive = false
    private let haptics = UIImpactFeedbackGenerator(style: .medium)
    
    @State private var selectedTab: CardCategory = .animation
    
    @State private var selectedPlatform: OTTPlatform? = .전체
    @State private var showingPlatformPicker = false

    // onboarinding
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    @State private var selectedPage: Int = 0

    // MARK: - Body
    
    var body: some View {
        mainNavigationView
            .alert(isPresented: $viewModel.isError, content: {
                Alert(title: Text("오류"),
                      message: Text(viewModel.errorMessage),
                      dismissButton: .default(Text("확인")))
            })
            .fullScreenCover(isPresented: $isFirstLaunching) {
                OnboardingView(isFirstLaunching: $isFirstLaunching)
            }
    }

    // MARK: - Subviews

    private var mainNavigationView: some View {
        NavigationView {
            ZStack {
                VStack {
                    TopBarView().environmentObject(viewModel)
                    
                    ToggleViewSelector(
                        selectedPlatform: $selectedPlatform,
                        showingPlatformPicker: $showingPlatformPicker,
                        isGridViewActive: $isGridViewActive,
                        selectedTab: $selectedTab
                    ).environmentObject(viewModel)

                    mainContent
                }
                addButton
            }
        }
    }

    
    // MARK: - MAIN CONTENT
    
    private var mainContent: some View {
        Group {
            TabView(selection: $selectedTab) {
                viewForTab(image: "a.square.fill", category: .animation)
                viewForTab(image: "d.square.fill", category: .drama)
                viewForTab(image: "d.square.fill", category: .documentary)
            }
            .onChange(of: selectedPlatform) { _ in
                updateContent()
            }
            .onChange(of: selectedTab) { _ in
                updateContent()
            }
        }
    }
    
    func updateContent() {
        viewModel.updateContentFor(selectedPlatform: selectedPlatform, selectedTab: selectedTab)
    }


    private var filteredCardsView: some View {
        let filteredCards = viewModel.cardsForSelectedTab(selectedTab, platform: selectedPlatform)
        return isGridViewActive ? AnyView(GridLayoutView(cards: filteredCards)) : AnyView(CardPaperView(cards: filteredCards))
    }

    private func viewForTab(image: String, category: CardCategory) -> some View {
        filteredCardsView
            .environmentObject(viewModel)
            .tabItem {
                Image(systemName: image)
                Text(selectedTab == category ? category.rawValue : "")
            }
            .tag(category)
    }

    
    // MARK: - ADD BUTTON

    private var addButton: some View {
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
                    AddCardView(viewModel: viewModel)
                }
            }
        }
    }
}


enum OTTPlatform: String, CaseIterable {
    case 전체 = "전체"
    case 넷플릭스 = "넷플릭스"
    case 티빙 = "티빙"
    case 쿠팡플레이 = "쿠팡 플레이"
    case 디즈니플러스 = "디즈니 플러스"
    case 라프텔 = "라프텔"
    case 웨이브 = "웨이브"
    case 왓챠 = "왓챠"
    case 기타 = "기타"
}


// MARK: - PREVIEW

struct MainView_Previews: PreviewProvider {

    static var previews: some View {
        MainView()
    }
}


