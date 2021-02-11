//
//  Goods.swift
//  GBShop
//
//  Created by Maxim Safronov on 25.11.2020.
//

import Foundation
import Alamofire

class Goods: AbstractRequestFactory {
    var errorParser: AbstractErrorParser
    var sessionManager: Session
    var queue: DispatchQueue
    lazy var baseUrl = URL(string: "http://127.0.0.1:8080/good/")!
    
    init(errorParser: AbstractErrorParser,
         sessionManager: Session,
         queue: DispatchQueue? = DispatchQueue.global(qos: .utility))
    {
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue!
    }
}

extension Goods: GoodsRequestFactory {
    func getCatalog(completion: @escaping (AFDataResponse<CatalogResult>) -> Void) {
        let requestModel = CatalogData(baseUrl: baseUrl)
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func getProductBy(productId: Int, competion: @escaping (AFDataResponse<ProductResult>) -> Void) {
        let requestModel = GoodById(baseUrl: baseUrl, productId: productId)
        self.request(request: requestModel, completionHandler: competion)
    }
}

extension Goods {
    struct CatalogData: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .post
        var path: String = "list"
        var parameters: Parameters?
    }
    
    struct GoodById: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .post
        var path: String = "product"
        
        let productId: Int
        var parameters: Parameters? {
            return [
                "id": productId
            ]
        }
    }
}

