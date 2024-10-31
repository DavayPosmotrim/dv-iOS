//
//  CoincidencesViewProtocol.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 12.06.2024.
//

import Foundation

protocol CoincidencesViewProtocol: AnyObject {
    var isServerReachable: Bool? { get set }

    func updateUIElements()
    func showLoader()
    func hideLoader()
    func showNetworkError()
    func showServerError()
}
