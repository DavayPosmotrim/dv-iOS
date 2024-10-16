//
//  SessionsListPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 12.06.2024.
//

import Foundation

protocol SessionsListPresenterProtocol: AnyObject {
    // MARK: - Properties
    var isSessionsListEmpty: Bool { get }
    var sessionsCount: Int { get }
    var sessions: [SessionModel] { get }

    // MARK: - Methods
    func viewDidLoad()
    func updateSessionsList()
    func showSessionMovies(by sessionIndex: Int)
}
