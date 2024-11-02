//
//  SessionMoviesPresenter.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 22.06.2024.
//

import Foundation

final class SessionMoviesPresenter: SessionMoviesPresenterProtocol {

    // MARK: - Public properties
    weak var coordinator: SessionsListCoordinator?
    weak var view: SessionMoviesViewControllerProtocol?
    var users: [ReusableCollectionCellModel] {
        session.users
    }
    var movies: [ReusableLikedMoviesCellModel] {
        session.movies
    }
    var sessionCode: String {
        [Resources.SessionsList.Movies.sessionTitle, session.code].joined(separator: " ")
    }
    var sessionDateForTitle: String {
        convertDateString(dateString: session.date)
    }

    // MARK: - Private properties
    private var session: SessionModel
    private var contentService: ContentServiceProtocol
    private var decodedMoviesForCells = [SelectionMovieCellModel]()
    private var matchedMovie: MovieDetailModel?

    // MARK: - Inits
    init(
        coordinator: SessionsListCoordinator?,
        session: SessionModel,
        contentService: ContentServiceProtocol = ContentService(),
        view: SessionMoviesViewControllerProtocol? = nil
    ) {
        self.coordinator = coordinator
        self.session = session
        self.contentService = contentService
        self.view = view
    }

    // MARK: - Public methods
    func viewDidLoad() {
        for movie in session.movies {
            getMovieInfo(movieId: movie.id) { isSuccess in
                if isSuccess {
                    guard let matchedMovie = self.matchedMovie else { return }
                    let decodedMovie = self.decodeMatchedMovie(for: matchedMovie)
                    self.decodedMoviesForCells.append(decodedMovie)
                }
            }
        }
    }

    func showMovie(by movieId: Int) {
        guard let viewModel = decodedMoviesForCells.first(where: { $0.id == movieId }) else { return }
        coordinator?.showMovieInfo(with: viewModel)
    }

    func decodeMatchedMovie(for matchedMovie: MovieDetailModel) -> SelectionMovieCellModel {
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
}

// MARK: - CustomNavigationBarDelegate
extension SessionMoviesPresenter: CustomNavigationBarDelegate {

    func backButtonTapped() {
        coordinator?.showPreviousScreen()
    }

    func getMatchedMoviesFromUserDefaults() -> [SelectionMovieCellModel] {
        guard
            let savedData = UserDefaults.standard.data(
                forKey: Resources.SelectionMovies.saveMatchedArray
            ),
            let decodedData = try? JSONDecoder().decode(
                [SelectionMovieCellModel].self,
                from: savedData
            )
        else { return [] }

        return decodedData
    }

    func convertDateString(dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = inputFormatter.date(from: dateString) else {
            return ""
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM"
        outputFormatter.locale = Locale(identifier: "ru_RU")

        return outputFormatter.string(from: date)
    }
}

    // MARK: - Private methods

private extension SessionMoviesPresenter {

    private func triggerActionAfterDelay(error: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            error()
        }
    }

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
