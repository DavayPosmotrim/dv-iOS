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
    case sessionCodeError(Error)

    var localizedDescription: String {
        switch self {
        case .networkError(let error), .sessionCodeError(let error):
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
                                        .sessionCodeError(
                                            NSError(
                                                domain: "",
                                                code: 0,
                                                userInfo: [NSLocalizedDescriptionKey: errorMessage]
                                            )
                                        )
                                    )
                                )
                            case (_, let detailMessage?):
                                completion(
                                    .failure(
                                        .sessionCodeError(
                                            NSError(
                                                domain: "",
                                                code: 0,
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
}
