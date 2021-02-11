//
//  AbstractErrorParser.swift
//  GBShop
//
//  Created by Maxim Safronov on 21.11.2020.
//

import Foundation

protocol AbstractErrorParser {
    func parse(_ result: Error) -> Error
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error?
}
