//
//  GetUserDataResult.swift
//  GBShop
//
//  Created by Maxim Safronov on 15.12.2020.
//

import Foundation

struct GetUserDataResult: Codable {
    var result: Int
    var id: Int
    var email, password, firstName, lastName: String
    
    enum CodingKeys: String, CodingKey {
        case result = "result"
        case id = "user_id"
        case email = "email"
        case password = "password"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
