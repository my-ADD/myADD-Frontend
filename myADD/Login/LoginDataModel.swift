//
//  LoginDataModel.swift
//  myADD
//
//
//

import Foundation

struct SignUpData: Codable {
    let email: String
    let password: String
    let nickname: String
}

struct SignUpResponse: Codable {
    //let data: SignUpData?
    let isSuccess: Bool
    let code: Int
    let message: String
}

struct DuplicateData: Codable {
    let email: String
}

struct DuplicateResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}

struct LoginData: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    //let data: LoginData?
    let isSuccess: Bool
    let code: Int
    let message: String
}

struct LogoutResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}

struct UserDeleteResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}

struct SendCodeData: Codable {
    let email: String
}

struct SendCodeResponse<T>: Codable {
    //let data: SendCodeData?
    let isSuccess: Bool
    let code: Int
    let message: String
    typealias result = T
}

struct CheckCodeData: Codable {
    let email: String
    let code: Int
}

struct CheckCodeResponse<T>: Codable {
    //let data: CheckCodeData?
    let isSuccess: Bool
    let code: Int
    let message: String
    typealias result = T
}

struct ChangePasswordData: Codable {
    let email: String
    let password: String
}

struct ChangePasswordResponse: Codable {
    //let data: ChangePasswordData?
    let isSuccess: Bool
    let code: Int
    let message: String
}

struct GetInfoData: Codable {
    let email: String
    let nickname: String
    let profile: String
}

struct GetInfoResponse: Codable {
    //let data: GetInfoData?
    let isSuccess: Bool
    let code: Int
    let message: String
}
