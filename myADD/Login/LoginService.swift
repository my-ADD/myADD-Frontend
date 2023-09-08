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
                print(dataRequest)
                print(networkResult)
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

struct DuplicateService {
    static let shared = DuplicateService()
    
    func duplicate(email: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let url = APIConstants.duplicateURL
        let header: HTTPHeaders = [
            "Content-Type":"application/json"
        ]
        let body: Parameters = [
            "email": email
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
                print(dataRequest)
                print(networkResult)
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
        guard let decodedData = try? decoder.decode(DuplicateResponse.self, from: data)
        else { return .pathErr }
        
        return .success(decodedData as Any)
    }
}

struct LoginService {
    static let shared = LoginService()
    private var apiClient = APIClient()

    
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
                                     encoding: URLEncoding(destination: .queryString),
                                     headers: header)
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let value = response.value else { return }
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
                print(networkResult)
                
                if statusCode == 200 {
                    self.apiClient.getListAll(completion: { _ in })
                }
                
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

struct LogoutService {
    static let shared = LogoutService()
    
    func logout(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let url = APIConstants.logoutURL
        let header: HTTPHeaders = [
            "Content-Type":"application/json"
        ]
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: nil,
                                     encoding: URLEncoding.default,
                                     headers: header)
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let value = response.value else { return }
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
                print(dataRequest)
                print(networkResult)
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
        guard let decodedData = try? decoder.decode(LogoutResponse.self, from: data)
        else { return .pathErr }
        
        return .success(decodedData as Any)
    }
}

struct UserDeleteService {
    static let shared = UserDeleteService()
    
    func userDelete(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let url = APIConstants.userDeleteURL
        let header: HTTPHeaders = [
            "Content-Type":"application/json"
        ]
        let dataRequest = AF.request(url,
                                     method: .delete,
                                     parameters: nil,
                                     encoding: URLEncoding.default,
                                     headers: header)
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let value = response.value else { return }
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
                print(networkResult)
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
        guard let decodedData = try? decoder.decode(UserDeleteResponse.self, from: data)
        else { return .pathErr }
        
        return .success(decodedData as Any)
    }
}

struct SendCodeService {
    static let shared = SendCodeService()
    
    func sendCode(email: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let url = APIConstants.sendCodeURL
        let header: HTTPHeaders = [
            "Content-Type":"application/json"
        ]
        let body: Parameters = [
            "email": email
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
                print(networkResult)
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
        guard let decodedData = try? decoder.decode(SendCodeResponse<Any>.self, from: data)
        else { return .pathErr }
        
        return .success(decodedData as Any)
    }
}

struct CheckCodeService {
    static let shared = CheckCodeService()
    
    func checkCode(email: String, code: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let url = APIConstants.checkCodeURL
        let header: HTTPHeaders = [
            "Content-Type":"application/json"
        ]
        let body: Parameters = [
            "email": email,
            "code": code
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
                print(networkResult)
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
        guard let decodedData = try? decoder.decode(CheckCodeResponse<Any>.self, from: data)
        else { return .pathErr }
        
        return .success(decodedData as Any)
    }
}

struct ChangePasswordService {
    static let shared = ChangePasswordService()
    
    func changePassword(email: String, password: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let url = APIConstants.changePasswordURL
        let header: HTTPHeaders = [
            "Content-Type":"application/json"
        ]
        let body: Parameters = [
            "email": email,
            "password": password
        ]
        let dataRequest = AF.request(url,
                                     method: .put,
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
                print(networkResult)
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
        guard let decodedData = try? decoder.decode(ChangePasswordResponse.self, from: data)
        else { return .pathErr }
        
        return .success(decodedData as Any)
    }
}

struct GetInfoService {
    static let shared = GetInfoService()
    
    func getInfo(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let url = APIConstants.getInfoURL
        let header: HTTPHeaders = [
            "Content-Type":"application/json"
        ]
        let dataRequest = AF.request(url,
                                     method: .get,
                                     parameters: nil,
                                     encoding: URLEncoding.default, //JSONEncoding.default,
                                     headers: header)
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let value = response.value else { return }
                
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
                print(networkResult)
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
        guard let decodedData = try? decoder.decode(GetInfoResponse.self, from: data)
        else { return .pathErr }
        
        return .success(decodedData as Any)
    }
}
