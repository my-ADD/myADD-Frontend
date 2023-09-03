//
//  ContentView.swift
//  myADD
//
//  
//

import FSCalendar
import SwiftUI

struct ContentView: View {
    @State private var selectedDate: Date?
    @EnvironmentObject var viewModel: CardViewModel

    @State private var showingCardView: Bool = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                CalendarView(selectedDate: $selectedDate, datesWithEvents: viewModel.datesWithEvents)
                    .padding()
                    .frame(height: 400)
                    .onChange(of: selectedDate) { newDate in
                        if let date = newDate {
                            showingCardView = true
                        }
                    }
                Divider()
                Spacer()
                
            }
            .sheet(isPresented: $showingCardView) {
                if let date = selectedDate {
                    CalendarCardView(createdAt: date.toString())
                        .environmentObject(viewModel)
                }
            }
            .onAppear {
                viewModel.fetchDatesFromServer()
            }
        }
        .navigationBarTitle("캘린더", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.backward")
                .foregroundColor(.primary)
        })
    }
}

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CardViewModel())
    }
}

