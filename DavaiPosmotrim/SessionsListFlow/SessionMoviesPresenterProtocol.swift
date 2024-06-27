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
    var users: [User] { get }
    var movies: [SessionMovieModel] { get }
    var sessionCode: String { get }
    var sessionDateForTitle: String { get }

    func viewDidLoad()
    func showMovie(by sessionIndex: Int)
}
