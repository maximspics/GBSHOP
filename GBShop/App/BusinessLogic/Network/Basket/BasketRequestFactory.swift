//
//  BasketRequestFactory.swift
//  GBShop
//
//  Created by Maxim Safronov on 08.12.2020.
//

import Foundation
import Alamofire

protocol BasketRequestFactory: AbstractRequestFactory {
    func getBasketBy(userId: Int, completion: @escaping (AFDataResponse<GetBasketResult>) -> Void)
    
    func addProductToBasketBy(productId: Int, userId: Int,
                              quantity: Int, completion: @escaping (AFDataResponse<AddToBasketResult>) -> Void)
    
    func removeProductFromBasketBy(productId: Int, userId: Int, completion: @escaping (AFDataResponse<RemoveFromBasketResult>) -> Void)
    
    func clearBasketFrom(userId: Int, completion: @escaping (AFDataResponse<ClearBasketResult>) -> Void)
    
    func payOrderBy(userId: Int, paySumm: Int, completion: @escaping (AFDataResponse<PayOrderResult>) -> Void)
}
