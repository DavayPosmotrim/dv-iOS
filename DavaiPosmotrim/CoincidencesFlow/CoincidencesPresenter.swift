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

    var moviesArray = [ReusableLikedMoviesCellModel]() {
        didSet {
            view?.updateUIElements()
        }
    }

    // MARK: - Initializers

    init(coordinator: CoincidencesCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Public methods

    func diceButtonTapped() {
        guard let coordinator else { return }
        coordinator.finish()
    }

    func getMoviesAtIndex(index: Int) -> ReusableLikedMoviesCellModel {
        moviesArray[index]
    }

    // Метод для имитации загрузки фильмов
    func downloadMoviesArrayFromServer() {
        let downloadedMovies = [
            ReusableLikedMoviesCellModel(title: "Into the wild", image: UIImage.mok7),
            ReusableLikedMoviesCellModel(title: "Дюна", image: UIImage.mok8),
            ReusableLikedMoviesCellModel(title: "Даласский клуб покупателей", image: UIImage.mok9),
            ReusableLikedMoviesCellModel(title: "Властелин колец: Две крепости", image: nil),
            ReusableLikedMoviesCellModel(title: "Into the wild", image: UIImage.mok7),
            ReusableLikedMoviesCellModel(title: "Дюна", image: UIImage.mok8),
            ReusableLikedMoviesCellModel(title: "Очень длинное название фильма. Такое длинное, что такие, наверное, просто не смотрят", image: UIImage.mok9),
            ReusableLikedMoviesCellModel(title: "Властелин колец: Братство кольца", image: nil),
            ReusableLikedMoviesCellModel(title: "1917", image: nil),
            ReusableLikedMoviesCellModel(title: "Грань будущего", image: nil),
            ReusableLikedMoviesCellModel(title: "Звездные войны: Возвращение джедая", image: nil),
            ReusableLikedMoviesCellModel(title: "Властелин колец: Возвращение короля", image: nil)
        ]

        for movie in downloadedMovies {
            self.moviesArray.append(movie)
        }
    }
}
