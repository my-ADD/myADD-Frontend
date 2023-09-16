//
//  TopBarView.swift
//  myADD
//
// 
//

import SwiftUI

struct TopBarView: View {
    @EnvironmentObject var viewModel: CardViewModel
    @State private var isShowingContentView = false

    var body: some View {
        HStack {
            logo
            Spacer()
            allCardListViewLink
            userProfileLink
        }
        .padding([.top, .horizontal])
    }

    private var logo: some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(height: 30)
    }
    
    private var allCardListViewLink: some View {
        Button(action: {
            isShowingContentView = true
        }) {
            Image(systemName: "lanyardcard")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
                .accentColor(Color.primary)
                .padding(.trailing)
        }
        .sheet(isPresented: $isShowingContentView) {
            ContentView().environmentObject(viewModel)
        }
    }

    private var userProfileLink: some View {
        NavigationLink(destination: StoryboardMyPageView()) {
            Image(systemName: "person")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
                .accentColor(Color.primary)
        }
    }
}
