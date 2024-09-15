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
}

struct WebSocketsAPI {
    private static let baseURL = "ws://80.87.108.90/ws/session/"

    static func createWebSocketManager(
        for endpoint: Endpoint,
        sessionID: String
    ) -> WebSocketsManager {
        let webSocketsManager = WebSocketsManager()
        let webSocketURL: String = {
            switch endpoint {
            case .usersUpdate:
                return "\(baseURL)\(sessionID)/users/"
            case .sessionStatusUpdate:
                return "\(baseURL)\(sessionID)/session_status/"
            case .moviesMatchesUpdate:
                return "\(baseURL)\(sessionID)/matches/"
            case .rouletteUpdate:
                return "\(baseURL)\(sessionID)/roulette/"
            case .sessionResultUpdate:
                return "\(baseURL)\(sessionID)/session_result/"
            }
        }()
        webSocketsManager.connect(to: webSocketURL)

        return webSocketsManager
    }
}
