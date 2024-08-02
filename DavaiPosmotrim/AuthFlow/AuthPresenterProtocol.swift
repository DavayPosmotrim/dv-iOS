//
//  AuthPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 06.05.2024.
//

import Foundation

protocol AuthPresenterProtocol: AnyObject {
    func authFinish()
    func handleEnterButtonTap(with name: String)
    func checkUserNameProperty() -> String
    func authDidFinishNotification(userName: String)
}
