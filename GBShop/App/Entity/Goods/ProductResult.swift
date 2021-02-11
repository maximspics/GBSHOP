//
//  ProductResult.swift
//  GBShop
//
//  Created by Maxim Safronov on 25.11.2020.
//

import Foundation

struct ProductResult: Codable {
    let result, id, price: Int
    let name, image, description: String
    
    enum CodingKeys: String, CodingKey {
        case id = "product_id"
        case name = "product_name"
        case image = "product_image"
        case description = "product_description"
        case price = "product_price"
        case result = "result"
    }
}
