//
//  UserServiceApi.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.07.2024.
//

import Foundation
import Moya

enum UserServiceAPI {
    case getUser(uuid: String)
    case createUser(deviceId: String, user: CustomUserRequestModel)
    case updateUser(deviceId: String, user: CustomUserRequestModel)
}

extension UserServiceAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://80.87.108.90/")!
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
        case .createUser(let deviceId, let user),
                .updateUser(let deviceId, let user):
            do {
                let userData = try JSONEncoder().encode(user)
                return .requestCompositeData(bodyData: userData, urlParameters: ["device_id": deviceId])
            } catch {
                return .requestPlain
            }
        }
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

