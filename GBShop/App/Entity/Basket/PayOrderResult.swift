//
//  PayOrderResult.swift
//  GBShop
//
//  Created by Maxim Safronov on 08.12.2020.
//

import Foundation

struct PayOrderResult: Codable {
    let result: Int
    let userMessage: String?
}
