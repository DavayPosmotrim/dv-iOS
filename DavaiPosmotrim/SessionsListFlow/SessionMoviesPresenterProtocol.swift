//
//  SessionMoviesPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 22.06.2024.
//

import Foundation

protocol SessionMoviesPresenterProtocol: AnyObject {
    var coordinator: SessionsListCoordinator? { get }
    var view: SessionMoviesViewControllerProtocol? { get }
    var session: SessionModel { get }
    func viewDidLoad()
    func showMovie(by sessionIndex: Int)
}
