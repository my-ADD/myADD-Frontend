//
//  ToggleViewSelector.swift
//  myADD
//
//  
//

import SwiftUI

struct ToggleViewSelector: View {
    @Binding var selectedPlatform: OTTPlatform?
    @Binding var showingPlatformPicker: Bool
    @Binding var isGridViewActive: Bool
    @Binding var selectedTab: CardCategory
    @EnvironmentObject var viewModel: CardViewModel

    private let haptics = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        HStack {
            Text(viewModel.getHeaderText(for: selectedTab, in: selectedPlatform))
                .multilineTextAlignment(.leading)
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            VStack {
                
                Button(action: {
                    showingPlatformPicker.toggle()
                }) {
                    HStack {
                        Image(systemName: "chevron.down")
                        Text(selectedPlatform?.rawValue ?? "플랫폼 선택")
                    }
                }
                .actionSheet(isPresented: $showingPlatformPicker) {
                    ActionSheet(title: Text("플랫폼 선택"), buttons: OTTPlatform.allCases.map { platform in
                        .default(Text(platform.rawValue)) {
                            selectedPlatform = platform
                        }
                    } + [.cancel(Text("취소"))])
                }
                .padding(.bottom, 10)

                
                HStack {
                    toggleButton(imageName: "square.3.layers.3d.down.backward", isActive: !isGridViewActive) {
                        isGridViewActive = false
                    }
                    
                    toggleButton(imageName: "square.grid.2x2", isActive: isGridViewActive) {
                        isGridViewActive = true
                    }
                }
            }
        }
        .padding([.top, .horizontal])
    }
    
    private func toggleButton(imageName: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
            haptics.impactOccurred()
        }) {
            Image(systemName: imageName)
                .font(.title2)
                .foregroundColor(isActive ? .accentColor : .primary)
        }
    }
}
