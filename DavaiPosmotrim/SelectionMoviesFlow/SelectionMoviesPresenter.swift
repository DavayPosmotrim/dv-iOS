//
//  SelectionMoviesPresenter.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 15.06.24.
//

import Foundation

final class SelectionMoviesPresenter: SelectionMoviesPresenterProtocol {

    // MARK: - Private Properties

    private var selectionsMovie = selectionMovieMockData
    private var currentIndex: Int = 0
    private var likedMovies: [UUID] = []

    // MARK: - Public Methods

    func getRandomMatchCount() -> Int {
        return Int.random(in: 0...10)
    }

    func getFirstMovie() -> SelectionMovieCellModel? {
        return selectionsMovie.first
    }

    func getNextMovie() -> SelectionMovieCellModel? {
        guard currentIndex < selectionsMovie.count else { return nil }
        currentIndex += 1
        return selectionsMovie[currentIndex]
    }

    func getPreviousMovie() -> SelectionMovieCellModel? {
        guard currentIndex > 0 else { return nil }
        currentIndex -= 1
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
}
