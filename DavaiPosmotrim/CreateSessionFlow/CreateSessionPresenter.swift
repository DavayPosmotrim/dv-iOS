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
    private let genresService: GenresServiceProtocol

    // MARK: - Private Properties

    private var createSession = CreateSessionModel(collectionsMovie: [], genresMovie: [])
    private var selectionsMovies = selectionsMockData
    private var genresMovies = genreMockData

    init(coordinator: CreateSessionCoordinator, genresService: GenresServiceProtocol) {
        self.coordinator = coordinator
        self.genresService = genresService
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
        getGenres()
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

    func didTapNextButton() {
        coordinator?.showInvitingUsersFlow()
    }
}

// MARK: - GenresService Methods

extension CreateSessionPresenter {
    func getGenres() {
        genresService.getGenres { result in
            switch result {
            case .success(let genres):
                // TODO: - передать жанры в массив, отобразить на экране
                print("Genres retrieved: \(genres)")
            case .failure(let error):
                // TODO: - обработать ошибки
                print("Failed to get genres: \(error.localizedDescription)")
            }
        }
    }
}
