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
    private(set) var sessions: [SessionModel]

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
        decodeSessions()
        updateView()
    }

    func updateView() {
        view?.showListOrEmptyView()
    }

    func showSessionMovies(by sessionIndex: Int) {
        coordinator?.showMovies(for: sessions[sessionIndex])
    }
}

// MARK: - CustomNavigationBarDelegate
extension SessionsListPresenter: CustomNavigationBarDelegate {

    func backButtonTapped() {
        coordinator?.finish()
    }
}

// MARK: - Load data
private extension SessionsListPresenter {

    func getSavedSessions() -> [SessionResultModel] {
        guard
            let savedData = UserDefaults.standard.data(
                forKey: Resources.SessionsList.savedSessionResult
            ),
            let decodedSessions = try? JSONDecoder().decode(
                [SessionResultModel].self,
                from: savedData
            )
        else { return [] }

        return decodedSessions
    }

    private func getConnectedUsers() -> [ReusableCollectionCellModel] {
        guard
            let savedData = UserDefaults.standard.data(
                forKey: Resources.InvitingSession.savedUsersArray
            ),
            let decodedUsers = try? JSONDecoder().decode(
                [ReusableCollectionCellModel].self,
                from: savedData
            )
        else { return [] }

        return decodedUsers
    }

    func decodeSessions() {
        guard let userName = UserDefaults.standard.string(
            forKey: Resources.Authentication.savedNameUserDefaultsKey
        ) else { return }

        let sessionsArray = getSavedSessions()

        for session in sessionsArray {
            var names = [ReusableCollectionCellModel]()
            for user in session.users {
                let newUser = ReusableCollectionCellModel(id: "", title: user.name)
                names.append(newUser)
            }

            if let index = names.firstIndex(where: { $0.title == userName }) {
                let updatedUser = names[index].title + Resources.InvitingSession.creatorUserMark
                names[index].title = updatedUser
                let userToMove = names.remove(at: index)
                names.insert(userToMove, at: 0)
            }

            var matchedMovies = [ReusableLikedMoviesCellModel]()
            for movie in session.matchedMovies {
                let newMovie = ReusableLikedMoviesCellModel(
                    id: movie.id,
                    title: movie.name,
                    imageName: movie.poster
                )
                matchedMovies.append(newMovie)
            }

            let newSession = SessionModel(
                code: session.id,
                date: session.date,
                matches: session.matchedMoviesCount,
                imageName: session.image,
                users: names,
                movies: matchedMovies
            )
            sessions.append(newSession)
        }
    }
}
