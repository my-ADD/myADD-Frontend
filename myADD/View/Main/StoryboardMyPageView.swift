//
//  StoryboardMyPageView.swift
//  myADD
//
//  
//

import SwiftUI

// MARK: - STORYBOARD MYPAGE VIEW

struct StoryboardMyPageView : UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyPageViewController")
        
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
    }
}
