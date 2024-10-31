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

    private var sessionService: SessionServiceProtocol
    private var contentService: ContentServiceProtocol
    private var matchedMovie: MovieDetailModel?
    private var matchedMovies: [MovieResponseModel]?
    private var decodedMoviesForCells = [SelectionMovieCellModel]()

    private let delayInSeconds: TimeInterval = 1

    private var moviesArray = [ReusableLikedMoviesCellModel]() {
        didSet {
            view?.updateUIElements()
            DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
                self.showRouletteOnboarding()
            }
        }
    }

    // MARK: - Initializers

    init(
        coordinator: CoincidencesCoordinator,
        contentService: ContentServiceProtocol = ContentService(),
        sessionService: SessionServiceProtocol = SessionService()
    ) {
        self.coordinator = coordinator
        self.contentService = contentService
        self.sessionService = sessionService
    }

    // MARK: - Public methods

    func backButtonTapped() {
        guard let coordinator else { return }
        coordinator.finish()
    }

    func diceButtonTapped() {
        guard let coordinator else { return }
        coordinator.showRouletteFlow()
    }

    func coincidencesCellTapped(for movieId: Int) {
        guard let coordinator, let viewModel = decodedMoviesForCells.first(where: { $0.id == movieId })
        else { return }
            coordinator.showCoincidencesInfo(with: viewModel)
    }

    func getMoviesAtIndex(index: Int) -> ReusableLikedMoviesCellModel {
        moviesArray[index]
    }

    func downloadMatchedMoviesArray() {
        view?.showLoader()
        getSessionMatchedMovies { isSuccess in
            self.view?.isServerReachable = isSuccess
            if isSuccess {
                guard let matchedMovies = self.matchedMovies else { return }
                self.decodeMatchedMoviesArray(for: matchedMovies)
                for movie in matchedMovies {
                    self.getMovieInfo(movieId: movie.id) { isSuccess in
                        if isSuccess {
                            guard let matchedMovie = self.matchedMovie else { return }
                            let decodedMovie = self.decodeMatchedMovie(for: matchedMovie)
                            self.decodedMoviesForCells.append(decodedMovie)
                        }
                    }
                }
            }
        }
    }

    func showRouletteOnboarding() {
        guard let coordinator else { return }
        if UserDefaults.standard.value(forKey: Resources.RouletteFlow.isRouletteOnboardingShown) == nil &&
            moviesCount >= 3 {
            coordinator.showRouletteOnboarding()
        }
    }

    // MARK: - Private methods

    private func triggerActionAfterDelay(error: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            error()
        }
    }

    private func decodeMatchedMovie(for matchedMovie: MovieDetailModel) -> SelectionMovieCellModel {
        var genres = [CollectionsCellModel]()
        for item in matchedMovie.genres {
            let genre = CollectionsCellModel(title: item.name)
            genres.append(genre)
        }

        let movie = SelectionMovieCellModel(
            id: matchedMovie.id,
            movieImage: matchedMovie.poster,
            nameMovieRu: matchedMovie.name,
            ratingMovie: matchedMovie.ratingKp,
            nameMovieEn: matchedMovie.alternativeName ?? "",
            yearMovie: matchedMovie.year,
            countryMovie: matchedMovie.countries,
            timeMovie: matchedMovie.movieLength,
            genre: genres,
            details: SelectionMovieDetailsCellModel(
                description: matchedMovie.description,
                ratingKp: matchedMovie.ratingKp,
                ratingImdb: matchedMovie.ratingImdb,
                votesKp: matchedMovie.votesKp,
                votesImdb: matchedMovie.votesImdb,
                directors: matchedMovie.directors,
                actors: matchedMovie.actors
            )
        )
        return movie
    }

    private func decodeMatchedMoviesArray(for array: [MovieResponseModel]) {
        for movie in array {
            let decodedMovie = ReusableLikedMoviesCellModel(
                id: movie.id,
                title: movie.name,
                imageName: movie.poster
            )
            moviesArray.append(decodedMovie)
        }
    }
}

    // MARK: - ContentService

private extension CoincidencesPresenter {

    func getMovieInfo(movieId: Int, completion: @escaping (Bool) -> Void) {
        guard
            let deviceId = UserDefaults.standard.string(
                forKey: Resources.Authentication.savedDeviceID)
        else { return }

        contentService.getMovieInfo(with: movieId, deviceId: deviceId) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.matchedMovie = response
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

    // MARK: - SessionService

private extension CoincidencesPresenter {

    func getSessionMatchedMovies(completion: @escaping (Bool) -> Void) {
        guard
            let deviceId = UserDefaults.standard.string(
                forKey: Resources.Authentication.savedDeviceID),
            let sessionCode = UserDefaults.standard.string(
                forKey: Resources.Authentication.sessionCode
            )
        else { return }

        sessionService.getSessionMatchedMovies(
            sessionCode: sessionCode,
            deviceId: deviceId
        ) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.matchedMovies = response
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
