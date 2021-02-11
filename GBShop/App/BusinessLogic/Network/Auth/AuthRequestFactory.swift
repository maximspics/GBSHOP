//
//  AuthRequestFactory.swift
//  GBShop
//
//  Created by Maxim Safronov on 21.11.2020.
//

import Foundation
import Alamofire

protocol AuthRequestFactory: AbstractRequestFactory {
    func loginWith(email: String, password: String, completionHandler: @escaping (AFDataResponse<LoginResult>) -> Void)
    
    func getUserBy(userId: Int, completion: @escaping (AFDataResponse<GetUserDataResult>) -> Void)
    
    func logout(userId: Int, completion: @escaping (AFDataResponse<LogoutResult>) -> Void)
    
    func changeUserDataTo(user data: User, completion: @escaping (AFDataResponse<ChangeUserDataResult>) -> Void)
    
    func register(user data: User, completion: @escaping (AFDataResponse<RegisterResult>) -> Void)
}
