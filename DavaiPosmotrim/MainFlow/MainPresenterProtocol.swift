//
//  MainPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 01.05.24.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func finishCoordinator()
    func didTapButtons(screen: String)
    func checkUserNameProperty() -> String
    func getUserName(_ notification: Notification) -> String
}
