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
    case getSessionInfo(sessionCode: String, deviceId: String)
    case getSessionMoviesList(sessionCode: String)
    case getSessionsList(deviceId: String)
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
        case .getSessionInfo(let sessionCode, _):
            return "api/sessions/\(sessionCode)/"
        case .getSessionMoviesList(let sessionCode):
            return "api/sessions/\(sessionCode)/movies/"
        case .getSessionsList(_):
            return "api/sessions/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .connectUserToSession, .putLikeToMovieInSession:
            return .post
        case .disconnectUserFromSession, .deleteLikeForMovieInSession:
            return .delete
        case    .getSessionMatchedMovies,
                .getRouletteRandomMovie,
                .startVotingSessionStatus,
                .getSessionInfo,
                .getSessionMoviesList,
                .getSessionsList:
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
                .deleteLikeForMovieInSession,
                .getSessionInfo,
                .getSessionMoviesList,
                .getSessionsList:
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
                .deleteLikeForMovieInSession(_, let deviceId, _),
                .getSessionInfo(_, let deviceId),
                .getSessionsList(let deviceId):
            return [
                "Accept": "application/json",
                "Device-Id": deviceId
            ]
        case .getSessionMoviesList:
            return [
                "Accept": "application/json"
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
