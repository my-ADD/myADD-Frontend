//
//  LoginViewController.swift
//  myADD
//
// 
//

import Foundation
import UIKit
import KakaoSDKCommon
import KakaoSDKTalk
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKTemplate
import KakaoSDKShare
import SafariServices
import NaverThirdPartyLogin
import Alamofire

class LoginViewController: UIViewController, NaverThirdPartyLoginConnectionDelegate {
    
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        naverLoginInstance?.delegate = self
    }

    // 네이버 아이디 로그인
    @objc func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
            print("Success login")
            getNaverInfo()
        }
        
    @objc func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        naverLoginInstance?.accessToken
        }
        
    @objc func oauth20ConnectionDidFinishDeleteToken() {
            print("log out")
        }
        
    @objc func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
            print("error = \(error.localizedDescription)")
        }
        
    @IBAction func naverlogin(_ sender: Any) {
        
        naverLoginInstance?.requestThirdPartyLogin()
    }
    
    @IBAction func naverlogout(_ sender: Any) {
        naverLoginInstance?.requestDeleteToken()
    }
        
    func getNaverInfo() {
          guard let isValidAccessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
          
          if !isValidAccessToken {
            return
          }
          
          guard let tokenType = naverLoginInstance?.tokenType else { return }
          guard let accessToken = naverLoginInstance?.accessToken else { return }
            
          let urlStr = "https://openapi.naver.com/v1/nid/me"
          let url = URL(string: urlStr)!
          
          let authorization = "\(tokenType) \(accessToken)"
          
          let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
          
          req.responseJSON { response in
            guard let result = response.value as? [String: Any] else { return }
            guard let object = result["response"] as? [String: Any] else { return }
            guard let name = object["name"] as? String else { return }
            guard let email = object["email"] as? String else { return }
            guard let id = object["id"] as? String else {return}
            
            print(email)
            
            //self.nameLabel.text = "\(name)"
            //self.emailLabel.text = "\(email)"
            //self.id.text = "\(id)"
              
              guard let signupFinishedViewController = self.storyboard?.instantiateViewController(withIdentifier: "signupFinishedViewController") else { return }

              self.navigationController?.pushViewController(signupFinishedViewController, animated: true)
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

                    self.navigationController?.popToRootViewController(animated: true)
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

                
                }
            }
        }
    
}
