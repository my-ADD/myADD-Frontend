//
//  OnboardingSlideView.swift
//  myADD
//
//  Created by 이융의 on 2023/09/03.
//

import SwiftUI

struct OnboardingSlideView: View {
    // MARK: - Properties
    var data: OnboardingData
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 10) {
            Image(uiImage: data.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 400)
            
                .mask(LinearGradient(gradient: Gradient(colors: [Color.white, Color.clear]), startPoint: .center, endPoint: .bottom))

            Text(data.title)
                .font(.title)
                .fontWeight(.bold)
            
            Text(data.description)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct OnboardingSlideView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingSlideView(data: OnboardingData(image: UIImage(named: "onboarding1") ?? UIImage(), title: "환영합니다", description: "나의 시청물 컬렉션 서비스\nmy ADD"))
    }
}
