//
//  ViewController.swift
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

class ViewController: UIViewController, NaverThirdPartyLoginConnectionDelegate {
    
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        naverLoginInstance?.delegate = self
    }

    // 네이버 아이디 로그인
    @objc func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
            print("Success login")
            getInfo()
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
        
    func getInfo() {
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
                    }
                
                }
            }
    }
    

}

