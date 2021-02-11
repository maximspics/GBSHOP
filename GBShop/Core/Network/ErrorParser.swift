//
//  ErrorParser.swift
//  GBShop
//
//  Created by Maxim Safronov on 21.11.2020.
//

import Foundation

class ErrorParser: AbstractErrorParser {
    func parse(_ result: Error) -> Error {
        return result
    }

    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        return error
    }
}
