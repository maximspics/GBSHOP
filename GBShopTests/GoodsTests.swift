//
//  GoodsTests.swift
//  GBShopTests
//
//  Created by Maxim Safronov on 25.11.2020.
//

import XCTest
import Alamofire
@testable import GBShop

enum GoodsApiErrorStub: Error {
    case fatalError
}

struct GoodsErrorParserStub: AbstractErrorParser {
    func parse(_ result: Error) -> Error {
        return GoodsApiErrorStub.fatalError
    }
    
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        return error
    }
}

class GoodsTests: XCTestCase {
    let exectation = XCTestExpectation(description: "GoodsTests")
    let sessionManager = Session(configuration: URLSessionConfiguration.default)
    
    var catalog: Goods!
    var errorParser: GoodsErrorParserStub!
    
    var timeout: TimeInterval = 10.0
    
    override func setUp() {
        errorParser = GoodsErrorParserStub()
        catalog = Goods(errorParser: errorParser, sessionManager: sessionManager)
    }
    
    override func tearDown() {
        errorParser = nil
        catalog = nil
    }
    
    func testCatalogData() {
        catalog.getCatalog() { [weak self] (response: AFDataResponse<CatalogResult>) in
            
            switch response.result {
            case .success(let productResult):
                if productResult.isEmpty {
                    XCTFail("No catalog return")
                }
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            self?.exectation.fulfill()
        }
        
        wait(for: [exectation], timeout: timeout)
    }
    
    func testGoodById() {
        catalog.getProductBy(productId: 1) { [weak self] (response: AFDataResponse<ProductResult>) in
            switch response.result {
            case .success(let goodResult):
                if goodResult.description.isEmpty {
                    XCTFail("Good not found")
                }
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            self?.exectation.fulfill()
        }
        
        wait(for: [exectation], timeout: timeout)
    }
}
