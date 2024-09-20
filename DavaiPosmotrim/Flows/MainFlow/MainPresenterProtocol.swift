//
//  MainPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 01.05.24.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func didTapButtons(screen: String)
    func checkUserNameProperty() -> String
    func getUserName(_ notification: Notification) -> String
    func getUser()
}
