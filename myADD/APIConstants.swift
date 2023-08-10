//
//  APIConstants.swift
//  myADD
//
//
//

import Foundation

struct APIConstants {
    static let baseURL = "http://3.34.68.145"
    static let signUpURL = baseURL + "/users/join"
    static let loginURL = baseURL + "/users/login/email"
    static let logoutURL = baseURL + "/users/my-info/logout"
    static let userDeleteURL = baseURL + "/users/my-info/delete/user"
}
