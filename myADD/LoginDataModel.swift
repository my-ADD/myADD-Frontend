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
    let data: SignUpData?
    let message: String
    let result: String
}

struct LoginData: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let data: LoginData?
    let message: String
    let result: String
}
