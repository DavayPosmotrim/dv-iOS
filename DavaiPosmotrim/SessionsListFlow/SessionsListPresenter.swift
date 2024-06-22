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
        let users = session.users.map { $0.name }.joined(separator: ", ")
        let matches = [Resources.SessionsList.Sessions.matchesTitle, String(session.matches)].joined(separator: " ")

        // UILabel.scaleToFit() doesn't work properly inside UITableView
        var matchesWidth: CGFloat
        switch session.matches {
        case 1: matchesWidth = 124
        case 2...9: matchesWidth = 126
        case 10...19: matchesWidth = 132
        case 20...99: matchesWidth = 135
        case 100...199: matchesWidth = 142
        case 200...999: matchesWidth = 145
        default: matchesWidth = 151
        }

        return SessionsListViewModel(
            date: session.date,
            users: users,
            matches: matches,
            matchesWidth: matchesWidth,
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
        sessions.append(SessionModel(
            date: "23 сентября 2023",
            matches: 1,
            imageName: "Mok_5",
            users: [User(name: "Артём (вы)"), User(name: "Анна"), User(name: "Никита"), User(name: "Руслан")]
        ))
        sessions.append(SessionModel(
            date: "22 сентября 2023",
            matches: 12,
            imageName: "Mok_6",
            users: [User(name: "Артём (вы)"), User(name: "Анна")]
        ))
        sessions.append(SessionModel(
            date: "20 сентября 2023",
            matches: 3,
            imageName: "Mok_3",
            users: [User(name: "Артём (вы)"), User(name: "Анна"), User(name: "Никита")]
        ))
        sessions.append(SessionModel(
            date: "22 сентября 2023",
            matches: 555,
            imageName: nil,
            users: [User(name: "Артём (вы)"), User(name: "Анна")]
        ))
    }
}
