//
//  BasketTests.swift
//  GBShopTests
//
//  Created by Maxim Safronov on 08.12.2020.
//

import XCTest
import Alamofire
@testable import GBShop

enum BasketApiErrorStub: Error {
    case fatalError
}

struct BasketErrorParserStub: AbstractErrorParser {
    func parse(_ result: Error) -> Error {
        return BasketApiErrorStub.fatalError
    }
    
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        return error
    }
}

class BasketTests: XCTestCase {
    let expecation = XCTestExpectation(description: "BasketTests")
    var errorParser: BasketErrorParserStub!
    let sessionManager = Session(configuration: URLSessionConfiguration.default)
    var basketObject: Basket!
    var timeout: TimeInterval = 10.0
    
    override func setUp() {
        errorParser = BasketErrorParserStub()
        basketObject = Basket.init(errorParser: errorParser, sessionManager: sessionManager)
    }
    
    override func tearDown() {
        errorParser = nil
        basketObject = nil
    }
    
    func testGetBasket() {
        // Можно указать любой id из базы данных
        basketObject.getBasketBy(userId: 1) { [weak self] (response: AFDataResponse<GetBasketResult>) in
            switch response.result {
            case .success(_):
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self?.expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: timeout)
    }
    
    func testAddToBasket() {
        basketObject.addProductToBasketBy(productId: 1, userId: 1, quantity: 1) { [weak self] (response: AFDataResponse<AddToBasketResult>) in
            switch response.result {
            case .success(let addToBasket):
                if addToBasket.result != 1 {
                    XCTFail("Fail add to basket")
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self?.expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: timeout)
    }
    
    func testRemoveFromBasket() {
        // Удаляемый товар должен быть в корзине
        basketObject.removeProductFromBasketBy(productId: 1, userId: 1) { [weak self] (response: AFDataResponse<RemoveFromBasketResult>) in
            switch response.result {
            case .success(let removeFromBasket):
                if removeFromBasket.result != 1 {
                    XCTFail("Fail to remove from basket")
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self?.expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: timeout)
    }
    
    func testPayOrder() {
        // paySumm должен совпадать с суммарной стоимостью товаров в корзине
        basketObject.payOrderBy(userId: 1, paySumm: 54990) { [weak self] (response: AFDataResponse<PayOrderResult>) in
            switch response.result {
            case .success(let payOrderResult):
                if payOrderResult.result != 1 {
                    XCTFail("Fail to pay")
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            self?.expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: timeout)
    }
    
}
