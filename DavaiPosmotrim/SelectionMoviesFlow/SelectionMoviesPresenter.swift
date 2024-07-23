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
    weak var view: SelectionMoviesViewProtocol?

    // MARK: - Private Properties

    private var selectionsMovie = selectionMovieMockData
    private var currentIndex: Int = 0
    private var likedMovies: [UUID] = []
    private(set) var currentMovieId: UUID?
    private var isGetPreviousMovie = true
    // TODO: - для теста showMatch() пока нет сети
    private var moviesViewedCount: Int = 0
    private var matchCount: Int = 0

    init(coordinator: SelectionMoviesCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Public Methods

    func updateRandomMatchCount() {
        matchCount += 1
        view?.updateMatchCountLabel(withRandomCount: matchCount)
    }

    func comeBackButtonTapped() {
        if canGetPreviousMovie() {
            guard let nextModel = getPreviousMovie() else {
                return
            }
            view?.showPreviousMovie(nextModel)
        }
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

    func getFirstMovie() -> SelectionMovieCellModel {
        let firstSelection = selectionsMovie[currentIndex]
        currentMovieId = firstSelection.id
        return firstSelection
    }

    func noButtonTapped(withId id: UUID) {
        removeFromLikedMovies(withId: id)
        view?.animateOffscreen(direction: -1) { [self] in
            guard let nextModel = getNextMovie() else {
                return
            }
            view?.showNextMovie(nextModel)
        }
    }

    func yesButtonTapped(withId id: UUID) {
        addToLikedMovies(withId: id)
        view?.animateOffscreen(direction: 1) { [self] in
            checkIfIndexesMatch(withId: id)
            guard let nextModel = getNextMovie() else {
                return
            }
            view?.showNextMovie(nextModel)
        }
    }

    func checkIfIndexesMatch(withId id: UUID) {
        // TODO: - для теста showMatch() пока нет сети
        moviesViewedCount += 1
        if moviesViewedCount == 2 && currentMovieId == id {
            view?.showMatch(matchModel: selectionsMovie[currentIndex])
        }
    }

    func swipeNextMovie(withId id: UUID, direction: CGFloat) {
        if direction > 0 {
            addToLikedMovies(withId: id)
            checkIfIndexesMatch(withId: id)
        } else {
            removeFromLikedMovies(withId: id)
        }
        guard let nextModel = getNextMovie() else {
            return
        }
        view?.showNextMovie(nextModel)
    }

    func getNextMovie() -> SelectionMovieCellModel? {
        guard currentIndex < selectionsMovie.count - 1 else { return nil }
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

    func cancelButtonTapped() {
        view?.showCancelSessionDialog(alertType: .twoButtons)
    }

    func cancelButtonAlertTapped() {
        coordinator?.finish()
    }

    func kickOutAll() {
        //TODO: - настроить отмену сессии у остальных пользователей, когда подключим сеть
        view?.showCancelSessionDialog(alertType: .oneButton)
    }
}
