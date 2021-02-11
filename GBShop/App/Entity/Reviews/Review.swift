//
//  Review.swift
//  GBShop
//
//  Created by Maxim Safronov on 01.12.2020.
//

import Foundation

struct Review: Codable {
     let id: Int?
     let productId: Int?
     let userFullName, userEmail, title, description: String

     enum CodingKeys: String, CodingKey {
         case id = "id_review"
         case productId = "id_product"
         case userFullName = "user_name"
         case userEmail = "user_email"
         case title = "title"
         case description = "description"
     }
 }
