//
//  Reviews.swift
//  GBShop
//
//  Created by Maxim Safronov on 01.12.2020.
//

import Foundation
import Alamofire

class Reviews: AbstractRequestFactory {
    var errorParser: AbstractErrorParser
    var sessionManager: Session
    var queue: DispatchQueue
    lazy var baseUrl = URL(string: "http://127.0.0.1:8080/review/")!
    
    init(errorParser: AbstractErrorParser,
         sessionManager: Session,
         queue: DispatchQueue? = DispatchQueue.global(qos: .utility)) {
        
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue!
    }
}

extension Reviews: ReviewsRequestFactory {
    func getReviewsForProductBy(productId: Int, completion: @escaping (AFDataResponse<ReviewListResult>) -> Void) {
        let requestModel = ReviewData(baseUrl: baseUrl, productId: productId)
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func addReviewForProductBy(productId: Int, review: Review, completion: @escaping (AFDataResponse<AddReviewResult>) -> Void) {
        let requestModel = ReviewDataAdd(baseUrl: baseUrl,
                                         productId: productId,
                                         reviewId: review.id,
                                         userName: review.userFullName,
                                         userEmail: review.userEmail,
                                         title: review.title,
                                         description: review.description)
        
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func setReviewApporoveBy(reviewId: Int, completion: @escaping (AFDataResponse<ApproveReviewResult>) -> Void) {
        let requestModel = ReviewDataApprove(baseUrl: baseUrl, reviewId: reviewId)
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func removeReviewBy(reviewId: Int, completion: @escaping (AFDataResponse<RemoveReviewResult>) -> Void) {
        let requestModel = ReviewDataRemove(baseUrl: baseUrl, reviewId: reviewId)
        self.request(request: requestModel, completionHandler: completion)
    }
    
}

extension Reviews {
    struct ReviewData: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "list"
        
        let productId: Int
        var parameters: Parameters? {
            return [
                "id_product": productId
            ]
        }
    }
    
    struct ReviewDataAdd: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .post
        var path: String = "add"
        
        let productId: Int
        let reviewId: Int?
        let userName, userEmail, title, description: String
        
        var parameters: Parameters? {
            return [
                "id_review": reviewId ?? 0,
                "id_product": productId,
                "user_name": userName,
                "user_email": userEmail,
                "title": title,
                "description": description
            ]
        }
    }
    
    struct ReviewDataApprove: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "approve"
        
        let reviewId: Int
        
        var parameters: Parameters? {
            return [
                "id_review": reviewId
            ]
        }
    }
    
    struct ReviewDataRemove: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "remove"
        
        let reviewId: Int
        
        var parameters: Parameters? {
            return [
                "id_review": reviewId
            ]
        }
    }
}
