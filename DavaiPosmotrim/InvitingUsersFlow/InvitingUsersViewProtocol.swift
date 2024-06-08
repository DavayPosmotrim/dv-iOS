//
//  InvitingUsersViewProtocol.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 28.05.2024.
//

import Foundation

protocol InvitingUsersViewProtocol: AnyObject {
    func showFewUsersWarning()
    func showCodeCopyWarning()
    func showCancelSessionDialog()
    func copyCodeToClipboard(_ code: String)
}
