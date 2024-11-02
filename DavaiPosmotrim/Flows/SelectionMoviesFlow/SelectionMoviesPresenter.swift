//
//  SelectionMoviesPresenter.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 15.06.24.
//

import Foundation

// swiftlint: disable file_length
// swiftlint: disable type_body_length

final class SelectionMoviesPresenter: SelectionMoviesPresenterProtocol {

    // MARK: - Public Properties

    weak var coordinator: SelectionMoviesCoordinator?
    weak var view: SelectionMoviesViewProtocol?

    // MARK: - Private Properties

    private var selectionsMovie = [SelectionMovieCellModel]()
    private var matchedMovies = [SelectionMovieCellModel]()
    private var sessionResultArray = [SessionResultModel]()
    private var currentIndex: Int = 0
    private var likedMovies: [Int] = []
    private var dislikedMovies: [Int] = []
    private(set) var currentMovieId: Int?
    private var isGetPreviousMovie = true
    private var matchCount: Int = 0
    private var contentService: ContentServiceProtocol
    private var sessionService: SessionServiceProtocol
    private var webSocketsManager: WebSocketsManager?

    private var firstMovie: MovieDetailModel?
    private var newMovie: MovieDetailModel?
    private var downloadedMoviesList: [Int]?
    private let pageSize: Int = 20
    private var currentPage: Int = 1
    private var isLoading = false

    private var sessionStatus: String? {
        didSet {
            let closedStatus = SessionStatusModel.closed.rawValue
            if sessionStatus == closedStatus {
                if rouletteMovieId != nil {
                    DispatchQueue.main.async {
                        self.coordinator?.showRouletteFlow()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.kickOutAll()
                    }
                }
                webSocketsManager?.disconnect()
            }
        }
    }

    private var rouletteMovieId: Int? {
        didSet {
            UserDefaults.standard.set(
                rouletteMovieId,
                forKey: Resources.RouletteFlow.savedRouletteMovieId
            )
        }
    }

    // MARK: - Initializers

    init(
        coordinator: SelectionMoviesCoordinator,
        contentService: ContentServiceProtocol = ContentService(),
        sessionService: SessionServiceProtocol = SessionService()
    ) {
        self.coordinator = coordinator
        self.contentService = contentService
        self.sessionService = sessionService

        firstMovie = getFirstMovieFromUserDefaults()
        downloadedMoviesList = getMoviesListFromUserDefaults()
    }

    // MARK: - Public Methods

    func connectToWebSockets() {
        connectToWebSocket(type: .matchesWebSocket)
        connectToWebSocket(type: .sessionStatusWebSocket)
        connectToWebSocket(type: .rouletteWebSocket)
        connectToWebSocket(type: .sessionResultWebSocket)
    }

    func loadData() {
        guard !isLoading else { return }
        isLoading = true

        if let firstMovieId = firstMovie?.id,
           let indexToRemove = downloadedMoviesList?.firstIndex(of: firstMovieId) {
            downloadedMoviesList?.remove(at: indexToRemove)
        }

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
        addToDislikedMovies(with: id)
        view?.animateOffscreen(direction: -1) { [self] in
            guard let nextModel = getNextMovie() else {
                return
            }
            view?.showNextMovie(nextModel)
        }
    }

    func yesButtonTapped(withId id: Int) {
        let stringId = "\(id)"
        putLikeToMovieInSession(movieId: stringId) { isSuccess in
            if isSuccess {
                self.addToLikedMovies(withId: id)
                self.view?.animateOffscreen(direction: 1) { [self] in
                    guard let nextModel = getNextMovie() else {
                        return
                    }
                    view?.showNextMovie(nextModel)
                }
            }
        }
    }

