//
//  MemoInputView.swift
//  myADD
//
//  
//

import SwiftUI

struct MemoInputView: View {
    @Binding var memo: String?
    
    var body: some View {
        let memoBinding = Binding<String>(
            get: { self.memo ?? "" },
            set: {
                if $0.count <= 200 {
                    self.memo = $0
                } else {
                    self.memo = String($0.prefix(200))
                }
            }
        )
        
        VStack {
            TextEditor(text: memoBinding)
                .padding()
                .multilineTextAlignment(.leading)

            Text("\(memo?.count ?? 0) / 200")
                .font(.caption)
                .foregroundColor((memo?.count ?? 0) >= 200 ? .red : .gray)
            
            Spacer()
        }
        .padding()
    }
}


struct MemoInputView_Previews: PreviewProvider {
    @State static var memo: String? = "Hello, World!"

    static var previews: some View {
        MemoInputView(memo: $memo)
    }
}
