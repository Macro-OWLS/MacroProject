//
//  NetworkError.swift
//  MacroProject
//
//  Created by Agfi on 01/10/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case invalidParameters
    case errorResponse(error: ResponseError)
    case genericError(error: Error)

    var errorMessage: String {
        switch self {
        case .errorResponse(let error):
            return error.message ?? "We couldn't connect to our data. Please retry again and make sure internet connection is good."
        default:
            return "We couldn't connect to our data. Please retry again and make sure internet connection is good."
        }
    }
}
