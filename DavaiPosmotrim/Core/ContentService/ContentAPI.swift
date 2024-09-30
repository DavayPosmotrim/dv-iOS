//
//  GenresAPI.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 28.07.2024.
//

import Foundation
import Moya

enum ContentAPI {
    case getGenres(deviceId: String)
    case getCollections(deviceId: String)
}

extension ContentAPI: TargetType {
    var baseURL: URL {
        URL(string: AppMetaInfo.baseURL)!
    }

    var path: String {
        switch self {
        case .getGenres:
            return "api/genres/"
        case .getCollections:
            return "api/collections/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getGenres, .getCollections:
            return .get
        }
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String: String]? {
        switch self {
        case .getGenres(let deviceId), .getCollections(let deviceId):
            return [
                "Content-Type": "application/json",
                "Device-Id": deviceId
            ]
        }
    }

    var validationType: ValidationType {
        return .successAndRedirectCodes
    }

    var sampleData: Data {
        return Data()
    }
}
