//
//  ResponseCodableTests.swift
//  GBShopTests
//
//  Created by Maxim Safronov on 24.11.2020.
//

import XCTest
import Alamofire
@testable import GBShop

struct PostStub: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

enum ApiErrorStub: Error {
    case fatalError
}

struct ErrorParseStub: AbstractErrorParser {
    func parse(_ result: Error) -> Error {
        return ApiErrorStub.fatalError
    }
    
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        return error
    }
}

class ResponseCodableTests: XCTestCase {
    let exceptation = XCTestExpectation(description: "Download https://failurl")
    var errorParser: ErrorParseStub!
    
    override func setUp() {
        super.setUp()
        errorParser = ErrorParseStub()
    }
    
    override func tearDown() {
        super.tearDown()
        errorParser = nil
    }
    
    func testShouldDownloadAndParse() {
        let errorParse = ErrorParseStub()
        
        AF
            .request("https://jsonplaceholder.typicode.com/posts/1")
            .responseCodable(errorParser: errorParse) { [weak self] (response: AFDataResponse<PostStub>) in
                switch response.result {
                case .success(_): break
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                self?.exceptation.fulfill()
            }
        
        wait(for: [exceptation], timeout: 10.0)
    }
    
}
