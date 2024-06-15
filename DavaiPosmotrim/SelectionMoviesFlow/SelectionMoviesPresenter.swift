//
//  SelectionMoviesPresenter.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 15.06.24.
//

import Foundation

final class SelectionMoviesPresenter: SelectionMoviesPresenterProtocol {

    // MARK: - Public Properties

    weak var coordinator: SelectionMoviesCoordinator?

    // MARK: - Private Properties

    private var selectionsMovie = selectionMovieMockData
    private var currentIndex: Int = 0
    private var likedMovies: [UUID] = []
    private var currentMovieId: UUID?
    private var isGetPreviousMovie = true

    init(coordinator: SelectionMoviesCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Public Methods

    func getRandomMatchCount() -> Int {
        return Int.random(in: 0...10)
    }

    func canGetPreviousMovie() -> Bool {
        guard currentIndex > 0 else {
            return false
        }
        let likePreviousMovie = selectionsMovie[currentIndex - 1].id
        if likedMovies.contains(likePreviousMovie) {
            return false
        }
        return isGetPreviousMovie
    }

    func getCurrentMovieId() -> UUID? {
        return currentMovieId
    }

    func getFirstMovie() -> SelectionMovieCellModel? {
        let firstSelection = selectionsMovie.first
        self.currentMovieId = firstSelection?.id
        return firstSelection
    }

    func getNextMovie() -> SelectionMovieCellModel? {
        guard currentIndex < selectionsMovie.count else { return nil }
        currentIndex += 1
        currentMovieId = selectionsMovie[currentIndex].id
        isGetPreviousMovie = true
        return selectionsMovie[currentIndex]
    }

    func getPreviousMovie() -> SelectionMovieCellModel? {
        currentIndex -= 1
        currentMovieId = selectionsMovie[currentIndex].id
        isGetPreviousMovie = false
        return selectionsMovie[currentIndex]
    }

    func addToLikedMovies(withId id: UUID) {
        likedMovies.append(id)
    }

    func removeFromLikedMovies(withId id: UUID) {
        if likedMovies.contains(id) {
            likedMovies.removeAll { $0 == id }
        }
    }

    func didTapMatchRightButton() {
        coordinator?.showMatchFlow()
    }

    func backButtonTapped() {
        coordinator?.finish()
    }
}
