//
//  RoulettePresenter.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 08.07.2024.
//

import Foundation

final class RoulettePresenter: RoulettePresenterProtocol {

    // MARK: - Public Properties

    weak var coordinator: RouletteCoordinator?
    weak var view: RouletteViewProtocol?

    var moviesCount: Int {
        totalElements = moviesArray.count + buffer
        return totalElements
    }

    // MARK: - Private Properties

    private var moviesArray = [SelectionMovieCellModel]()

    private let buffer = 200
    private var totalElements = Int()

    // MARK: - Initializers

    init(coordinator: RouletteCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Public methods

    func getMoviesAtIndex(index: Int) -> SelectionMovieCellModel {
        let safeIndex = index % moviesArray.count

        return moviesArray[safeIndex]
    }

    // Метод для имитации загрузки фильмов
    func downloadMoviesArray() {
        let downloadedMovies = selectionMovieMockData

        for movie in downloadedMovies {
            moviesArray.append(movie)
        }
    }
}
