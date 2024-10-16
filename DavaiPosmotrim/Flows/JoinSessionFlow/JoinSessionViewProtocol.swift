//
//  JoinSessionViewProtocol.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 23.05.2024.
//

import Foundation

protocol JoinSessionViewProtocol: AnyObject {
    var isServerReachable: Bool? { get set }

    func showLoader()
    func hideLoader()
    func showNetworkError()
    func showServerError()
}
