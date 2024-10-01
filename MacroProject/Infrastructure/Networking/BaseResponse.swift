//
//  BaseResponse.swift
//  MacroProject
//
//  Created by Agfi on 01/10/24.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    public let payload: T?
    public let errors: ResponseError?
    public let timeStamp: String?
    public let success: Bool?
}

struct ResponseError: Codable {
    public let code: String?
    public let message: String?
}

extension Error {
    func toResponseError() -> NetworkError {
        if let responseError = self as? NetworkError {
            return responseError
        } else {
            return .genericError(error: self)
        }
    }
}