    func swipeNextMovie(withId id: Int, direction: CGFloat) {
        let stringId = "\(id)"
        if direction > 0 {
            putLikeToMovieInSession(movieId: stringId) { isSuccess in
                if isSuccess {
                    self.addToLikedMovies(withId: id)
                }
            }
        } else {
            addToDislikedMovies(with: id)
        }
        guard let nextModel = getNextMovie() else {
            return
        }
        view?.showNextMovie(nextModel)
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
        disconnectUserFromSession { isSuccess in
            self.view?.isServerReachable = isSuccess
            if isSuccess {
                self.view?.showCancelSessionDialog(alertType: .oneButton)
            }
        }
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

    private func addToLikedMovies(withId id: Int) {
        likedMovies.append(id)
    }

    private func addToDislikedMovies(with id: Int) {
        dislikedMovies.append(id)
    }

    private func removeFromDislikedMovies(withId id: Int) {
        if dislikedMovies.contains(id) {
            dislikedMovies.removeAll { $0 == id }
        }
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

    private func saveMatchedArray(with matchedMovie: SelectionMovieCellModel) {
        if let savedData = UserDefaults.standard.data(forKey: Resources.SelectionMovies.saveMatchedArray),
           let decodedData = try? JSONDecoder().decode([SelectionMovieCellModel].self, from: savedData) {
            matchedMovies = decodedData
        }
        matchedMovies.append(matchedMovie)
        guard let encodedData = try? JSONEncoder().encode(matchedMovies) else { return }
        UserDefaults.standard.set(
            encodedData,
            forKey: Resources.SelectionMovies.saveMatchedArray
        )
    }

    private func saveSessions(with sessionResult: SessionResultModel) {
        if let savedData = UserDefaults.standard.data(forKey: Resources.SessionsList.savedSessionResult),
           let decodedData = try? JSONDecoder().decode([SessionResultModel].self, from: savedData) {
            sessionResultArray = decodedData
        }
        sessionResultArray.append(sessionResult)
        guard let encodedData = try? JSONEncoder().encode(sessionResultArray) else { return }
        UserDefaults.standard.set(
            encodedData,
            forKey: Resources.SessionsList.savedSessionResult
        )
    }
}

    // MARK: - SessionService

private extension SelectionMoviesPresenter {

    func putLikeToMovieInSession(movieId: String, completion: @escaping (Bool) -> Void) {
        guard
            let deviceId = UserDefaults.standard.string(
                forKey: Resources.Authentication.savedDeviceID
            ),
            let sessionCode = UserDefaults.standard.string(
                forKey: Resources.Authentication.sessionCode
            )
        else { return }

        sessionService.putLikeToMovieInSession(
            sessionCode: sessionCode,
            deviceId: deviceId,
            movieId: movieId
        ) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    completion(true)
                case .failure(let error):
                    print(error.localizedDescription)
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

    func disconnectUserFromSession(completion: @escaping (Bool) -> Void) {
        guard
            let deviceId = UserDefaults.standard.string(
                forKey: Resources.Authentication.savedDeviceID
            ),
            let sessionCode = UserDefaults.standard.string(
                forKey: Resources.Authentication.sessionCode
            )
        else { return }

        sessionService.disconnectUserFromSession(
            sessionCode: sessionCode,
            deviceId: deviceId
        ) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
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

    // MARK: - ContentService

private extension SelectionMoviesPresenter {

    func getMovieInfo(for id: Int, completion: @escaping (Bool) -> Void) {
        guard let deviceId = UserDefaults.standard.string(
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

    // MARK: - WebSocketsManager

private extension SelectionMoviesPresenter {

    // swiftlint: disable function_body_length
    // swiftlint: disable cyclomatic_complexity

    func connectToWebSocket(type: WebSocketType) {
        guard let sessionID = UserDefaults.standard.string(
            forKey: Resources.Authentication.sessionCode
        ) else {
            return
        }

        let messageHandler: (String) -> Void = { [weak self] message in
            guard let data = message.data(using: .utf8),
                  let self
            else { return }
            do {
                switch type {
                case .matchesWebSocket:
                    let decodedData = try JSONDecoder().decode(WebSocketsMovieIDModel.self, from: data)
                    let matchedId = decodedData.message
                    if let matchedMovie = selectionsMovie.first(where: { $0.id == matchedId }) {
                        saveMatchedArray(with: matchedMovie)
                        DispatchQueue.main.async { [self] in
                            self.view?.showMatch(matchModel: matchedMovie)
                        }
                    }
                case .sessionStatusWebSocket:
                    let decodedData = try JSONDecoder().decode(WebSocketsSessionStatusModel.self, from: data)
                    sessionStatus = decodedData.message
                case .rouletteWebSocket:
                    let decodedData = try JSONDecoder().decode(WebSocketsMovieIDModel.self, from: data)
                    rouletteMovieId = decodedData.message
                case .sessionResultWebSocket:
                    let decodedData = try JSONDecoder().decode(WebSocketsSessionResultModel.self, from: data)
                    saveSessions(with: decodedData.message)
                default:
                    break
                }
            } catch {
                DispatchQueue.main.async {
                    self.triggerActionAfterDelay {
                        self.view?.showNetworkError()
                    }
                }
            }
        }

        let errorHandler: () -> Void = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.triggerActionAfterDelay {
                    self.view?.showServerError()
                }
            }
        }

        let model = WebSocketsModel(
            stringAction: messageHandler,
            dataAction: nil,
            errorAction: errorHandler
        )

        switch type {
        case .matchesWebSocket:
            webSocketsManager = WebSocketsAPI.createWebSocketManager(
                for: .moviesMatchesUpdate,
                sessionID: sessionID
            )
        case .sessionStatusWebSocket:
            webSocketsManager = WebSocketsAPI.createWebSocketManager(
                for: .sessionStatusUpdate,
                sessionID: sessionID
            )
        case .rouletteWebSocket:
            webSocketsManager = WebSocketsAPI.createWebSocketManager(
                for: .rouletteUpdate,
                sessionID: sessionID
            )
        case .sessionResultWebSocket:
            webSocketsManager = WebSocketsAPI.createWebSocketManager(
                for: .sessionResultUpdate,
                sessionID: sessionID
            )
        default:
            break
        }

        webSocketsManager?.configureSocket(with: model)
    }
}

// swiftlint: enable type_body_length
// swiftlint: enable function_body_length
// swiftlint: enable cyclomatic_complexity
// swiftlint: enable file_length
