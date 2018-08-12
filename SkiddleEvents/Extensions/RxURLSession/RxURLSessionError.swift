//
//  RxURLSessionError.swift
//  SkiddleEvents
//
//  Created by Fuad Adetoro on 11/08/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import Foundation

public enum RxURLSessionError: Error {
    case unknown
    case invalidResponse(response: URLResponse)
    case requestFailed(response: HTTPURLResponse, data: Data?)
    case deserializationFailed
    case invalidKey
    case eventsNotFound
}

extension RxURLSessionError {
    public var errorDescription: String {
        if (self as NSError).code == -1009 {
            return "No internet connection."
        }
        
        switch self {
        case .invalidKey:
            return "API Key is invalid."
        case .eventsNotFound:
            return "No events have been fetched."
        case .requestFailed(_,_):
            return "The network request failed."
        default:
            return "An error occurred."
        }
    }
}
