//
//  GoodsRequestFactory.swift
//  GBShop
//
//  Created by Maxim Safronov on 25.11.2020.
//

import Foundation
import Alamofire

protocol GoodsRequestFactory: AbstractRequestFactory {
    func getCatalog(completion: @escaping (AFDataResponse<CatalogResult>) -> Void)
    func getProductBy(productId: Int, competion: @escaping (AFDataResponse<ProductResult>) -> Void)
}
