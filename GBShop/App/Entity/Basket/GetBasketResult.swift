//
//  GetBasketResult.swift
//  GBShop
//
//  Created by Maxim Safronov on 08.12.2020.
//

import Foundation

struct GetBasketResult: Codable {
    let amount, itemsCount: Int
    let basketItems: [BasketItems]
    
    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case itemsCount = "items_count"
        case basketItems = "items"
    }
}

struct BasketItems: Codable {
    let productId, productPrice, quantity: Int
    let productName: String
    
    enum CodingKeys: String, CodingKey {
        case productId = "id_product"
        case productName = "product_name"
        case productPrice = "price"
        case quantity = "quantity"
    }
}
