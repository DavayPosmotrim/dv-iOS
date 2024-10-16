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
    func checkUserNameProperty() -> String
    func updateUser(name: String, completion: @escaping (Bool) -> Void)
}
