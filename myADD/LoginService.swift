//
//  LoginService.swift
//  myADD
//
//
//

import Foundation
import Alamofire

struct SignUpService {
    static let shared = SignUpService()
    
    func signUp(email: String, password: String, nickname: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let url = APIConstants.signUpURL
        let header: HTTPHeaders = [
                    "Content-Type":"application/json"
                ]
        let body: Parameters = [
                    "email": email,
                    "password": password,
                    "nickname": nickname
                ]
        let dataRequest = AF.request(url,
                                    method: .post,
                                    parameters: body,
                                    encoding: JSONEncoding.default,
                                    headers: header)
        dataRequest.responseData { response in
            switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else { return }
                    guard let value = response.value else { return }
                            
                    let networkResult = self.judgeStatus(by: statusCode, value)
                    completion(networkResult)
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
            }
        }
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
            switch statusCode {
            case 200 : return isVaildData(data: data)
            case 400 : return .pathErr
            case 500 : return .serverErr
            default : return .networkFail
        }
    }
    
    private func isVaildData(data: Data) -> NetworkResult<Any> {
            let decoder = JSONDecoder()
            guard let decodedData = try? decoder.decode(SignUpResponse.self, from: data)
            else { return .pathErr }
            
            return .success(decodedData as Any)
    }
}

struct LoginService {
    static let shared = LoginService()
    
    func login(email: String, password: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let url = APIConstants.loginURL
        let header: HTTPHeaders = [
                    "Content-Type":"application/json"
                ]
        let body: Parameters = [
                    "email": email,
                    "password": password
                ]
        let dataRequest = AF.request(url,
                                    method: .post,
                                    parameters: body,
                                    encoding: JSONEncoding.default,
                                    headers: header)
        dataRequest.responseData { response in
            switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else { return }
                    guard let value = response.value else { return }
                            
                    let networkResult = self.judgeStatus(by: statusCode, value)
                    completion(networkResult)
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
            }
        }
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
            switch statusCode {
            case 200 : return isVaildData(data: data)
            case 400 : return .pathErr
            case 500 : return .serverErr
            default : return .networkFail
        }
    }
    
    private func isVaildData(data: Data) -> NetworkResult<Any> {
            let decoder = JSONDecoder()
            guard let decodedData = try? decoder.decode(LoginResponse.self, from: data)
            else { return .pathErr }
            
            return .success(decodedData as Any)
    }
}
