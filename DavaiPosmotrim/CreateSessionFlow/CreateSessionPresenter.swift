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
    private let contentService: ContentServiceProtocol

    // MARK: - Private Properties

    private var createSession = CreateSessionModel(collectionsMovie: [], genresMovie: [])
    private var selectionsMovies: [TableViewCellModel] = []
    private var genresMovies: [CollectionsCellModel] = []

    init(coordinator: CreateSessionCoordinator, contentService: ContentServiceProtocol) {
        self.coordinator = coordinator
        self.contentService = contentService
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

    func didTapNextButton(segmentIndex: Int) {
        postCreatingSession(segmentIndex: segmentIndex)
        coordinator?.showInvitingUsersFlow()
    }
}

// MARK: - ContnetService Methods

extension CreateSessionPresenter {
    func getGenres(completion: @escaping () -> Void) {
            contentService.getGenres { result in
                switch result {
                case .success(let genres):
                    self.genresMovies = genres.map { CollectionsCellModel(title: $0.name) }
                    print("Genres retrieved: \(self.genresMovies)")
                    completion()
                case .failure(let error):
                    // TODO: - обработать ошибки
                    print("Failed to get genres: \(error.localizedDescription)")
                    completion()
                }
            }
        }

    func getCollections(completion: @escaping () -> Void) {
        contentService.getCollections { result in
            switch result {
            case .success(let collections):
                self.selectionsMovies = collections.map { TableViewCellModel(
                    title: $0.name,
                    movieImage: $0.cover ?? ""
                ) }
                print("Collections retrieved: \(collections)")
                completion()
            case .failure(let error):
                // TODO: - обработать ошибки
                print("Failed to get collections: \(error.localizedDescription)")
                completion()
            }
        }
    }

    private func postCreatingSession(segmentIndex: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())
        let status: StatusEnumModel = .waiting
        let genres: [String]
        let collections: [String]
        if segmentIndex == 0 {
            genres = []
            collections = createSession.collectionsMovie.map { $0.title }
        } else {
            genres = createSession.genresMovie.map { $0.title }
            collections = []
        }

        let requestModel = CustomSessionCreateRequestModel(
            date: currentDate,
            genres: genres,
            collections: collections,
            status: status
        )
        // TODO: - проверка на формирование POST запроса
        if let jsonData = try? JSONEncoder().encode(requestModel),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Создание сессии: \(jsonString)")
        } else {
            print("Не удалось преобразовать модель в JSON.")
        }
    }
}
