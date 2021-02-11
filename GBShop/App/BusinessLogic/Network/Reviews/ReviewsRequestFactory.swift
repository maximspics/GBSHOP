//
//  ReviewsRequestFactory.swift
//  GBShop
//
//  Created by Maxim Safronov on 01.12.2020.
//

import Foundation
import Alamofire

protocol ReviewsRequestFactory: AbstractRequestFactory {
    func getReviewsForProductBy(productId: Int, completion: @escaping (AFDataResponse<ReviewListResult>) -> Void)
    
    func addReviewForProductBy(productId: Int, review: Review, completion: @escaping (AFDataResponse<AddReviewResult>) -> Void)
    
    func setReviewApporoveBy(reviewId: Int, completion: @escaping (AFDataResponse<ApproveReviewResult>) -> Void)
    
    func removeReviewBy(reviewId: Int, completion: @escaping (AFDataResponse<RemoveReviewResult>) -> Void)
}
