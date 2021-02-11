//
//  BaseViewController.swift
//  GBShop
//
//  Created by Maxim Safronov on 16.12.2020.
//

import UIKit

// MARK: - NeedLoginDelegate implementation
protocol NeedLoginDelegate: class {
    func willReloadData()
    func willDisappear(bool: Bool)
}

// MARK: - LoginRegistrationDelegate implementation
protocol FillLoginScreenDelegate: class {
    func fillLoginScreenWith(email: String?, password: String?)
}

class BaseViewController: UIViewController {
    // MARK: - Properties
    var appService = AppService.shared
    var userId: Int? { return AppService.shared.session.userInfo?.id }
    var userEmail: String? { return AppService.shared.session.userInfo?.email }
    var productId: Int? { return AppService.shared.session.productInfo?.id }
    var isNeedLogin: Bool { return userId == nil }
    var emailLogin: String?
    var passwordLogin: String?
    
    weak var needLoginDelegate: NeedLoginDelegate?
    weak var fillLoginScreenDelegate: FillLoginScreenDelegate?
    
    // MARK: - Public methods
    public func login(delegate: NeedLoginDelegate?) {
        if userId == nil {
            if let needLogin = AppService.shared.getScreenPage(identifier: "loginScreen") as? BaseViewController {
                needLogin.needLoginDelegate = delegate
                needLogin.modalPresentationStyle = .overFullScreen
                present(needLogin, animated: true)
            }
        } else {
            showErrorMessage(message: "Вы уже авторизованы")
        }  
    }
}
