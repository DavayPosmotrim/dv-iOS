//
//  InvitingUsersPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 28.05.2024.
//

import Foundation

protocol InvitingUsersPresenterProtocol: AnyObject {
    func getNamesCount() -> Int
    func getNamesAtIndex(index: Int) -> ReusableCollectionCellModel
    func viewDidLoad()
    func startButtonTapped()
    func codeButtonTapped()
    func cancelButtonTapped()
    func quitSessionButtonTapped()
    func getSessionCode() -> String
}
