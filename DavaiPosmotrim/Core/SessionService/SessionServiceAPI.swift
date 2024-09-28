//
//  SessionServiceAPI.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 24.09.2024.
//

import Foundation
import Moya

enum SessionServiceAPI {
    case connectUserToSession(sessionCode: String, deviceId: String)
    case disconnectUserFromSession(sessionCode: String, deviceId: String)
    case getSessionMatchedMovies(sessionCode: String, deviceId: String)
    case getRouletteRandomMovie(sessionCode: String, deviceId: String)
    case startVotingSessionStatus(sessionCode: String, deviceId: String)
    case putLikeToMovieInSession(sessionCode: String, deviceId: String, movieId: String)
    case deleteLikeForMovieInSession(sessionCode: String, deviceId: String, movieId: String)
}

extension SessionServiceAPI: TargetType {
    var baseURL: URL {
        return URL(string: AppMetaInfo.baseURL)!
    }

    var path: String {
        switch self {
        case .connectUserToSession(let sessionCode, _), .disconnectUserFromSession(let sessionCode, _):
            return "api/sessions/\(sessionCode)/connection/"
        case .getSessionMatchedMovies(let sessionCode, _):
            return "api/sessions/\(sessionCode)/get_matched_movies/"
        case.getRouletteRandomMovie(let sessionCode, _):
            return "api/sessions/\(sessionCode)/get_roulette/"
        case .startVotingSessionStatus(let sessionCode, _):
            return "api/sessions/\(sessionCode)/start_voting/"
        case    .putLikeToMovieInSession(let sessionCode, _, let movieId),
                .deleteLikeForMovieInSession(let sessionCode, _, let movieId):
            return "api/sessions/\(sessionCode)/movies/\(movieId)/like/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .connectUserToSession, .putLikeToMovieInSession:
            return .post
        case .disconnectUserFromSession, .deleteLikeForMovieInSession:
            return .delete
        case .getSessionMatchedMovies, .getRouletteRandomMovie, .startVotingSessionStatus:
            return .get
        }
    }

    var task: Task {
        switch self {
        case    .connectUserToSession,
                .disconnectUserFromSession,
                .getSessionMatchedMovies,
                .getRouletteRandomMovie,
                .startVotingSessionStatus,
                .putLikeToMovieInSession,
                .deleteLikeForMovieInSession:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case    .connectUserToSession(_, let deviceId),
                .disconnectUserFromSession(_, let deviceId),
                .getSessionMatchedMovies(_, let deviceId),
                .getRouletteRandomMovie(_, let deviceId),
                .startVotingSessionStatus(_, let deviceId),
                .putLikeToMovieInSession(_, let deviceId, _),
                .deleteLikeForMovieInSession(_, let deviceId, _):
            return [
                "Accept": "application/json",
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
