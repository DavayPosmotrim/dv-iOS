//
//  SessionsListPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 12.06.2024.
//

import Foundation

protocol SessionsListPresenterProtocol: AnyObject {
    // MARK: - Properties
    var coordinator: SessionsListCoordinator? { get set }
    var view: SessionsListViewControllerProtocol? { get set }
    var isSessionsListEmpty: Bool { get }
    var sessionsCount: Int { get }

    // MARK: - Methods
    func viewDidLoad()
    func updateSessionsList()
    func getSessionForCellBy(index: Int) -> SessionsListViewModel
    func showSessionMovies(by sessionIndex: Int)
}
