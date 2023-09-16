//
//  OnboardingSlideView.swift
//  myADD
//
//  
//

import SwiftUI

struct OnboardingSlideView: View {
    var data: OnboardingData

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            if data.imageName == "logo" {
                Image(data.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
            } else {
                Image(data.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 300)
                    .mask(LinearGradient(gradient: Gradient(colors: [Color.white, Color.clear]), startPoint: .center, endPoint: .bottom))
            }

            Text(data.title)
                .font(.title)
                .fontWeight(.bold)

            Text(data.description)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 20)
        }
        .padding(.vertical, 20)
    }
}
