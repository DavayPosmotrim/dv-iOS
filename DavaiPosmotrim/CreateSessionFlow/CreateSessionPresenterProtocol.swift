//
//  CreateSessionPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 14.05.24.
//

import UIKit

protocol CreateSessionPresenterProtocol: AnyObject {
    var createSession: CreateSesseionModel { get set }
    func showPreviousScreen(navigationController: UINavigationController?)
    func showNextScreen(navigationController: UINavigationController?)
    func didAddCollection(title: String?)
    func didRemoveCollection(title: String?)
    func didAddGenres(title: String?)
    func didRemoveGenres(title: String?)
}
