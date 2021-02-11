//
//  User.swift
//  GBShop
//
//  Created by Maxim Safronov on 15.12.2020.
//

import Foundation

struct User {
    let id: Int?
    let email: String
    let password, newPassword: String?
    let firstName: String
    let lastName: String?
    var fullName: String { firstName + " " + lastName!}
}
