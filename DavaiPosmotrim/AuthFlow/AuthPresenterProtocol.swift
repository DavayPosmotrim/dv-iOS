//
//  AuthPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 06.05.2024.
//

import Foundation

protocol AuthPresenterProtocol: AnyObject {
    func authFinish()
    func checkUserNameProperty() -> String
    func createUser(name: String, completion: @escaping (Bool) -> Void)
}
