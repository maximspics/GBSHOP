//
//  AppSession.swift
//  GBShop
//
//  Created by Maxim Safronov on 29.12.2020.
//

import Foundation

class AppSession {
    // MARK: - Properties
    static var shared = AppSession()
    private(set) var userInfo: UserResult?
    private(set) var productInfo: ProductResult?
    var currentUserId: Int? { return userInfo?.id }
    var currentProductId: Int? { return productInfo?.id }
    
    // MARK: - Methods
    func setUserInfo(_ info: UserResult) {
        self.userInfo = info
    }
    
    func setProductInfo(_ info: ProductResult) {
        self.productInfo = info
    }
    
    func killUserInfo() {
        self.userInfo = nil
    }
}
