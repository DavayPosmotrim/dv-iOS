//
//  SessionServiceAPI.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 24.09.2024.
//

import Foundation
import Moya

enum SessionServiceAPI {
    case connectUserToSession(sessionCode: String, deviceId: String)
}

extension SessionServiceAPI: TargetType {
    var baseURL: URL {
        return URL(string: AppMetaInfo.baseURL)!
    }

    var path: String {
        switch self {
        case .connectUserToSession(let sessionCode, _):
            return "api/sessions/\(sessionCode)/connection/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .connectUserToSession:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .connectUserToSession:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .connectUserToSession(_, let deviceId):
            return [
                "Accept": "application/json",
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
