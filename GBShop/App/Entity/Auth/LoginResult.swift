//
//  LoginResult.swift
//  GBShop
//
//  Created by Maxim Safronov on 21.11.2020.
//

import Foundation

struct LoginResult: Codable {
    let result: Int
    let user: UserResult?
    let authToken: String
}
