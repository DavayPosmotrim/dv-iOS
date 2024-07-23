//
//  UserService.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.07.2024.
//
import Foundation
import Moya

// MARK: - UserService Protocol
protocol UserServiceProtocol {
    func getUser(
        deviceId: String,
        completion: @escaping (Result<CustomUserModel, Error>) -> Void
    )
    func createUser(
        deviceId: String,
        name: String,
        completion: @escaping (Result<CustomUserModel, Error>) -> Void
    )
    func updateUser(
        deviceId: String,
        name: String,
        completion: @escaping (Result<CustomUserModel, Error>) -> Void
    )
}

// MARK: - UserService Implementation

class UserService: UserServiceProtocol {
    private let provider: MoyaProvider<UserServiceAPI>

    init(provider: MoyaProvider<UserServiceAPI> = MoyaProvider<UserServiceAPI>()) {
        self.provider = provider
    }

    func getUser(deviceId: String, completion: @escaping (Result<CustomUserModel, Error>) -> Void) {
        provider.request(.getUser(deviceId: deviceId)) { result in
            switch result {
            case .success(let response):
                do {
                    let user = try JSONDecoder().decode(CustomUserModel.self, from: response.data)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func createUser(deviceId: String, name: String, completion: @escaping (Result<CustomUserModel, Error>) -> Void) {
        let userRequest = CustomUserRequestModel(name: name)

        provider.request(.createUser(deviceId: deviceId, user: userRequest)) { result in
            switch result {
            case .success(let response):
                do {
                    let user = try JSONDecoder().decode(CustomUserModel.self, from: response.data)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateUser(deviceId: String, name: String, completion: @escaping (Result<CustomUserModel, Error>) -> Void) {
        let userRequest = CustomUserRequestModel(name: name)

        provider.request(.updateUser(deviceId: deviceId, user: userRequest)) { result in
            switch result {
            case .success(let response):
                do {
                    let user = try JSONDecoder().decode(CustomUserModel.self, from: response.data)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
