//
//  SessionMoviesPresenter.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 22.06.2024.
//

import Foundation

final class SessionMoviesPresenter: SessionMoviesPresenterProtocol {

    // MARK: - Public properties
    var coordinator: SessionsListCoordinator?
    var session: SessionModel
    var view: SessionMoviesViewControllerProtocol?

    // MARK: - Private properties

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
        setupMockData()
    }

    func showMovie(by sessionIndex: Int) {
        print(#fileID, #function)
    }
}

// MARK: - CustomNavigationBarDelegate
extension SessionMoviesPresenter: CustomNavigationBarDelegate {

    func backButtonTapped() {
        coordinator?.finish()
    }
}

// MARK: - Mock data
private extension SessionMoviesPresenter {

    func setupMockData() {
        // code will be here
    }
}
