//
//  GenresService.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 28.07.2024.
//

import Foundation
import Moya

protocol ContentServiceProtocol {
    func getGenres(completion: @escaping (Result<[GenreModel], Error>) -> Void)
    func getCollections(completion: @escaping (Result<[CollectionModel], Error>) -> Void)
}

struct ErrorResponse: Codable {
    let detail: String

    private enum CodingKeys: String, CodingKey {
        case detail
    }
}

class ContentService: ContentServiceProtocol {
    private let provider: MoyaProvider<ContentAPI>

    init(provider: MoyaProvider<ContentAPI> = MoyaProvider<ContentAPI>()) {
        self.provider = provider
    }

    func getGenres(completion: @escaping (Result<[GenreModel], Error>) -> Void) {
        provider.request(.getGenres) { result in
            switch result {
            case .success(let response):
                do {
                    let genres = try JSONDecoder().decode([GenreModel].self, from: response.data)
                    completion(.success(genres))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                if let response = error.response {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                        completion(.failure(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorResponse.detail])))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(error))
                }
            }
        }
    }

    func getCollections(completion: @escaping (Result<[CollectionModel], Error>) -> Void) {
        provider.request(.getCollections) { result in
            switch result {
            case .success(let response):
                do {
                    let collections = try JSONDecoder().decode([CollectionModel].self, from: response.data)
                    completion(.success(collections))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                if let response = error.response {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                        completion(.failure(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorResponse.detail])))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
}
