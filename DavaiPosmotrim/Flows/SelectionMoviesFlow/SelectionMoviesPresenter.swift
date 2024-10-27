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

    private var selectionsMovie = [SelectionMovieCellModel]()
    private var currentIndex: Int = 0
    private var likedMovies: [Int] = []
    private(set) var currentMovieId: Int?
    private var isGetPreviousMovie = true
    // TODO: - для теста showMatch() пока нет сети
    private var moviesViewedCount: Int = 0
    private var matchCount: Int = 0
    private let contentService: ContentServiceProtocol

    private var firstMovie: MovieDetailModel?
    private var newMovie: MovieDetailModel?
    private var downloadedMoviesList: [Int]?
    private let pageSize: Int = 20
    private var currentPage: Int = 1
    private var isLoading = false

    init(
        coordinator: SelectionMoviesCoordinator,
        contentService: ContentServiceProtocol = ContentService()
    ) {
        self.coordinator = coordinator
        self.contentService = contentService

        firstMovie = getFirstMovieFromUserDefaults()
        downloadedMoviesList = getMoviesListFromUserDefaults()
    }

    // MARK: - Public Methods

    func loadData() {
        guard !isLoading else { return }
        isLoading = true

        self.currentPage = 1
        self.loadMoviesForCurrentPage()
    }

    func loadMoviesForCurrentPage() {
        guard let downloadedMoviesList else { return }
        let startIndex = (currentPage - 1) * pageSize
        let endIndex = min(startIndex + pageSize, downloadedMoviesList.count)

        guard startIndex < downloadedMoviesList.count else { return }

        let idsToLoad = downloadedMoviesList[startIndex..<endIndex]
        for item in idsToLoad {
            self.getMovieInfo(for: item) { isSuccess in
                self.view?.isServerReachable = isSuccess
                if isSuccess {
                    guard let newMovie = self.newMovie else { return }

                    let movie = self.decodeNewMovie(for: newMovie)
                    self.selectionsMovie.append(movie)
                    print(self.selectionsMovie.count)
                }
            }
        }
    }

    func loadNextPage() {
        guard let downloadedMoviesList else { return }
        let totalPages = (downloadedMoviesList.count + pageSize - 1) / pageSize
        guard currentPage < totalPages else { return }
        currentPage += 1
        loadMoviesForCurrentPage()
    }

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
        if selectionsMovie.isEmpty {
            checkSourceArray()
        }

        let firstSelection = selectionsMovie[currentIndex]
        currentMovieId = firstSelection.id
        return firstSelection
    }

    func noButtonTapped(withId id: Int) {
        removeFromLikedMovies(withId: id)
        view?.animateOffscreen(direction: -1) { [self] in
            guard let nextModel = getNextMovie() else {
                return
            }
            view?.showNextMovie(nextModel)
        }
    }

    func yesButtonTapped(withId id: Int) {
        addToLikedMovies(withId: id)
        view?.animateOffscreen(direction: 1) { [self] in
            checkIfIndexesMatch(withId: id)
            guard let nextModel = getNextMovie() else {
                return
            }
            view?.showNextMovie(nextModel)
        }
    }

    func checkIfIndexesMatch(withId id: Int) {
        // TODO: - для теста showMatch() пока нет сети
        moviesViewedCount += 1
        if moviesViewedCount == 2 && currentMovieId == id {
            view?.showMatch(matchModel: selectionsMovie[currentIndex])
        }
    }

    func swipeNextMovie(withId id: Int, direction: CGFloat) {
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

    func addToLikedMovies(withId id: Int) {
        likedMovies.append(id)
    }

    func removeFromLikedMovies(withId id: Int) {
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

    // MARK: - Private methods

    private func triggerActionAfterDelay(action: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            action()
        }
    }

    private func getNextMovie() -> SelectionMovieCellModel? {
        guard currentIndex < selectionsMovie.count - 1 else { return nil }
        currentIndex += 1
        currentMovieId = selectionsMovie[currentIndex].id
        isGetPreviousMovie = true

        if currentIndex + 1 == selectionsMovie.count - 5 {
            loadNextPage()
        }

        return selectionsMovie[currentIndex]
    }

    private func getPreviousMovie() -> SelectionMovieCellModel? {
        currentIndex -= 1
        currentMovieId = selectionsMovie[currentIndex].id
        isGetPreviousMovie = false
        return selectionsMovie[currentIndex]
    }

    private func getMoviesListFromUserDefaults() -> [Int] {
        guard
            let savedData = UserDefaults.standard.data(
                forKey: Resources.CreateSession.savedMoviesList
            ),
            let decodedMovies = try? JSONDecoder().decode(
                [Int].self,
                from: savedData
            )
        else { return [] }

        return decodedMovies
    }

    private func getFirstMovieFromUserDefaults() -> MovieDetailModel? {
        guard
            let savedData = UserDefaults.standard.data(
                forKey: Resources.CreateSession.savedFirstMovie
            ),
            let decodedMovies = try? JSONDecoder().decode(
                MovieDetailModel.self,
                from: savedData
            )
        else { return nil }

        return decodedMovies
    }

    private func decodeNewMovie(for newMovie: MovieDetailModel) -> SelectionMovieCellModel {
        var genres = [CollectionsCellModel]()
        for item in newMovie.genres {
            let genre = CollectionsCellModel(title: item.name)
            genres.append(genre)
        }

        let movie = SelectionMovieCellModel(
            id: newMovie.id,
            movieImage: newMovie.poster,
            nameMovieRu: newMovie.name,
            ratingMovie: newMovie.ratingKp,
            nameMovieEn: newMovie.alternativeName ?? "",
            yearMovie: newMovie.year,
            countryMovie: newMovie.countries,
            timeMovie: newMovie.movieLength,
            genre: genres,
            details: SelectionMovieDetailsCellModel(
                description: newMovie.description,
                ratingKp: newMovie.ratingKp,
                ratingImdb: newMovie.ratingImdb,
                votesKp: newMovie.votesKp,
                votesImdb: newMovie.votesImdb,
                directors: newMovie.directors,
                actors: newMovie.actors
            )
        )

        return movie
    }

    private func checkSourceArray() {
        guard let firstMovie else { return }
        let decodedMovie = decodeNewMovie(for: firstMovie)
        selectionsMovie.append(decodedMovie)
    }
}

    // MARK: - ContentService

extension SelectionMoviesPresenter {

    func getMovieInfo(for id: Int, completion: @escaping (Bool) -> Void) {
        guard
            let deviceId = UserDefaults.standard.string(
                forKey: Resources.Authentication.savedDeviceID)
        else { return }

        contentService.getMovieInfo(with: id, deviceId: deviceId) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.newMovie = response
                    completion(true)
                case .failure(let error):
                    completion(false)
                    switch error {
                    case .networkError:
                        self.triggerActionAfterDelay {
                            self.view?.showNetworkError()
                        }
                    case .serverError:
                        self.triggerActionAfterDelay {
                            self.view?.showServerError()
                        }
                    }
                }
            }
        }
    }
}
