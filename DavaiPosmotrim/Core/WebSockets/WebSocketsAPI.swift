//
//  WebSocketsAPI.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 15.09.2024.
//

import Foundation

enum Endpoint {
    case usersUpdate
    case sessionStatusUpdate
    case moviesMatchesUpdate
    case rouletteUpdate
    case sessionResultUpdate

    var urlPath: String {
        switch self {
        case .usersUpdate: "/users/"
        case .sessionStatusUpdate: "/session_status/"
        case .moviesMatchesUpdate: "/matches/"
        case .rouletteUpdate: "/roulette/"
        case .sessionResultUpdate: "/session_result/"
        }
    }
}

struct WebSocketsAPI {
    static func createWebSocketManager(
        for endpoint: Endpoint,
        sessionID: String
    ) -> WebSocketsManager {
        let webSocketsManager = WebSocketsManager()
        let webSocketURL: String = "\(AppMetaInfo.webSocketsBaseURL)\(sessionID)\(endpoint.urlPath)"
        webSocketsManager.connect(to: webSocketURL)

        return webSocketsManager
    }
}
