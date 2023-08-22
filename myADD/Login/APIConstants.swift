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
    static let duplicateURL = baseURL + "/users/join/email/check-duplicate"
    static let loginURL = baseURL + "/users/login/email"
    static let logoutURL = baseURL + "/users/my-info/logout"
    static let userDeleteURL = baseURL + "/users/my-info/delete/user"
    static let sendCodeURL = baseURL + "/change-password/send-code"
    static let checkCodeURL = baseURL + "/change-password/check-code"
    static let changePasswordURL = baseURL + "/change-password"
    static let getInfoURL = baseURL + "/users/my-info/get/my-profile"
    static let changeProfileURL = baseURL + "/users/my-info/change/my-profile"
}
