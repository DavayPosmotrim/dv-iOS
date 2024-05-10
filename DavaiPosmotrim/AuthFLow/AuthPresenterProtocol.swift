//
//  AuthPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 06.05.2024.
//

import Foundation

protocol AuthPresenterProtocol: AnyObject {
    func authFinish()
    func calculateCharactersNumber(with text: String)
    func handleEnterButtonTap(with name: String) -> String
    func checkUserNameProperty() -> String
}
