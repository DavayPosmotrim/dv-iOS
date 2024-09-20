//
//  UserServiceApi.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.07.2024.
//

import Foundation
import Moya

enum UserServiceAPI {
    case getUser(deviceId: String)
    case createUser(deviceId: String, user: CustomUserRequestModel)
    case updateUser(deviceId: String, user: CustomUserRequestModel)
}

extension UserServiceAPI: TargetType {
    var baseURL: URL {
        return URL(string: AppMetaInfo.baseURL)!
    }

    var path: String {
        switch self {
        case .getUser:
            return "api/users/"
        case .createUser, .updateUser:
            return "api/users/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getUser:
            return .get
        case .createUser:
            return .post
        case .updateUser:
            return .put
        }
    }

    var task: Task {
        switch self {
        case .getUser:
            return .requestPlain
        case .createUser(_, let user),
             .updateUser(_, let user):
            do {
                let userData = try JSONEncoder().encode(user)
                return .requestData(userData)
            } catch {
                return .requestPlain
            }
        }
    }

    var headers: [String: String]? {
        switch self {
        case .getUser(let deviceId),
             .createUser(let deviceId, _),
             .updateUser(let deviceId, _):
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
