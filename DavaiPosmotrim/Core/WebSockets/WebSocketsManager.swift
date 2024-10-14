//
//  WebSocketsManager.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 12.09.2024.
//

import Foundation

struct WebSocketsModel {
    let stringAction: ((String) -> Void)?
    let dataAction: ((Data) -> Void)?
    let errorAction: (() -> Void)?
}

final class WebSocketsManager {

    // MARK: - Stored properties

    private var stringMessageReceived: ((String) -> Void)?
    private var dataMessageReceived: ((Data) -> Void)?
    private var errorAction: (() -> Void)?

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

    func configureSocket(with model: WebSocketsModel) {
        stringMessageReceived = model.stringAction
        dataMessageReceived = model.dataAction
        errorAction = model.errorAction
    }

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
                print("Error receiving message: \(error.localizedDescription)")
                if self.isConnected {
                    self.handleDisconnect()
                } else {
                    self.errorAction?()
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
            print("Max reconnect attempts reached. Giving up.")
            errorAction?()
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
