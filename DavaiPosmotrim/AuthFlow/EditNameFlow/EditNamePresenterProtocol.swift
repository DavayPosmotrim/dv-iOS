//
//  EditNamePresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.07.2024.
//

import Foundation

protocol EditNamePresenterProtocol: AnyObject {
    func finishEdit()
    func authDidFinishNotification(userName: String)
    func handleEnterButtonTap(with name: String) -> String
    func checkUserNameProperty() -> String
}
