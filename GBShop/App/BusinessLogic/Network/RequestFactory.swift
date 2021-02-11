//
//  RequestFactory.swift
//  GBShop
//
//  Created by Maxim Safronov on 21.11.2020.
//

import Foundation
import Alamofire
import Swinject

class RequestFactory {
    
    func makeErrorParser() -> AbstractErrorParser {
        return ErrorParser()
    }
    
    lazy var commonSession: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let manager = Session(configuration: configuration)
        return manager
    }()
    
    let sessionQueue = DispatchQueue.global(qos: .utility)
    
    func makeAuthRequestFactory() -> AuthRequestFactory {
        let container = Container()
        
        container.register(AbstractErrorParser.self) { _ in ErrorParser() }
        container.register(Auth.self) { resolver in
            Auth(errorParser: resolver.resolve(AbstractErrorParser.self)!, sessionManager: self.commonSession)
        }
        
        return container.resolve(Auth.self)!
    }
    
    func makeGoodsRequestFactory() -> GoodsRequestFactory {
        let container = Container()
        
        container.register(AbstractErrorParser.self) { _ in ErrorParser() }
        container.register(Goods.self) { resolver in
            Goods(errorParser: resolver.resolve(AbstractErrorParser.self)!, sessionManager: self.commonSession)
        }
        
        return container.resolve(Goods.self)!
    }
    
    func makeReviewsRequestFactory() -> ReviewsRequestFactory {
        let container = Container()
        
        container.register(AbstractErrorParser.self) { _ in ErrorParser() }
        container.register(Reviews.self) { resolver in
            Reviews(errorParser: resolver.resolve(AbstractErrorParser.self)!, sessionManager: self.commonSession)
        }
        
        return container.resolve(Reviews.self)!
    }
    
    func makeBasketRequestFactory() -> Basket {
        let container = Container()
        
        container.register(AbstractErrorParser.self) { _ in ErrorParser() }
        container.register(Basket.self) { resolver in
            Basket(errorParser: resolver.resolve(AbstractErrorParser.self)!, sessionManager: self.commonSession)
        }
        
        return container.resolve(Basket.self)!
    }
}
