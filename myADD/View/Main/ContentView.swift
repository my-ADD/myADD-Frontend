////
////  ContentView.swift
////  myADD
////
////  
////

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: CardViewModel
    @State private var selectedCard: Card? = nil

    let gridLayout: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        HStack {
            Text(viewModel.getTitleText())
                .multilineTextAlignment(.leading)
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
        }
        .padding()

        
        Spacer()
        
        GeometryReader { geometry in
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                        ForEach(viewModel.cards, id: \.id) { card in
                            NavigationLink(
                                destination:
                                    GridDetailView(card: card)
                                    .scaleEffect(0.9)
                                    .frame(width: geometry.size.width * 0.8, height: (geometry.size.width * 0.8) * 1.5)
                                    .environmentObject(viewModel)
                            ){
                                GridItemView(card: card)
                                    .environmentObject(viewModel)
                            }
                            .isDetailLink(false)
                            .buttonStyle(PlainButtonStyle())
                            .navigationTitle("")
                        }
                    } //: GRID
                    .padding(10)
                } //: SCROLL
            } //: NAVIGATION
            .onAppear {
                viewModel.getListAll() { _ in }
            }
        }
    }
}

