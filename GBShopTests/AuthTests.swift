//
//  AuthTests.swift
//  GBShopTests
//
//  Created by Maxim Safronov on 25.11.2020.
//

import XCTest
import Alamofire
@testable import GBShop

enum AuthApiErrorStub: Error {
    case fatalError
}

struct ErrorParserStub: AbstractErrorParser {
    func parse(_ result: Error) -> Error {
        return AuthApiErrorStub.fatalError
    }
    
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        return error
    }
}

class AuthTests: XCTestCase {
    let exectation = XCTestExpectation(description: "AuthTests")
    var errorParser: ErrorParseStub!
    let sessionManager = Session(configuration: URLSessionConfiguration.default)
    var auth: Auth!
    var timeout: TimeInterval = 10.0
    
    override func setUp() {
        errorParser = ErrorParseStub()
        auth = Auth.init(errorParser: errorParser, sessionManager: sessionManager)
    }
    
    override func tearDown() {
        auth = nil
        errorParser = nil
    }
    
    func testRegister() {
        // Email должен быть уникальным для каждой проверки
        let userToRegister = User(id: nil,
                                  email: "some1@some.ru",
                                  password: "123",
                                  newPassword: nil,
                                  firstName: "Maxim",
                                  lastName: "Ivanov")
        auth.register(user: userToRegister) { [weak self] (response: AFDataResponse<RegisterResult>) in
            switch response.result {
            case .success(let registerResult):
                if registerResult.result != 1 {
                    XCTFail("Unknown registerResult")
                }
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            self?.exectation.fulfill()
        }
        
        wait(for: [exectation], timeout: timeout)
    }
    
    func testLogin() {
        // Необходимо указывать имеющийся email и password в базе данных
        auth.loginWith(email: "some1@some.ru", password: "123") { [weak self] (response: AFDataResponse<LoginResult>) in
            switch response.result {
            case .success(let loginResult):
                if loginResult.authToken.isEmpty {
                    XCTFail("Autho token is empty")
                }
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            self?.exectation.fulfill()
        }
        wait(for: [exectation], timeout: timeout)
    }
    
    func testChangeUserData() {
        // Необходимо указывать верный id из базы данных
        let userToChange = User(id: 3,
                                email: "some1@some.ru",
                                password: "123",
                                newPassword: "12345",
                                firstName: "Ivan",
                                lastName: "Ivanov")
        
        auth.changeUserDataTo(user: userToChange) { [weak self] (response: AFDataResponse<ChangeUserDataResult>) in
            switch response.result {
            case .success(let changeDataResult):
                if changeDataResult.result != 1 {
                    XCTFail("Unknown ChangeDataResult")
                }
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            self?.exectation.fulfill()
        }
        
        wait(for: [exectation], timeout: timeout)
    }
    
    func testLogout() {
        // Можно указать любой id из базы данных
        auth.logout(userId: 1) { [weak self] (response: AFDataResponse<LogoutResult>) in
            switch response.result {
            case .success(let logoutResult):
                if logoutResult.result != 1 {
                    XCTFail("Unknown LogoutResult")
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
