//
//  LoginViewController.swift
//  myADD
//
// 
//

import Foundation
import UIKit
import SwiftUI
import KakaoSDKCommon
import KakaoSDKTalk
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKTemplate
import KakaoSDKShare
import SafariServices
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet var termsAllCheckButton: UIButton!
    @IBOutlet var termsCheck1Button: UIButton!
    @IBOutlet var termsCheck2Button: UIButton!
    @IBOutlet var termsNextButton: UIButton!
    @IBOutlet var signUpNickname: UITextField!
    @IBOutlet var signUpErrorLabel: UILabel!
    @IBOutlet var signUpEmail: UITextField!
    @IBOutlet var signUpPassword: UITextField!
    @IBOutlet var signUpPasswordCheck: UITextField!
    
    @IBOutlet var loginEmail: UITextField!
    @IBOutlet var loginPassword: UITextField!
    
    @IBOutlet var passwordChangeEmail: UITextField!
    
    @IBOutlet weak var mainNickname: UILabel!
    @IBOutlet weak var infoNickname: UILabel!
    @IBOutlet weak var profileEditNickname: UITextField!
    
    @IBOutlet var myPageProfileImage: UIImageView!
    @IBOutlet var profileEditImage: UIImageView!
    
    var termsAllCheck = false
    var termsCheck1 = false
    var termsCheck2 = false
    
    let userDefaults = UserDefaults.standard
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nicknameDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                print("\(user.email ?? "nil")")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let _ = handle {
            Auth.auth().removeStateDidChangeListener(handle!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.nicknameDefaults()
    }
    
    // 텍스트 필드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
            self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == profileEditNickname{
            textField.resignFirstResponder()
        }
        return true
    }
    
    // 일반 로그인
    @IBAction func signUpButton(_ sender: Any) {
        
        guard let email = self.signUpEmail.text else { return }
        guard let password = self.signUpPassword.text else { return }
        guard let passwordCheck = self.signUpPasswordCheck.text else { return }
        // guard let nickname = self.signUpEmail.text else { return } // self.signUpNickname.text else { return }
        let nickname = userDefaults.object(forKey: "nickname") as? String
        
        self.signUpErrorLabel.text = ""
        
        if password != passwordCheck {
            
            self.signUpErrorLabel.text = "비밀번호가 일치하지 않습니다."
            
        }
        else {
            if password == passwordCheck {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    
                    if let error = error { print(error)
                        
                        let errorcode = error as NSError
                        
                        switch errorcode.code{
                            
                        case AuthErrorCode.invalidEmail.rawValue:
                            self.signUpErrorLabel.text = "이메일 형식이 잘못되었습니다."
                        case AuthErrorCode.emailAlreadyInUse.rawValue:
                            self.signUpErrorLabel.text = "이미 존재하는 이메일입니다."
                        case AuthErrorCode.weakPassword.rawValue:
                            self.signUpErrorLabel.text = "6자 이상의 비밀번호가 아닙니다."
                            
                        default:
                            print("error")
                        }
                    }
                    
                    if let result = authResult, let userEmail = result.user.email {
                        print("\(userEmail) 가입 완료")
                        let signupFinishedViewController = self.storyboard?.instantiateViewController(identifier: "signupFinishedViewController")
                        signupFinishedViewController?.modalTransitionStyle = .coverVertical
                        signupFinishedViewController?.modalPresentationStyle = .fullScreen
                        self.present(signupFinishedViewController!, animated: true, completion: nil)
                        
                    }
                }
                
                SignUpService.shared.signUp(email: email, password: password,  nickname: nickname!) { response in
                    switch response {
                                case .success(let data):
                        if let signUpData = data as? SignUpData {
                                      print("server \(signUpData.email) 가입 완료")
                                    }
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
    }
    
    @IBAction func termsAllCheckButton(_ sender: Any) {
        
        if (termsCheck1 == false || termsCheck2 == false) {
            termsAllCheckButton.setImage(UIImage(named: "AllCheckButton"), for: UIControl.State.normal)
            termsCheck1Button.setImage(UIImage(named: "CheckButton"), for: UIControl.State.normal)
            termsCheck2Button.setImage(UIImage(named: "CheckButton"), for: UIControl.State.normal)
            termsCheck1 = true
            termsCheck2 = true
            termsAllCheck = true
            termsNextButton.setImage(UIImage(named: "NextButton"), for: UIControl.State.normal)
        }
        else {
            termsAllCheckButton.setImage(UIImage(named: "AllUncheckButton"), for: UIControl.State.normal)
            termsCheck1Button.setImage(UIImage(named: "UncheckButton"), for: UIControl.State.normal)
            termsCheck2Button.setImage(UIImage(named: "UncheckButton"), for: UIControl.State.normal)
            termsCheck1 = false
            termsCheck2 = false
            termsAllCheck = false
            termsNextButton.setImage(UIImage(named: "NextGrayButton"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func termsCheck1Button(_ sender: Any) {
        
        if termsCheck1 == false {
            termsCheck1Button.setImage(UIImage(named: "CheckButton"), for: UIControl.State.normal)
            termsCheck1 = true
            
            if termsCheck2 == true {
                termsAllCheckButton.setImage(UIImage(named: "AllCheckButton"), for: UIControl.State.normal)
                termsAllCheck = true
                termsNextButton.setImage(UIImage(named: "NextButton"), for: UIControl.State.normal)
            }
        }
        else {
            termsCheck1Button.setImage(UIImage(named: "UncheckButton"), for: UIControl.State.normal)
            termsCheck1 = false
            
            if termsAllCheck == true {
                termsAllCheckButton.setImage(UIImage(named: "AllUncheckButton"), for: UIControl.State.normal)
                termsNextButton.setImage(UIImage(named: "NextGrayButton"), for: UIControl.State.normal)
                termsAllCheck = false
            }
        }
    }
    
    @IBAction func termsCheck2Button(_ sender: Any) {
        
        if termsCheck2 == false {
            termsCheck2Button.setImage(UIImage(named: "CheckButton"), for: UIControl.State.normal)
            termsCheck2 = true
            
            if termsCheck1 == true {
                termsAllCheckButton.setImage(UIImage(named: "AllCheckButton"), for: UIControl.State.normal)
                termsAllCheck = true
                termsNextButton.setImage(UIImage(named: "NextButton"), for: UIControl.State.normal)
            }
        }
        else {
            termsCheck2Button.setImage(UIImage(named: "UncheckButton"), for: UIControl.State.normal)
            termsCheck2 = false
            
            if termsAllCheck == true {
                termsAllCheckButton.setImage(UIImage(named: "AllUncheckButton"), for: UIControl.State.normal)
                termsNextButton.setImage(UIImage(named: "NextGrayButton"), for: UIControl.State.normal)
                termsAllCheck = false
            }
        }
    }
    
    @IBAction func signUpTermsButton(_ sender: Any) {
        
        if (termsCheck1 == true && termsCheck2 == true) {
            let nicknameViewController = self.storyboard?.instantiateViewController(identifier: "nicknameViewController")
            nicknameViewController?.modalTransitionStyle = .coverVertical
            nicknameViewController?.modalPresentationStyle = .fullScreen
            self.present(nicknameViewController!, animated: false, completion: nil)
        }
    }
    @IBAction func termsAgree1Button(_ sender: Any) {
        let termsOfUseViewController = self.storyboard?.instantiateViewController(identifier: "termsOfUseViewController")
        termsOfUseViewController?.modalTransitionStyle = .coverVertical
        termsOfUseViewController?.modalPresentationStyle = .fullScreen
        self.present(termsOfUseViewController!, animated: false, completion: nil)
    }
    @IBAction func termsAgree2Button(_ sender: Any) {
        let termsOfPrivacyViewController = self.storyboard?.instantiateViewController(identifier: "termsOfPrivacyViewController")
        termsOfPrivacyViewController?.modalTransitionStyle = .coverVertical
        termsOfPrivacyViewController?.modalPresentationStyle = .fullScreen
        self.present(termsOfPrivacyViewController!, animated: false, completion: nil)
    }
    
    @IBAction func termsBack1Button(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func termsBack2Button(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func signUpTermsBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func nicknameDefaults() {
        let nickname = userDefaults.object(forKey: "nickname") as? String
        print("닉네임:" + (nickname ?? "nil"))
        mainNickname?.text = (nickname ?? "회원") + "님의"
        infoNickname?.text = (nickname ?? "회원") + "님"
        profileEditNickname?.text = nickname
    }
    
    @IBAction func signUpNicknameButton(_ sender: Any) {
        
        userDefaults.set(self.signUpNickname.text, forKey: "nickname")
        
        guard let signUpViewController = self.storyboard?.instantiateViewController(identifier: "signUpViewController") as? LoginViewController else { return }
        signUpViewController.modalTransitionStyle = .coverVertical
        signUpViewController.modalPresentationStyle = .fullScreen
        self.present(signUpViewController, animated: false, completion: nil)
    }
    
    
    @IBAction func signUpNicknameBackButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func signUpBackButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        guard let email = self.loginEmail.text else { return }
        guard let password = self.loginPassword.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error { print(error) }
            if let result = authResult, let userEmail =  result.user.email {
                print("\(userEmail)으로 로그인")
                
                let hostingLoginViewController = UIHostingController(rootView: MainView())
                hostingLoginViewController.modalTransitionStyle = .coverVertical
                hostingLoginViewController.modalPresentationStyle = .fullScreen
                self?.present(hostingLoginViewController, animated: true)
            }
            
            LoginService.shared.login(email: email, password: password) { response in
                switch response {
                            case .success(let data):
                    if let loginData = data as? LoginData {
                                  print("server \(loginData.email)으로 로그인")
                                }
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
    
    @IBAction func logoutButton(_ sender: Any) {
        let auth = Auth.auth()
        do {
            try auth.signOut()
            print("로그아웃 성공")
            
            let loginViewController = self.storyboard?.instantiateViewController(identifier: "loginViewController")
            loginViewController?.modalTransitionStyle = .coverVertical
            loginViewController?.modalPresentationStyle = .fullScreen
            self.present(loginViewController!, animated: true, completion: nil)
            
        } catch let logoutError as NSError {
            print("로그아웃 에러: %@", logoutError)
        }
        LogoutService.shared.logout() { response in
            switch response {
                        case .success(let data):
                              print("server 로그아웃 성공")
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
    
    @IBAction func passwordChangeButton(_ sender: Any) {
        
        guard let email = self.passwordChangeEmail.text else { return }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            guard let error = error else
            {
                print("재설정 메일 발송")
                return
            }
            let nsError : NSError = error as NSError
            switch nsError.code
            {
            case 17011:
                print("존재하지 않는 이메일입니다.")
            default:
                break
            }
        }
    }
    
    
    // 카카오 로그인
    @IBAction func kakaologin(_ sender: Any) {
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    
                    //do something
                    _ = oauthToken
                    self.getKakaoInfo()
                    
                    let hostingLoginViewController = UIHostingController(rootView: MainView())
                    hostingLoginViewController.modalTransitionStyle = .coverVertical
                    hostingLoginViewController.modalPresentationStyle = .fullScreen
                    self.present(hostingLoginViewController, animated: true)
                }
            }
            
        }
        else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    
                    //do something
                    _ = oauthToken
                    self.getKakaoInfo()
                    
                    let hostingLoginViewController = UIHostingController(rootView: MainView())
                    hostingLoginViewController.modalTransitionStyle = .coverVertical
                    hostingLoginViewController.modalPresentationStyle = .fullScreen
                    self.present(hostingLoginViewController, animated: true)
                }
                
            }
        }
    }
    
    @IBAction func kakaologout(_ sender: Any) {
        
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
                
                let loginViewController = self.storyboard?.instantiateViewController(identifier: "loginViewController")
                loginViewController?.modalTransitionStyle = .coverVertical
                loginViewController?.modalPresentationStyle = .fullScreen
                self.present(loginViewController!, animated: true, completion: nil)
            }
        }
        
    }
    
    private func getKakaoInfo() {
        
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                
                let nickname = user?.kakaoAccount?.profile?.nickname
                let email = user?.kakaoAccount?.email
                
                print(email)
                
            }
        }
    }
    
    // 구글 로그인
    @IBAction func googleLoginButton(_ sender: GIDSignInButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else { print(error)
                return }
            
            print(result?.user)
            print(result?.user.profile?.email)
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, authError in
                if let authError = authError { print(authError)
                }
                if let authResult = authResult {
                    print(authResult.user.email)
                    
                    let hostingLoginViewController = UIHostingController(rootView: MainView())
                    hostingLoginViewController.modalTransitionStyle = .coverVertical
                    hostingLoginViewController.modalPresentationStyle = .fullScreen
                    self.present(hostingLoginViewController, animated: true)
                    
                }
            }
        }
    }
    
    @IBAction func googleLogoutButton(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance.signOut()
        } catch let signOutError as NSError {
            print("Logout Error: %@", signOutError)
        }
    }
    
    
    // 프로필
    
    @IBAction func myInfoViewButton(_ sender: Any) {
        let myInfoViewController = self.storyboard?.instantiateViewController(identifier: "myInfoViewController")
        myInfoViewController?.modalTransitionStyle = .coverVertical
        myInfoViewController?.modalPresentationStyle = .fullScreen
        self.present(myInfoViewController!, animated: true, completion: nil)
    }
    
    @IBAction func myInfoBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func profileEditButton(_ sender: Any) {
        let profileEditViewController = self.storyboard?.instantiateViewController(identifier: "profileEditViewController")
        profileEditViewController?.modalTransitionStyle = .coverVertical
        profileEditViewController?.modalPresentationStyle = .fullScreen
        self.present(profileEditViewController!, animated: true, completion: nil)
    }
    
    
    @IBAction func profileEditBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func profileImageEditButton(_ sender: Any) {
    }
    
    @IBAction func profileNicknameEditButton(_ sender: Any) {
        userDefaults.set(self.profileEditNickname.text, forKey: "nickname")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAccountViewButton(_ sender: Any) {
        let deleteAccountViewController = self.storyboard?.instantiateViewController(identifier: "deleteAccountViewController")
        deleteAccountViewController?.modalTransitionStyle = .coverVertical
        deleteAccountViewController?.modalPresentationStyle = .fullScreen
        self.present(deleteAccountViewController!, animated: true, completion: nil)
    }
    
    @IBAction func deleteAccountBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAccountButton(_ sender: Any) {
        
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("unlink() success.")
            }
        }
        
        GIDSignIn.sharedInstance.disconnect { error in
            guard error == nil else { return }
            
        }
        
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                print(error)
            } else {
                print("delete account")
            }
        }
        
        UserDeleteService.shared.userDelete() { response in
            switch response {
                        case .success(let data):
                              print("server 회원 탈퇴")
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
        
        let loginViewController = self.storyboard?.instantiateViewController(identifier: "loginViewController")
        loginViewController?.modalTransitionStyle = .coverVertical
        loginViewController?.modalPresentationStyle = .fullScreen
        self.present(loginViewController!, animated: true, completion: nil)
    }

}
