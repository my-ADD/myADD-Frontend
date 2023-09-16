//
//  SceneDelegate.swift
//  myADD
//
//  
//

import UIKit
import SwiftUI
import FirebaseAuth
import FirebaseCore
import Alamofire

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let userDefaults = UserDefaults.standard
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if Auth.auth().currentUser != nil || (userDefaults.object(forKey: "isLogin") != nil && userDefaults.object(forKey: "email") != nil && userDefaults.object(forKey: "password") != nil) {
            let hostingLoginViewController = UIHostingController(rootView: MainView())
            hostingLoginViewController.modalTransitionStyle = .coverVertical
            hostingLoginViewController.modalPresentationStyle = .fullScreen
            self.window?.rootViewController = hostingLoginViewController
            self.window?.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        let email = userDefaults.object(forKey: "email") as? String
        let password = userDefaults.object(forKey: "password") as? String
        
        if email != nil && password != nil {
            LoginService.shared.login(email: email!, password: password!) { response in
                switch response {
                case .success(let data):
                    print("server \(email) 로그인")
                case .requestErr(let message):
                    if let message = message as? String {
                        print(message)
                    }
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
                }
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
    }
}

