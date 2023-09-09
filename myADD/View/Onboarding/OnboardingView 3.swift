//
//  OnboardingView.swift
//  myADD
//
//  Created by 이융의 on 2023/09/03.
//

import SwiftUI

struct OnboardingView: View {
    // MARK: - Properties
    @State private var selectedPage: Int = 0
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    // MARK: - Body
    var body: some View {
        VStack {
            TabView(selection: $selectedPage) {
                ForEach(onboardingData.indices) { index in
                    OnboardingSlideView(data: onboardingData[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))

            
            Button(action: {
                isOnboarding = false
            }) {
                Text("시작하기")
                    .font(.headline)
                    .padding()
                    .background(Capsule().fill(Color.blue))
                    .foregroundColor(.white)
            }
            .padding(.top, 20)
        }
        .padding()
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

