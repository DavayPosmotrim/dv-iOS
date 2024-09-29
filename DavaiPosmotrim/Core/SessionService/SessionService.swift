//
//  SessionService.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 25.09.2024.
//

import Foundation
import Moya

// swiftlint:disable file_length

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
    let detail: String?
    let nonFieldErrors: [String]?
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case detail
        case nonFieldErrors = "non_field_errors"
        case message
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
        completion: @escaping (Result<[MovieResponseModel], SessionServiceError>) -> Void
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
    func putLikeToMovieInSession(
        sessionCode: String,
        deviceId: String,
        movieId: String,
        completion: @escaping (Result<SessionLikeResponseModel, SessionServiceError>) -> Void
    )
    func deleteLikeForMovieInSession(
        sessionCode: String,
        deviceId: String,
        movieId: String,
        completion: @escaping (Result<MessageResponseModel, SessionServiceError>) -> Void
    )
    func getSessionInfo(
        sessionCode: String,
        deviceId: String,
        completion: @escaping (Result<SessionInfoResponseModel, SessionServiceError>) -> Void
    )
    func getSessionMoviesList(
        sessionCode: String,
        completion: @escaping (Result<[MovieResponseModel], SessionServiceError>) -> Void
    )
    func getSessionsList(
        deviceId: String,
        completion: @escaping (Result<[SessionsListResponseModel], SessionServiceError>) -> Void
    )
    func createSession(
        deviceId: String,
        genresOrCollections: CreateSessionRequestModel,
        completion: @escaping (Result<CreateSessionResponseModel, SessionServiceError>) -> Void
    )
}

// swiftlint:disable type_body_length

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

    func getSessionMatchedMovies(
        sessionCode: String,
        deviceId: String,
        completion: @escaping (Result<[MovieResponseModel], SessionServiceError>) -> Void
    ) {
            provider.request(.getSessionMatchedMovies(sessionCode: sessionCode, deviceId: deviceId)) { result in
                switch result {
                case .success(let response):
                    do {
                        let matchedMovies = try JSONDecoder().decode(
                            [MovieResponseModel].self,
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

    func putLikeToMovieInSession(
        sessionCode: String,
        deviceId: String,
        movieId: String,
        completion: @escaping (Result<SessionLikeResponseModel, SessionServiceError>) -> Void
    ) {
        provider.request(
            .putLikeToMovieInSession(
                sessionCode: sessionCode,
                deviceId: deviceId,
                movieId: movieId
            )
        ) { result in
            switch result {
            case.success(let response):
                do {
                    let likeResponse = try JSONDecoder().decode(
                        SessionLikeResponseModel.self,
                        from: response.data
                    )
                    completion(.success(likeResponse))
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

                        let errorMessage: String
                        if let nonFieldErrors = errorResponse.nonFieldErrors, !nonFieldErrors.isEmpty {
                            errorMessage = nonFieldErrors.joined(separator: ", ")
                        } else {
                            errorMessage = errorResponse.detail ?? "An unknown error occurred."
                        }

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
                    } catch {
                        completion(.failure(.networkError(error)))
                    }
                } else {
                    completion(.failure(.networkError(error)))
                }
            }
        }
    }

    func deleteLikeForMovieInSession(
        sessionCode: String,
        deviceId: String,
        movieId: String,
        completion: @escaping (Result<MessageResponseModel, SessionServiceError>) -> Void
    ) {
        provider.request(
            .deleteLikeForMovieInSession(
                sessionCode: sessionCode,
                deviceId: deviceId,
                movieId: movieId
            )
        ) { result in
            switch result {
            case.success(let response):
                do {
                    let deleteLikeResponse = try JSONDecoder().decode(
                        MessageResponseModel.self,
                        from: response.data
                    )
                    completion(.success(deleteLikeResponse))
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

                        let errorMessage: String
                        if let message = errorResponse.message, !message.isEmpty {
                            errorMessage = message
                        } else {
                            errorMessage = errorResponse.detail ?? "An unknown error occurred."
                        }

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
                    } catch {
                        completion(.failure(.networkError(error)))
                    }
                } else {
                    completion(.failure(.networkError(error)))
                }
            }
        }
    }

    func getSessionInfo(
        sessionCode: String,
        deviceId: String,
        completion: @escaping (Result<SessionInfoResponseModel, SessionServiceError>) -> Void
    ) {
        provider.request(.getSessionInfo(sessionCode: sessionCode, deviceId: deviceId)) { result in
            switch result {
            case.success(let response):
                do {
                    let info = try JSONDecoder().decode(
                        SessionInfoResponseModel.self,
                        from: response.data
                    )
                    completion(.success(info))
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

    func getSessionMoviesList(
        sessionCode: String,
        completion: @escaping (Result<[MovieResponseModel], SessionServiceError>) -> Void
    ) {
            provider.request(.getSessionMoviesList(sessionCode: sessionCode)) { result in
                switch result {
                case .success(let response):
                    do {
                        let list = try JSONDecoder().decode(
                            [MovieResponseModel].self,
                            from: response.data
                        )
                        completion(.success(list))
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

    func getSessionsList(
        deviceId: String,
        completion: @escaping (Result<[SessionsListResponseModel], SessionServiceError>) -> Void
    ) {
            provider.request(.getSessionsList(deviceId: deviceId)) { result in
                switch result {
                case .success(let response):
                    do {
                        let list = try JSONDecoder().decode(
                            [SessionsListResponseModel].self,
                            from: response.data
                        )
                        completion(.success(list))
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

    func createSession(
        deviceId: String,
        genresOrCollections: CreateSessionRequestModel,
        completion: @escaping (Result<CreateSessionResponseModel, SessionServiceError>) -> Void
    ) {
        let createSessionRequest = CreateSessionRequestModel(
            genres: genresOrCollections.genres,
            collections: genresOrCollections.collections
        )

        provider.request(.createSession(deviceId: deviceId, genresOrCollections: createSessionRequest)) { result in
            switch result {
            case .success(let response):
                do {
                    let session = try JSONDecoder().decode(
                        CreateSessionResponseModel.self,
                        from: response.data
                    )
                    completion(.success(session))
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

// swiftlint:enable type_body_length
