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
    let detail: String

    private enum CodingKeys: String, CodingKey {
        case detail
    }
}

protocol SessionServiceProtocol {
    func connectUserToSession(
        sessionCode: String,
        deviceId: String,
        completion: @escaping (Result<MessageResponseModel, SessionServiceError>) -> Void
    )
    func disconnectUserFromSession(
        sessionCode: String,
        deviceId: String,
        completion: @escaping (Result<MessageResponseModel, SessionServiceError>) -> Void
    )
    func getSessionMatchedMovies(
        sessionCode: String,
        deviceId: String,
        completion: @escaping (Result<[MatchedMovieResponseModel], SessionServiceError>) -> Void
    )
    func getRouletteRandomMovie(
        sessionCode: String,
        deviceId: String,
        completion: @escaping (Result<RouletteRandomMovieResponseModel, SessionServiceError>) -> Void
    )
    func startVotingSessionStatus(
        sessionCode: String,
        deviceId: String,
        completion: @escaping (Result<MessageResponseModel, SessionServiceError>) -> Void
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
        completion: @escaping (Result<MessageResponseModel, SessionServiceError>) -> Void
    ) {
            provider.request(.connectUserToSession(sessionCode: sessionCode, deviceId: deviceId)) { result in

                switch result {
                case .success(let response):
                    do {
                        let message = try JSONDecoder().decode(MessageResponseModel.self, from: response.data)
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

    func disconnectUserFromSession(
        sessionCode: String,
        deviceId: String,
        completion: @escaping (Result<MessageResponseModel, SessionServiceError>) -> Void
    ) {
            provider.request(.disconnectUserFromSession(sessionCode: sessionCode, deviceId: deviceId)) { result in

                switch result {
                case .success(let response):
                    do {
                        let message = try JSONDecoder().decode(MessageResponseModel.self, from: response.data)
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

    func getSessionMatchedMovies(
        sessionCode: String,
        deviceId: String,
        completion: @escaping (Result<[MatchedMovieResponseModel], SessionServiceError>) -> Void
    ) {
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

    func getRouletteRandomMovie(
        sessionCode: String,
        deviceId: String,
        completion: @escaping (Result<RouletteRandomMovieResponseModel, SessionServiceError>) -> Void
    ) {
        provider.request(.getRouletteRandomMovie(sessionCode: sessionCode, deviceId: deviceId)) { result in
            switch result {
            case.success(let response):
                do {
                    let randomMovie = try JSONDecoder().decode(
                        RouletteRandomMovieResponseModel.self,
                        from: response.data
                    )
                    completion(.success(randomMovie))
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

    func startVotingSessionStatus(
        sessionCode: String,
        deviceId: String,
        completion: @escaping (Result<MessageResponseModel, SessionServiceError>) -> Void
    ) {
        provider.request(.startVotingSessionStatus(sessionCode: sessionCode, deviceId: deviceId)) { result in
            switch result {
            case.success(let response):
                do {
                    let message = try JSONDecoder().decode(
                        MessageResponseModel.self,
                        from: response.data
                    )
                    completion(.success(message))
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
