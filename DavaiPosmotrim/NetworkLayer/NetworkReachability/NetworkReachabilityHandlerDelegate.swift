//
//  NetworkReachabilityHandlerDelegate.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 29.08.2024.
//

import Foundation

protocol NetworkReachabilityHandlerDelegate: AnyObject {
    func didChangeNetworkStatus(isReachable: Bool?)
}
