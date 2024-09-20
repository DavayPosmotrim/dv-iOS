//
//  WebSocketsManager.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 12.09.2024.
//

import Foundation

final class WebSocketsManager {

    // MARK: - Stored properties

    var stringMessageReceived: ((String) -> Void)?
    var dataMessageReceived: ((Data) -> Void)?

    private var webSocket: URLSessionWebSocketTask?
    private let urlSession: URLSession
    private var isConnected = false
    private var connectionAttempts = 0
    private let maxConnectionAttempts = 5

    // MARK: - Initializers

    init() {
        let configuration = URLSessionConfiguration.default
        urlSession = URLSession(configuration: configuration)
    }

    // MARK: - Public methods

    func connect(to urlString: String) {
        guard
            !isConnected,
            let url = URL(string: urlString)
        else { return }

        var request = URLRequest(url: url)
        request.setValue(AppMetaInfo.baseURL, forHTTPHeaderField: "Origin")
        webSocket = urlSession.webSocketTask(with: request)
        webSocket?.resume()

        webSocket?.sendPing { error in
            if let error = error {
                // TODO: Handle errors
                print("Connection failed: \(error.localizedDescription)")
                self.handleDisconnect()
            } else {
                self.connectionAttempts = 0
                self.isConnected = true
                print("WebSocket connected!")
            }
        }
        receiveMessages()
    }

    func disconnect() {
        isConnected = false
        webSocket?.cancel(with: .goingAway, reason: nil)
    }
}

    // MARK: - Private methods

private extension WebSocketsManager {

    func receiveMessages() {
        guard let webSocket else { return }

        webSocket.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self.stringMessageReceived?(text)
                case .data(let data):
                    self.dataMessageReceived?(data)
                @unknown default:
                    fatalError()
                }
                self.receiveMessages()

            case .failure(let error):
                // TODO: Handle errors
                print("Error receiving message: \(error.localizedDescription)")
                if self.isConnected {
                    self.handleDisconnect()
                }
            }
        }
    }

    func handleDisconnect() {
        isConnected = false
        connectionAttempts += 1
        print("WebSocket disconnected. Attempting to reconnect (\(connectionAttempts)/\(maxConnectionAttempts))...")

        if connectionAttempts <= maxConnectionAttempts {
            let delay: TimeInterval = 5.0
            DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                self.reconnect()
            }
        } else {
            // TODO: Handle errors
            print("Max reconnect attempts reached. Giving up.")
        }
    }

    func reconnect() {
        guard let lastURL = webSocket?.currentURL else { return }
        connect(to: lastURL.absoluteString)
    }
}

    // MARK: - URLSessionWebSocketTask

extension URLSessionWebSocketTask {
    var currentURL: URL? {
        return (self as URLSessionWebSocketTask).originalRequest?.url
    }
}
