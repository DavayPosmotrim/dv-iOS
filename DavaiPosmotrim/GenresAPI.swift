//
//  GenresAPI.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 28.07.2024.
//

import Foundation
import Moya

enum GenresAPI {
    case getGenres
}

extension GenresAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://80.87.108.90/")!
    }

    var path: String {
        switch self {
        case .getGenres:
            return "api/genres/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getGenres:
            return .get
        }
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var validationType: ValidationType {
        return .successAndRedirectCodes
    }

    var sampleData: Data {
        return Data()
    }
}
