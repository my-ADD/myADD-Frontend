//
//  TopBarView.swift
//  myADD
//
// 
//

import SwiftUI

struct TopBarView: View {
    @EnvironmentObject var viewModel: CardViewModel
    
    var body: some View {
        HStack {
            logo
            Spacer()
            //onboardingViewLink
            canlendarViewLink
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
    /*
    private var onboardingViewLink: some View {
        NavigationLink(destination: OnboardingView()) {
            Image(systemName: "lanyardcard")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
                .accentColor(Color.primary)
                .padding(.trailing)
        }
    }*/
    

    private var canlendarViewLink: some View {
        NavigationLink(destination: ContentView().environmentObject(viewModel)) {
            Image(systemName: "calendar")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
                .accentColor(Color.primary)
                .padding(.trailing)
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
