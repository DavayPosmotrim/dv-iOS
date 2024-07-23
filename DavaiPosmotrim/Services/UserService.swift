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
    func getUser(uuid: String, completion: @escaping (Result<CustomUserModel, Error>) -> Void)
    func createUser(name: String, completion: @escaping (Result<CustomUserModel, Error>) -> Void)
    func updateUser(name: String, completion: @escaping (Result<CustomUserModel, Error>) -> Void)
}

// MARK: - UserService Implementation
class UserService: UserServiceProtocol {
    private let provider: MoyaProvider<UserServiceAPI>
    
    init(provider: MoyaProvider<UserServiceAPI> = MoyaProvider<UserServiceAPI>()) {
        self.provider = provider
    }
    
    func getUser(uuid: String, completion: @escaping (Result<CustomUserModel, Error>) -> Void) {
        provider.request(.getUser(uuid: uuid)) { result in
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
    
    func createUser(name: String, completion: @escaping (Result<CustomUserModel, Error>) -> Void) {
        let userRequest = CustomUserRequestModel(name: name)
        let deviceId = UUID().uuidString
        
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
    
    func updateUser(name: String, completion: @escaping (Result<CustomUserModel, Error>) -> Void) {
        let userRequest = CustomUserRequestModel(name: name)
        let deviceId = UUID().uuidString
        
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
