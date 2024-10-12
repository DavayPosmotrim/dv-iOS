//
//  InvitingUsersViewProtocol.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 28.05.2024.
//

import Foundation

protocol InvitingUsersViewProtocol: AnyObject {
    var isServerReachable: Bool? { get }

    func showFewUsersWarning()
    func showCodeCopyWarning()
    func showCancelSessionDialog()
    func copyCodeToClipboard(_ code: String)
    func shareCode(_ code: String)
    func showLoader()
    func hideLoader()
    func showNetworkError()
}
