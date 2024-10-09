//
//  GenresService.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 28.07.2024.
//

import Foundation
import Moya

protocol ContentServiceProtocol {
    func getGenres(
        with deviceId: String,
        completion: @escaping (Result<[GenreModel], ServiceError>) -> Void
    )
    func getCollections(
        with deviceId: String,
        completion: @escaping (Result<[CollectionModel], ServiceError>) -> Void
    )
    func getMovieInfo(
        with movieId: Int,
        deviceId: String,
        completion: @escaping (Result<MovieDetailModel, ServiceError>) -> Void
    )
}

struct ErrorResponse: Codable {
    let detail: String

    private enum CodingKeys: String, CodingKey {
        case detail
    }
}

final class ContentService: ContentServiceProtocol {
    private let provider: MoyaProvider<ContentAPI>

    init(provider: MoyaProvider<ContentAPI> = MoyaProvider<ContentAPI>()) {
        self.provider = provider
    }

    func getGenres(
        with deviceId: String,
        completion: @escaping (Result<[GenreModel], ServiceError>) -> Void
    ) {
        provider.request(.getGenres(deviceId: deviceId)) { result in
            switch result {
            case .success(let response):
                do {
                    let genres = try JSONDecoder().decode([GenreModel].self, from: response.data)
                    completion(.success(genres))
                } catch {
                    completion(.failure(.networkError(error)))
                }
            case .failure(let error):
                if let response = error.response {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                        completion(
                            .failure(
                                .serverError(
                                    NSError(
                                        domain: "",
                                        code: response.statusCode,
                                        userInfo: [NSLocalizedDescriptionKey: errorResponse.detail]
                                    )
                                )
                            )
                        )
                    } catch {
                        completion(.failure(.networkError(error)))
                    }
                } else {
                    completion(.failure(.networkError(error)))
                }
            }
        }
    }

    func getCollections(
        with deviceId: String,
        completion: @escaping (Result<[CollectionModel], ServiceError>) -> Void
    ) {
        provider.request(.getCollections(deviceId: deviceId)) { result in
            switch result {
            case .success(let response):
                do {
                    let collections = try JSONDecoder().decode([CollectionModel].self, from: response.data)
                    completion(.success(collections))
                } catch {
                    completion(.failure(.networkError(error)))
                }
            case .failure(let error):
                if let response = error.response {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                        completion(
                            .failure(
                                .serverError(
                                    NSError(
                                        domain: "",
                                        code: response.statusCode,
                                        userInfo: [NSLocalizedDescriptionKey: errorResponse.detail]
                                    )
                                )
                            )
                        )
                    } catch {
                        completion(.failure(.networkError(error)))
                    }
                } else {
                    completion(.failure(.networkError(error)))
                }
            }
        }
    }

    func getMovieInfo(
        with movieId: Int,
        deviceId: String,
        completion: @escaping (Result<MovieDetailModel, ServiceError>) -> Void
    ) {
        provider.request(.getMovieInfo(movieId: movieId, deviceId: deviceId)) { result in
            switch result {
            case.success(let response):
                do {
                    let movieInfo = try JSONDecoder().decode(MovieDetailModel.self, from: response.data)
                    completion(.success(movieInfo))
                } catch {
                    completion(.failure(.networkError(error)))
                }
            case .failure(let error):
                if let response = error.response {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                        completion(
                            .failure(
                                .serverError(
                                    NSError(
                                        domain: "",
                                        code: response.statusCode,
                                        userInfo: [NSLocalizedDescriptionKey: errorResponse.detail]
                                    )
                                )
                            )
                        )
                    } catch {
                        completion(.failure(.networkError(error)))
                    }
                } else {
                    completion(.failure(.networkError(error)))
                }
            }
        }
    }
}
