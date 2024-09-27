//
//  SessionService.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 25.09.2024.
//

import Foundation
import Moya

enum SessionServiceError: Error {
    case networkError(Error)
    case serverError(Error)

    var localizedDescription: String {
        switch self {
        case .networkError(let error), .serverError(let error):
            return error.localizedDescription
        }
    }
}

struct SessionErrorResponse: Codable {
    let errorMessage: String?
    let detail: String?

    private enum CodingKeys: String, CodingKey {
        case errorMessage = "error_message"
        case detail
    }
}

struct ConnectionResultModel: Codable {
    let message: String

    private enum CodingKeys: CodingKey {
        case message
    }
}

protocol SessionServiceProtocol {
    func connectUserToSession(
        sessionCode: String,
        deviceId: String,
        completion: @escaping (Result<ConnectionResultModel, SessionServiceError>) -> Void
    )
    func disconnectUserFromSession(
        sessionCode: String,
        deviceId: String,
        completion: @escaping (Result<ConnectionResultModel, SessionServiceError>) -> Void
    )
    func getSessionMatchedMovies(
        sessionCode: String,
        deviceId: String,
        completion: @escaping (Result<[MatchedMovieResponseModel], SessionServiceError>) -> Void
    )
}

final class SessionService: SessionServiceProtocol {

    private let provider: MoyaProvider<SessionServiceAPI>

    init(provider: MoyaProvider<SessionServiceAPI> = MoyaProvider<SessionServiceAPI>()) {
        self.provider = provider
    }

    func connectUserToSession(
        sessionCode: String,
        deviceId: String,
        completion: @escaping (Result<ConnectionResultModel, SessionServiceError>) -> Void) {
            provider.request(.connectUserToSession(sessionCode: sessionCode, deviceId: deviceId)) { result in

                switch result {
                case .success(let response):
                    do {
                        let message = try JSONDecoder().decode(ConnectionResultModel.self, from: response.data)
                        completion(.success(message))
                    } catch {
                        completion(.failure(.networkError(error)))
                    }
                case .failure(let error):
                    switch error.response {
                    case let response?:
                        do {
                            let errorResponse = try JSONDecoder().decode(SessionErrorResponse.self, from: response.data)
                            switch (errorResponse.errorMessage, errorResponse.detail) {
                            case (let errorMessage?, _):
                                completion(
                                    .failure(
                                        .serverError(
                                            NSError(
                                                domain: "",
                                                code: response.statusCode,
                                                userInfo: [NSLocalizedDescriptionKey: errorMessage]
                                            )
                                        )
                                    )
                                )
                            case (_, let detailMessage?):
                                completion(
                                    .failure(
                                        .serverError(
                                            NSError(
                                                domain: "",
                                                code: response.statusCode,
                                                userInfo: [NSLocalizedDescriptionKey: detailMessage]
                                            )
                                        )
                                    )
                                )
                            default:
                                completion(.failure(.networkError(error)))
                            }
                        } catch {
                            completion(.failure(.networkError(error)))
                        }
                    case nil:
                        completion(.failure(.networkError(error)))
                    }
                }
            }
        }

    func disconnectUserFromSession(
        sessionCode: String,
        deviceId: String,
        completion: @escaping (Result<ConnectionResultModel, SessionServiceError>) -> Void) {
            provider.request(.disconnectUserFromSession(sessionCode: sessionCode, deviceId: deviceId)) { result in

                switch result {
                case .success(let response):
                    do {
                        let message = try JSONDecoder().decode(ConnectionResultModel.self, from: response.data)
                        completion(.success(message))
                    } catch {
                        completion(.failure(.networkError(error)))
                    }
                case .failure(let error):
                    if let response = error.response {
                        do {
                            let errorResponse = try JSONDecoder().decode(SessionErrorResponse.self, from: response.data)
                            completion(
                                .failure(
                                    .serverError(
                                        NSError(
                                            domain: "",
                                            code: response.statusCode,
                                            userInfo: [NSLocalizedDescriptionKey: errorResponse.errorMessage as Any]
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

    func getSessionMatchedMovies(
        sessionCode: String,
        deviceId: String,
        completion: @escaping (Result<[MatchedMovieResponseModel], SessionServiceError>) -> Void) {
            provider.request(.getSessionMatchedMovies(sessionCode: sessionCode, deviceId: deviceId)) { result in
                switch result {
                case .success(let response):
                    do {
                        let matchedMovies = try JSONDecoder().decode(
                            [MatchedMovieResponseModel].self,
                            from: response.data
                        )
                        completion(.success(matchedMovies))
                    } catch {
                        completion(.failure(.networkError(error)))
                    }
                case .failure(let error):
                    if let response = error.response {
                        do {
                            let errorResponse = try JSONDecoder().decode(
                                SessionErrorResponse.self,
                                from: response.data
                            )
                            completion(
                                .failure(
                                    .serverError(
                                        NSError(
                                            domain: "",
                                            code: response.statusCode,
                                            userInfo: [NSLocalizedDescriptionKey: errorResponse.detail as Any]
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
