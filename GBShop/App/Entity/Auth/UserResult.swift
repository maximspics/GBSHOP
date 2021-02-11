//
//  UserResult.swift
//  GBShop
//
//  Created by Maxim Safronov on 21.11.2020.
//

import Foundation

struct UserResult: Codable {
    var id: Int
    var email, firstName, lastName: String
    var fullName: String { firstName + " " + lastName }
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case email = "email"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

