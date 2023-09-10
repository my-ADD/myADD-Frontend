//
//  LoginViewController.swift
//  myADD
//
// 
//

import Foundation
import UIKit
import SwiftUI
import FirebaseCore
import FirebaseAuth
import Alamofire
import Photos

class LoginViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    @IBOutlet var passwordChangeCode: UITextField!
    @IBOutlet var changedPassword: UITextField!
    @IBOutlet var changedPasswordCheck: UITextField!
    @IBOutlet var passwordChangeErrorLabel: UILabel!
    
    @IBOutlet weak var infoNickname: UILabel!
    @IBOutlet weak var profileEditNickname: UITextField!
    
    @IBOutlet var myPageProfileImage: UIImageView!
    @IBOutlet var profileEditImage: UIImageView!
    @IBOutlet var profileEditImageButton: UIButton!
    let imagePickerController = UIImagePickerController()
    
    var termsAllCheck = false
    var termsCheck1 = false
    var termsCheck2 = false
    
    let userDefaults = UserDefaults.standard
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nicknameDefaults()
        self.profileImageDefaults()
        imagePickerController.delegate = self
        PHPhotoLibrary.requestAuthorization { status in }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let _ = handle {
            Auth.auth().removeStateDidChangeListener(handle!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.nicknameDefaults()
        self.profileImageDefaults()
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
                        
                        DuplicateService.shared.duplicate(email: email) { response in
                            switch response {
                            case .success(let data):
                                SignUpService.shared.signUp(email: email, password: password,  nickname: nickname!) { response in
                                    switch response {
                                    case .success(let data):
                                        print("server \(email) 가입 완료")
                                        let signupFinishedViewController = self.storyboard?.instantiateViewController(identifier: "signupFinishedViewController")
                                        signupFinishedViewController?.modalTransitionStyle = .coverVertical
                                        signupFinishedViewController?.modalPresentationStyle = .fullScreen
                                        self.present(signupFinishedViewController!, animated: true, completion: nil)
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
        
        LoginService.shared.login(email: email, password: password) { response in
            switch response {
            case .success(let data):
                print("server \(email) 로그인")
                
                self.userDefaults.set(true, forKey: "isLogin")
                self.userDefaults.set(self.loginEmail.text, forKey: "email")
                self.userDefaults.set(self.loginPassword.text, forKey: "password")
                let password = self.userDefaults.object(forKey: "password") as! String
                
                GetInfoService.shared.getInfo() { response in
                    switch response {
                    case .success(let data):
                        print("server 회원 정보")
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
              
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                    guard let strongSelf = self else { return }
                    if let error = error { print(error) }
                    if let result = authResult, let userEmail =  result.user.email {
                        print("\(userEmail) 로그인")
                    }
                }
                let hostingLoginViewController = UIHostingController(rootView: MainView())
                hostingLoginViewController.modalTransitionStyle = .coverVertical
                hostingLoginViewController.modalPresentationStyle = .fullScreen
                self.present(hostingLoginViewController, animated: true)
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
    
    @IBAction func logoutButton(_ sender: Any) {
        
        self.userDefaults.removeObject(forKey: "isLogin")
        self.userDefaults.removeObject(forKey: "email")
        self.userDefaults.removeObject(forKey: "password")
        
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
    
    @IBAction func sendCodeButton(_ sender: Any) {
        
        guard let email = self.passwordChangeEmail.text else { return }
        userDefaults.set(self.passwordChangeEmail.text, forKey: "changePasswordEmail")
        
        SendCodeService.shared.sendCode(email: email) { response in
            switch response {
            case .success(let data):
                print("server \(email) 비밀번호 변경 요청")
                let checkCodeViewController = self.storyboard?.instantiateViewController(identifier: "checkCodeViewController")
                checkCodeViewController?.modalTransitionStyle = .coverVertical
                checkCodeViewController?.modalPresentationStyle = .fullScreen
                self.present(checkCodeViewController!, animated: true, completion: nil)
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
    
    @IBAction func checkCodeButton(_ sender: Any) {
        
        let email = userDefaults.object(forKey: "changePasswordEmail") as? String
        guard let code = Int(self.passwordChangeCode.text!) else { return }
        
        CheckCodeService.shared.checkCode(email: email!, code: code) { response in
            switch response {
            case .success(let data):
                print("server \(email) 인증번호 입력")
                let changePasswordViewController = self.storyboard?.instantiateViewController(identifier: "changePasswordViewController")
                changePasswordViewController?.modalTransitionStyle = .coverVertical
                changePasswordViewController?.modalPresentationStyle = .fullScreen
                self.present(changePasswordViewController!, animated: true, completion: nil)
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
    
    @IBAction func checkCodeBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changePasswordButton(_ sender: Any) {
        
        let email = userDefaults.object(forKey: "changePasswordEmail") as? String
        guard let password = self.changedPassword.text else { return }
        guard let passwordCheck = self.changedPasswordCheck.text else { return }
        
        self.passwordChangeErrorLabel.text = ""
        
        if password != passwordCheck {
            
            self.passwordChangeErrorLabel.text = "비밀번호가 일치하지 않습니다."
            
        }
        else {
            if password == passwordCheck {
                ChangePasswordService.shared.changePassword(email: email!, password: password) { response in
                    switch response {
                    case .success(let data):
                        print("server \(email) 비밀번호 변경 완료")
                        let loginViewController = self.storyboard?.instantiateViewController(identifier: "loginViewController")
                        loginViewController?.modalTransitionStyle = .coverVertical
                        loginViewController?.modalPresentationStyle = .fullScreen
                        self.present(loginViewController!, animated: true, completion: nil)
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
    
    @IBAction func changePasswordBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func myADDInfoButton(_ sender: Any) {
        let myADDInfoViewController = self.storyboard?.instantiateViewController(identifier: "myADDInfoViewController")
        myADDInfoViewController?.modalTransitionStyle = .coverVertical
        myADDInfoViewController?.modalPresentationStyle = .fullScreen
        self.present(myADDInfoViewController!, animated: true, completion: nil)
    }
    
    @IBAction func myADDInfoBackButton(_ sender: Any) {
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
        self.imagePickerController.sourceType = .photoLibrary
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            print("notDetermined")
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorized:
            self.present(self.imagePickerController, animated: true, completion: nil)
        case .limited:
            print("limited")
        @unknown default:
            print( "unknown")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] {
            profileEditImage.image = image as? UIImage
            
            profileEditImage.layer.cornerRadius = profileEditImage.frame.height / 2
            profileEditImage.layer.borderWidth = 1
            profileEditImage.layer.borderColor = UIColor.clear.cgColor
            profileEditImage.contentMode = .scaleAspectFill
            profileEditImage.clipsToBounds = true
        }
        dismiss(animated: true , completion: nil)
        let profileEditImage = profileEditImage.image!.jpegData(compressionQuality: 1.0)
        userDefaults.set(profileEditImage, forKey: "profileImage")
    }
    
    func profileImageDefaults() {
        guard let imageData = userDefaults.object(forKey: "profileImage") as? Data else { return }
        let image = UIImage(data: imageData)
        profileEditImage?.image = image
        profileEditImage?.layer.cornerRadius = profileEditImage.frame.height / 2
        profileEditImage?.layer.borderWidth = 1
        profileEditImage?.layer.borderColor = UIColor.clear.cgColor
        profileEditImage?.contentMode = .scaleAspectFill
        profileEditImage?.clipsToBounds = true
        myPageProfileImage?.image = image
        myPageProfileImage?.image = image
        myPageProfileImage?.layer.cornerRadius = myPageProfileImage.frame.height / 2
        myPageProfileImage?.layer.borderWidth = 1
        myPageProfileImage?.layer.borderColor = UIColor.clear.cgColor
        myPageProfileImage?.contentMode = .scaleAspectFill
        myPageProfileImage?.clipsToBounds = true
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
        
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                print(error)
            } else {
                print("delete account")
            }
        }
        
        self.userDefaults.removeObject(forKey: "isLogin")
        self.userDefaults.removeObject(forKey: "email")
        self.userDefaults.removeObject(forKey: "password")
        self.userDefaults.set("회원", forKey: "nickname")
        self.userDefaults.removeObject(forKey: "profileImage")
        
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
