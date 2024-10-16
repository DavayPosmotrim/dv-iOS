//
//  SessionMoviesPresenter.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 22.06.2024.
//

import Foundation

final class SessionMoviesPresenter: SessionMoviesPresenterProtocol {

    // MARK: - Public properties
    weak var coordinator: SessionsListCoordinator?
    weak var view: SessionMoviesViewControllerProtocol?
    var users: [ReusableCollectionCellModel] {
        session.users
    }
    var movies: [ReusableLikedMoviesCellModel] {
        session.movies
    }
    var sessionCode: String {
        [Resources.SessionsList.Movies.sessionTitle, session.code].joined(separator: " ")
    }
    var sessionDateForTitle: String {
        String(session.date.dropLast(5))
    }

    // MARK: - Private properties
    private var session: SessionModel

    // MARK: - Inits
    init(
        coordinator: SessionsListCoordinator?,
        session: SessionModel,
        view: SessionMoviesViewControllerProtocol? = nil
    ) {
        self.coordinator = coordinator
        self.session = session
        self.view = view
    }

    // MARK: - Public methods
    func viewDidLoad() {
        // TODO: - add code later
    }

    func showMovie(by sessionIndex: Int) {
        // TODO: - change mock data later
        if sessionIndex > selectionMovieMockData.count - 1 { return }
        let viewModel = selectionMovieMockData[sessionIndex]

        coordinator?.showMovieInfo(with: viewModel)
    }
}

// MARK: - CustomNavigationBarDelegate
extension SessionMoviesPresenter: CustomNavigationBarDelegate {

    func backButtonTapped() {
        coordinator?.showPreviousScreen()
    }
}
