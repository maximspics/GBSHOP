//
//  ReviewsTests.swift
//  GBShopTests
//
//  Created by Maxim Safronov on 01.12.2020.
//

import XCTest
import Alamofire
@testable import GBShop

enum ReviewsApiErrorStub: Error {
    case fatalError
}

struct ReviewsErrorParserStub: AbstractErrorParser {
    func parse(_ result: Error) -> Error {
        return ReviewsApiErrorStub.fatalError
    }
    
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        return error
    }
}

class ReviewsTests: XCTestCase {
    let exectation = XCTestExpectation(description: "ReviewsTests")
    var errorParser: ReviewsErrorParserStub!
    let sessionManager = Session(configuration: URLSessionConfiguration.default)
    var reviewObject: Reviews!
    var timeout: TimeInterval = 10.0
    
    override func setUp() {
        errorParser = ReviewsErrorParserStub()
        reviewObject = Reviews.init(errorParser: errorParser, sessionManager: sessionManager)
    }
    
    override func tearDown() {
        errorParser = nil
        reviewObject = nil
    }
    
    func testGetReviewList() {
        reviewObject.getReviewsForProductBy(productId: 1) { [weak self] (response: AFDataResponse<ReviewListResult>) in
            switch response.result {
            case .success(let reviews):
                if reviews.isEmpty {
                    XCTFail("Reviews is empty")
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self?.exectation.fulfill()
        }
        
        wait(for: [exectation], timeout: timeout)
    }
    
    func testAddReview() {
        let id = 1
        let addReviewModel = Review(id: nil, productId: id,
                                    userFullName: "Somebody", userEmail: "test@test.ru",
                                    title: "Some title", description: "Some review")
        
        reviewObject.addReviewForProductBy(productId: id, review: addReviewModel) { [weak self] (response: AFDataResponse<AddReviewResult>) in
            switch response.result {
            case .success(let addResult):
                if addResult.result != 1 {
                    XCTFail("Something went wrong")
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self?.exectation.fulfill()
        }
        
        wait(for: [exectation], timeout: timeout)
    }
    
    func testApproveReview() {
        reviewObject.setReviewApporoveBy(reviewId: 2) { [weak self] (response: AFDataResponse<ApproveReviewResult>) in
            switch response.result {
            case .success(let approveResult):
                if approveResult.result != 1 {
                    XCTFail("Something went wrong")
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            self?.exectation.fulfill()
        }
        
        wait(for: [exectation], timeout: timeout)
    }
    
    func testRemoveReview() {
        reviewObject.removeReviewBy(reviewId: 2) { [weak self] (respone: AFDataResponse<RemoveReviewResult>) in
            switch respone.result {
            case .success(let removeResult):
                if removeResult.result != 1 {
                    XCTFail("Something went wrong")
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            self?.exectation.fulfill()
        }
        
        wait(for: [exectation], timeout: timeout)
    }
}
