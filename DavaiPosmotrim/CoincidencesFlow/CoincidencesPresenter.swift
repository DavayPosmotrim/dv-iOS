//
//  CoincidencesPresenter.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 12.06.2024.
//

import UIKit

final class CoincidencesPresenter: CoincidencesPresenterProtocol {

    // MARK: - Public Properties

    weak var coordinator: CoincidencesCoordinator?
    weak var view: CoincidencesViewProtocol?

    var moviesCount: Int {
        moviesArray.count
    }

    var isArrayEmpty: Bool {
        moviesArray.isEmpty
    }

    // MARK: - Private Properties

    private var moviesArray = [ReusableLikedMoviesCellModel]() {
        didSet {
            view?.updateUIElements()
        }
    }

    // MARK: - Initializers

    init(coordinator: CoincidencesCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Public methods

    func backButtonTapped() {
        guard let coordinator else { return }
        coordinator.finish()
    }

    func diceButtonTapped() {
        guard let coordinator else { return }
        // TODO: add code to jump to RouletteFlow
    }

    func getMoviesAtIndex(index: Int) -> ReusableLikedMoviesCellModel {
        moviesArray[index]
    }

    // Метод для имитации загрузки фильмов
    func downloadMoviesArrayFromServer() {
        let downloadedMovies = [
            ReusableLikedMoviesCellModel(title: "Into the wild", imageName: "Mok_7"),
            ReusableLikedMoviesCellModel(title: "Дюна", imageName: "Mok_8"),
            ReusableLikedMoviesCellModel(title: "Даласский клуб покупателей", imageName: "Mok_9"),
            ReusableLikedMoviesCellModel(title: "Властелин колец: Две крепости", imageName: nil),
            ReusableLikedMoviesCellModel(title: "Into the wild", imageName: "Mok_7"),
            ReusableLikedMoviesCellModel(title: "Дюна", imageName: "Mok_8"),
            ReusableLikedMoviesCellModel(title: "Очень длинное название фильма. Такое длинное, что такие, наверное, просто не смотрят", imageName: "Mok_9"),
            ReusableLikedMoviesCellModel(title: "Властелин колец: Братство кольца", imageName: nil),
            ReusableLikedMoviesCellModel(title: "1917", imageName: nil),
            ReusableLikedMoviesCellModel(title: "Грань будущего", imageName: nil),
            ReusableLikedMoviesCellModel(title: "Звездные войны: Возвращение джедая", imageName: "Mok_8"),
            ReusableLikedMoviesCellModel(title: "Властелин колец: Возвращение короля", imageName: "Mok_7")
        ]

        for movie in downloadedMovies {
            self.moviesArray.append(movie)
        }
    }

    // TODO: - rewrite method to get movie from UserDefaults according to it's id

    func getMovieInfo(from array: [SelectionMovieCellModel]) -> SelectionMovieCellModel? {
        return array.randomElement()
    }
}
