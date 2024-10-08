//
//  CreateSessionViewProtocol.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 04.10.2024.
//

import Foundation

protocol CreateSessionViewProtocol: AnyObject {
    var isServerReachable: Bool? { get set }

    func showLoader()
    func hideLoader()
    func showNetworkError()
    func showServerError()
}
