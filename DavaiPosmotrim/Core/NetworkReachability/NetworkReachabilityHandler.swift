//
//  NetworkReachabilityHandler.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 29.08.2024.
//

import Foundation
import Alamofire

final class NetworkReachabilityHandler {

    // MARK: - Stored properties

    weak var delegate: NetworkReachabilityHandlerDelegate?
    private let reachabilityManager = NetworkReachabilityManager()

    // MARK: - Public methods

    func setupNetworkReachability() {
        reachabilityManager?.startListening(onUpdatePerforming: { [weak self] status in
            guard let self else { return }
            switch status {
            case .notReachable:
                self.delegate?.didChangeNetworkStatus(isReachable: false)
            case .reachable(.ethernetOrWiFi), .reachable(.cellular):
                self.delegate?.didChangeNetworkStatus(isReachable: true)
            case .unknown:
                self.delegate?.didChangeNetworkStatus(isReachable: nil)
            }
            print("Network status changed: \(status)")
        })
    }

    func stopListening() {
        reachabilityManager?.stopListening()
    }
}
