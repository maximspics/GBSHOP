//
//  Basket.swift
//  GBShop
//
//  Created by Maxim Safronov on 08.12.2020.
//

import Foundation
import Alamofire

class Basket: AbstractRequestFactory {
    var errorParser: AbstractErrorParser
    var sessionManager: Session
    var queue: DispatchQueue
    lazy var baseUrl = URL(string: "http://127.0.0.1:8080/basket/")!
    
    init(errorParser: AbstractErrorParser,
         sessionManager: Session,
         queue: DispatchQueue? = DispatchQueue.global(qos: .utility)) {
        
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue!
    }
}

extension Basket: BasketRequestFactory {
    func getBasketBy(userId: Int, completion: @escaping (AFDataResponse<GetBasketResult>) -> Void) {
        let requestModel = GetBasket(baseUrl: baseUrl, userId: userId)
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func addProductToBasketBy(productId: Int, userId: Int, quantity: Int, completion: @escaping (AFDataResponse<AddToBasketResult>) -> Void) {
        let requestModel = AddToBasket(baseUrl: baseUrl, userId: userId,
                                           productId: productId, quantity: quantity)
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func removeProductFromBasketBy(productId: Int, userId: Int, completion: @escaping (AFDataResponse<RemoveFromBasketResult>) -> Void) {
        let requestModel = RemoveFromBasket(baseUrl: baseUrl, userId: userId, productId: productId)
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func clearBasketFrom(userId: Int, completion: @escaping (AFDataResponse<ClearBasketResult>) -> Void) {
        let requestModel = ClearBasket(baseUrl: baseUrl, userId: userId)
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func payOrderBy(userId: Int, paySumm: Int, completion: @escaping (AFDataResponse<PayOrderResult>) -> Void) {
        let requestModel = PayBasket(baseUrl: baseUrl, userId: userId, paySumm: paySumm)
        self.request(request: requestModel, completionHandler: completion)
    }
}

extension Basket {
    struct GetBasket: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "get"
        
        let userId: Int
        var parameters: Parameters? {
            return [
                "userId": userId
            ]
        }
    }
    
    struct AddToBasket: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "add"
        
        let userId: Int
        let productId: Int
        let quantity: Int
        
        var parameters: Parameters? {
            return [
                "userId": userId,
                "productId": productId,
                "quantity": quantity
            ]
        }
    }
    
    struct RemoveFromBasket: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "remove"
        
        let userId: Int
        let productId: Int
        
        var parameters: Parameters? {
            return [
                "userId": userId,
                "productId": productId
            ]
        }
    }
    
    struct ClearBasket: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "clear"
        
        let userId: Int
        var parameters: Parameters? {
            return [
                "userId": userId
            ]
        }
    }
    
    struct PayBasket: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "pay"
        
        let userId: Int
        let paySumm: Int
        
        var parameters: Parameters? {
            return [
                "userId": userId,
                "paySumm": paySumm
            ]
        }
        
    }
}
