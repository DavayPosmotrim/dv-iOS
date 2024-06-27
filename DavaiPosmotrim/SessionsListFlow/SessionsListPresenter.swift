//
//  SessionsListPresenter.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 12.06.2024.
//

import Foundation

final class SessionsListPresenter: SessionsListPresenterProtocol {

    // MARK: - Public properties
    weak var coordinator: SessionsListCoordinator?
    weak var view: SessionsListViewControllerProtocol?
    var isSessionsListEmpty: Bool {
        sessions.isEmpty
    }
    var sessionsCount: Int {
        sessions.count
    }

    // MARK: - Private properties
    private var sessions: [SessionModel]

    // MARK: - Inits
    init(
        sessions: [SessionModel] = [],
        coordinator: SessionsListCoordinator?,
        view: SessionsListViewController? = nil
    ) {
        self.sessions = sessions
        self.coordinator = coordinator
        self.view = view
    }

    // MARK: - Public methods
    func viewDidLoad() {
        setupMockData()
        updateView()
    }

    func updateSessionsList() {
        sessions.removeAll() // only for now
        updateView()
    }

    func updateView() {
        view?.showListOrEmptyView()
    }

    func getSessionForCellBy(index: Int) -> SessionsListViewModel {
        let session = sessions[index]
        return SessionsListViewModel(
            date: session.date,
            users: session.users.map { $0.name }.joined(separator: ", "),
            matches: String(session.matches),
            imageName: session.imageName
        )
    }
}

// MARK: - CustomNavigationBarDelegate
extension SessionsListPresenter: CustomNavigationBarDelegate {

    func backButtonTapped() {
        coordinator?.finish()
    }
}

// MARK: - Mock data
private extension SessionsListPresenter {

    func setupMockData() {
        sessions = SessionModel.mockData
    }
}
