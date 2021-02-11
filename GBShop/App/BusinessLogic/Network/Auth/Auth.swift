//
//  Auth.swift
//  GBShop
//
//  Created by Maxim Safronov on 21.11.2020.
//

import Foundation
import Alamofire

class Auth: AbstractRequestFactory {
    let errorParser: AbstractErrorParser
    let sessionManager: Session
    let queue: DispatchQueue
    lazy var baseUrl = URL(string: "http://127.0.0.1:8080/auth/")!
    
    init(
        errorParser: AbstractErrorParser,
        sessionManager: Session,
        queue: DispatchQueue = DispatchQueue.global(qos: .utility)) {
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension Auth: AuthRequestFactory {
    func loginWith(email: String, password: String, completionHandler: @escaping (AFDataResponse<LoginResult>) -> Void) {
        let requestModel = Login(baseUrl: baseUrl,
                                 email: email,
                                 password: password)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func getUserBy(userId: Int, completion: @escaping (AFDataResponse<GetUserDataResult>) -> Void) {
        let requestModel = GetUser(baseUrl: baseUrl, userId: userId)
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func logout(userId: Int, completion: @escaping (AFDataResponse<LogoutResult>) -> Void) {
        let requestModel = Logout(baseUrl: baseUrl, userId: userId)
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func changeUserDataTo(user data: User, completion: @escaping (AFDataResponse<ChangeUserDataResult>) -> Void) {
        guard let userId = data.id else { return }
        let requestModel = UserData(baseUrl: baseUrl,
                                    userId: userId,
                                    email: data.email,
                                    password: data.password ?? "",
                                    newPassword: data.newPassword ?? "",
                                    firstName: data.firstName,
                                    lastName: data.lastName)
        
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func register(user data: User, completion: @escaping (AFDataResponse<RegisterResult>) -> Void) {
        let requestModel = Register(baseUrl: baseUrl,
                                    email: data.email,
                                    password: data.password ?? "",
                                    firstName: data.firstName,
                                    lastName: data.lastName ?? "")
        
        self.request(request: requestModel, completionHandler: completion)
    }
}

extension Auth {
    struct Login: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "login"
        
        let email: String
        let password: String
        var parameters: Parameters? {
            return [
                "email": email,
                "password": password
            ]
        }
    }
    
    struct GetUser: RequestRouter {
        var path: String = "get"
        let baseUrl: URL
        let method: HTTPMethod = .post
        
        let userId: Int
        var parameters: Parameters? {
            return [
                "userId": userId
            ]
        }
    }
    
    struct Logout: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        var path: String = "logout"
        
        let userId: Int
        var parameters: Parameters? {
            return [
                "userId": userId
            ]
        }
    }
    
    struct UserData: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "change"
        
        let userId: Int
        let email: String
        let password: String
        let newPassword: String
        let firstName: String
        let lastName: String?
        
        var parameters: Parameters? {
            return [
                "userId": userId,
                "email": email,
                "password": password,
                "newPassword": newPassword,
                "firstName": firstName,
                "lastName": lastName ?? ""
            ]
        }
    }
    
    struct Register: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "register"
        
        let email: String
        let password: String
        let firstName: String
        let lastName: String?
        
        var parameters: Parameters? {
            return [
                "email": email,
                "password": password,
                "firstName": firstName,
                "lastName": lastName ?? ""
            ]
        }
    }
}
