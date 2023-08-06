//
//  EmojiPicker.swift
//  myADD
//
//
//

import SwiftUI
import EmojiPicker

struct EmojiPicker: View {
    @State
        var selectedEmoji: Emoji?

        @State
        var displayEmojiPicker: Bool = false

        var body: some View {
            VStack {
                VStack {
                    Text(selectedEmoji?.value ?? "")
                        .font(.largeTitle)
                    Text(selectedEmoji?.name ?? "")
                        .font(.title3)
                }
                .padding(8)
                Button {
                    displayEmojiPicker = true
                } label: {
                    Text("Select emoji")
                }
            }
            .padding()
            .sheet(isPresented: $displayEmojiPicker) {
                NavigationView {
                    EmojiPickerView(selectedEmoji: $selectedEmoji, selectedColor: .orange)
                        .navigationTitle("Emojis")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
}

struct EmojiPicker_Previews: PreviewProvider {
    static var previews: some View {
        EmojiPicker()
    }
}
