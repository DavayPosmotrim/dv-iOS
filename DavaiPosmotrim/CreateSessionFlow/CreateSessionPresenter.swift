//
//  CreateSessionPresenter.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 14.05.24.
//

import UIKit

final class CreateSessionPresenter: CreateSessionPresenterProtocol {

    // MARK: - Public Properties

    var isSessionEmpty: Bool {
        return createSession.collectionsMovie.isEmpty && createSession.genresMovie.isEmpty
    }

    // MARK: - Private Properties

    private var createSession = CreateSessionModel(collectionsMovie: [], genresMovie: [])
    private var selectionsMovies = selectionsMockData
    private var genresMovies = genreMockData

    // MARK: - Public Methods

    func getSelectionsMoviesCount() -> Int {
        return selectionsMovies.count
    }

    func getGenresMoviesCount() -> Int {
        return genreMockData.count
    }

    func getSelectionsMovie(index: Int) -> TableViewCellModel {
        return selectionsMovies[index]
    }

    func getGenreAtIndex(index: Int) -> CollectionsCellModel {
        return genreMockData[index]
    }

    func didAddCollection(id: UUID?) {
        guard let id,
        let collection = selectionsMovies.first(where: { $0.id == id }) else {
            return
        }
        let newCollection = CollectionsMovie(id: collection.id, title: collection.title)
        createSession.collectionsMovie.append(newCollection)
        print(createSession)
    }

    func didRemoveCollection(id: UUID?) {
        guard let id else {
            return
        }
        createSession.collectionsMovie.removeAll { $0.id == id }
        print(createSession)
    }

    func didAddGenres(id: UUID?) {
        guard let id,
        let genres = genresMovies.first(where: { $0.id == id }) else {
            return
        }
        let newGenres = GenresMovie(id: genres.id, title: genres.title)
        createSession.genresMovie.append(newGenres)
        print(createSession)
    }

    func didRemoveGenres(id: UUID?) {
        guard let id else {
            return
        }
        createSession.genresMovie.removeAll { $0.id == id }
        print(createSession)
    }

    func showPreviousScreen(navigationController: UINavigationController?) {
        guard let navigationController = navigationController else { return }
        navigationController.popViewController(animated: true)
    }

    func showNextScreen(navigationController: UINavigationController?) {
        guard let navigationController = navigationController else { return }
        let invitingUsersViewController = InvitingUsersViewController()
        navigationController.pushViewController(invitingUsersViewController, animated: true)
    }
}
