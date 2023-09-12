//
//  OnboardingView.swift
//  myADD
//
//  
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @State private var selectedPage: Int = 0

    var body: some View {
        VStack {
            TabView(selection: $selectedPage) {
                ForEach(0..<onboardingData.count, id: \.self) { index in
                    OnboardingSlideView(data: onboardingData[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))

            if selectedPage == onboardingData.count - 1 {
                Button(action: {
                    isOnboarding = false
                }) {
                    Text("시작하기")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Capsule().fill(Color.red))
                }
                .padding(.horizontal)
                .padding(.top, 20)
            } else {
                Button(action: {
                    if selectedPage < onboardingData.count - 1 {
                        withAnimation {
                            selectedPage += 1
                        }
                    }
                }) {
                    Text("다음")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Capsule().fill(Color.red))
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
        }
        .padding()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

