//
//  Register.swift
//  GBShop
//
//  Created by Maxim Safronov on 08.12.2020.
//

import Foundation
import Alamofire

protocol RegisterRequestFactory {
    func register(user data: RegisterData, completion: @escaping (AFDataResponse<RegisterResult>) -> Void)
}

class Register: AbstractRequestFactory {
    let errorParser: AbstractErrorParser
    let sessionManager: Session
    let queue: DispatchQueue
    lazy var baseUrl = URL(string: "http://127.0.0.1:8080/test/")!
    
    init(
        errorParser: AbstractErrorParser,
        sessionManager: Session,
        queue: DispatchQueue = DispatchQueue.global(qos: .utility)) {
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension Register: RegisterRequestFactory {
    func register(user data: RegisterData, completion: @escaping (AFDataResponse<RegisterResult>) -> Void) {
        let requestModel = RegisterData(baseUrl: baseUrl,
                                    login: data.login,
                                    password: data.password,
                                    email: data.email,
                                    firstName: data.name,
                                    lastName: data.lastName)
        
        self.request(request: requestModel, completionHandler: completion)
    }
}

extension Register {
    struct RegisterData: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "register"
        
        let login: String
        let password: String
        let email: String
        let firstName: String
        let lastName: String?
        
        var parameters: Parameters? {
            return ["login": login,
                    "password": password,
                    "email": email,
                    "firstName": firstName,
                    "lastName": lastName ?? ""]
        }
    }
}
