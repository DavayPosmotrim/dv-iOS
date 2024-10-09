//
//  ServerErrors.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 09.10.2024.
//

import Foundation

enum ServiceError: Error {
    case networkError(Error)
    case serverError(Error)

    var localizedDescription: String {
        switch self {
        case .networkError(let error), .serverError(let error):
            return error.localizedDescription
        }
    }
}
