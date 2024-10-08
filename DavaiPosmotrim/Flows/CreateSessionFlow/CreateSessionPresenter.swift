//
//  CreateSessionPresenter.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 14.05.24.
//

import UIKit

final class CreateSessionPresenter: CreateSessionPresenterProtocol {

    // MARK: - Public Properties

    weak var coordinator: CreateSessionCoordinator?
    weak var view: CreateSessionViewProtocol?

    // MARK: - Private Properties

    private let contentService: ContentServiceProtocol
    private var sessionService: SessionServiceProtocol
    private var createSession = CreateSessionModel(collectionsMovie: [], genresMovie: [])
    private var selectionsMovies: [TableViewCellModel] = []
    private var genresMovies: [CollectionsCellModel] = []

    init(
        coordinator: CreateSessionCoordinator,
        contentService: ContentServiceProtocol,
        sessionService: SessionServiceProtocol = SessionService()
    ) {
        self.coordinator = coordinator
        self.contentService = contentService
        self.sessionService = sessionService

    }

    // MARK: - Public Methods

    func isSessionEmpty(segmentIndex: Int) -> Bool {
        if segmentIndex == 0 {
            return createSession.collectionsMovie.isEmpty
        } else {
            return createSession.genresMovie.isEmpty
        }
    }

    func getSelectionsMoviesCount() -> Int {
        return selectionsMovies.count
    }

    func getGenresMoviesCount() -> Int {
        return genresMovies.count
    }

    func getSelectionsMovie(index: Int) -> TableViewCellModel {
        return selectionsMovies[index]
    }

    func getGenreAtIndex(index: Int) -> CollectionsCellModel {
        return genresMovies[index]
    }

    func didAddCollection(id: UUID?) {
        guard let id,
              let collection = selectionsMovies.first(where: { $0.id == id }) else {
            return
        }
        let newCollection = CollectionsMovie(
            id: collection.id,
            slug: collection.slug,
            title: collection.title
        )
        createSession.collectionsMovie.append(newCollection)
    }

    func didRemoveCollection(id: UUID?) {
        guard let id else {
            return
        }
        createSession.collectionsMovie.removeAll { $0.id == id }
    }

    func didAddGenres(id: UUID?) {
        guard let id,
              let genres = genresMovies.first(where: { $0.id == id }) else {
            return
        }
        let newGenres = GenresMovie(id: genres.id, title: genres.title)
        createSession.genresMovie.append(newGenres)
    }

    func didRemoveGenres(id: UUID?) {
        guard let id else {
            return
        }
        createSession.genresMovie.removeAll { $0.id == id }
    }

    func backButtonTapped() {
        coordinator?.finish()
    }

    func didTapNextButton(segmentIndex: Int) {
        createSession(segmentIndex: segmentIndex) { isSuccess in
            self.view?.isServerReachable = isSuccess
            if isSuccess {
                self.coordinator?.showInvitingUsersFlow()
            } else {
                print("Failed to create session")
            }
        }
    }

    private func presentErrorAfterDelay(error: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            error()
        }
    }
}

    // MARK: - ContentService

extension CreateSessionPresenter {

    func getGenres(completion: @escaping (Bool) -> Void) {
        guard let deviceId = UserDefaults.standard.string(
            forKey: Resources.Authentication.savedDeviceID
        ) else { return }

        view?.showLoader()
        contentService.getGenres(with: deviceId) { result in
            DispatchQueue.main.async {
                self.view?.hideLoader()
                switch result {
                case .success(let genres):
                    completion(true)
                    self.genresMovies = genres.map { CollectionsCellModel(title: $0.name) }
                case .failure(let error):
                    switch error {
                    case .networkError:
                        self.presentErrorAfterDelay {
                            self.view?.showNetworkError()
                        }
                    case .serverError:
                        self.presentErrorAfterDelay {
                            self.view?.showServerError()
                        }
                    }
                    completion(false)
                }
            }
        }
    }

    func getCollections(completion: @escaping (Bool) -> Void) {
        guard let deviceId = UserDefaults.standard.string(
            forKey: Resources.Authentication.savedDeviceID
        ) else { return }

        view?.showLoader()
        contentService.getCollections(with: deviceId) { result in
            DispatchQueue.main.async {
                self.view?.hideLoader()
                switch result {
                case .success(let collections):
                    self.selectionsMovies = collections.map {
                        TableViewCellModel(
                            title: $0.name,
                            slug: $0.slug ?? "",
                            movieImage: $0.cover ?? ""
                        )
                    }
                    completion(true)
                case .failure(let error):
                    switch error {
                    case .networkError:
                        self.presentErrorAfterDelay {
                            self.view?.showNetworkError()
                        }
                    case .serverError:
                        self.presentErrorAfterDelay {
                            self.view?.showServerError()
                        }
                    }
                    completion(false)
                }
            }
        }
    }
}

    // MARK: - SessionService

extension CreateSessionPresenter {

    private func createSession(segmentIndex: Int, completion: @escaping (Bool) -> Void) {
        guard let deviceId = UserDefaults.standard.string(
            forKey: Resources.Authentication.savedDeviceID
        ) else { return }

        let genres: [String]
        let collections: [String]
        if segmentIndex == 0 {
            genres = []
            collections = createSession.collectionsMovie.map { $0.slug }
        } else {
            genres = createSession.genresMovie.map { $0.title }
            collections = []
        }

        let requestModel = CreateSessionRequestModel(genres: genres, collections: collections)

        view?.showLoader()
        sessionService.createSession(deviceId: deviceId, genresOrCollections: requestModel) { result in
            DispatchQueue.main.async {
                self.view?.hideLoader()
                switch result {
                case .success:
                    completion(true)
                case .failure(let error):
                    completion(false)
                    switch error {
                    case .networkError:
                        self.presentErrorAfterDelay {
                            self.view?.showNetworkError()
                        }
                    case .serverError:
                        self.presentErrorAfterDelay {
                            self.view?.showServerError()
                        }
                    }
                }
            }
        }
    }
}
