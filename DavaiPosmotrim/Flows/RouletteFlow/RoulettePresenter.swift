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
        let buffer = 1000
        let totalElements = rouletteMoviesArray.count + buffer
        return totalElements
    }

    var usersCount: Int {
        usersArray.count
    }

    var movieIDs: [Int] {
        return rouletteMoviesArray.map { $0.id }
    }

    // MARK: - Private Properties

    private var randomMovieId: Int?
    private var sessionService: SessionServiceProtocol
    private var downloadedMoviesArray = [SelectionMovieCellModel]()
    private var rouletteMoviesArray = [SelectionMovieCellModel]()
    private var usersArray = [RouletteUsersCollectionCellModel]() {
        didSet {
            updateReusableCollection()
        }
    }
    private var connectedUsersArray = [Bool]() {
        didSet {
            updateReusableCollection()
        }
    }

    // MARK: - Initializers

    init(
        coordinator: RouletteCoordinator,
        sessionService: SessionServiceProtocol = SessionService()
    ) {
        self.coordinator = coordinator
        self.sessionService = sessionService
    }

    // MARK: - Public methods

    func startRouletteController(with delegate: RouletteStartViewControllerDelegate?) {
        guard let coordinator else { return }
        coordinator.showRouletteStartViewController(with: delegate)
    }

    func showMatchViewController(matchModel: SelectionMovieCellModel, and completion: (() -> Void)?) {
        guard let coordinator else { return }
        coordinator.showMatchViewController(matchModel: matchModel, and: completion)
    }

    func showSessionsList() {
        guard let coordinator else { return }
        coordinator.showSessionsList()
    }

    func finishRoulette() {
        guard let coordinator else { return }
        coordinator.finish()
    }

    func getMoviesAtIndex(index: Int) -> SelectionMovieCellModel {
        let safeIndex = index % rouletteMoviesArray.count

        return rouletteMoviesArray[safeIndex]
    }

    func getMovieByID(id: Int) -> SelectionMovieCellModel? {
        return rouletteMoviesArray.first { $0.id == id }
    }

    func getNamesAtIndex(index: Int) -> RouletteUsersCollectionCellModel {
        usersArray[index]
    }

    func getConnectedProperty(index: Int) -> Bool {
        guard index < connectedUsersArray.count else { return false }
               return connectedUsersArray[index]
    }

    func downloadMoviesArray() {
        let downloadedMovies = getMatchedMoviesFromUserDefaults()

        for movie in downloadedMovies {
            downloadedMoviesArray.append(movie)
        }

        parseDataInRouletteArray(from: downloadedMoviesArray, count: 20)
    }

    func downloadUsersArray() {
        guard let deviceId = UserDefaults.standard.string(
            forKey: Resources.Authentication.savedDeviceID
        ) else { return }

        let downloadedUsers = getConnectedUsers()
        let isConnected = false
        var decodedUsers = downloadedUsers.map {
            RouletteUsersCollectionCellModel(id: $0.id, title: $0.title, isConnected: isConnected)
        }

        if let index = decodedUsers.firstIndex(where: { $0.id.uppercased() == deviceId }) {
            let userToMove = decodedUsers.remove(at: index)
            decodedUsers.insert(userToMove, at: 0)
        }

        let titlesArray = decodedUsers.map { $0.title }
        usersArray = decodedUsers

        DispatchQueue.main.async {
            self.view?.updateUsersCollectionViewHeight(with: titlesArray)
        }
    }

    func getRouletteMovieID() -> Int? {
        guard let serverId = UserDefaults.standard.value(
            forKey: Resources.RouletteFlow.savedRouletteMovieId
        ) else {
            return randomMovieId
        }

        return serverId as? Int
    }

    // Метод для имитации подключения пользователей
    func connectUsers() {
        DispatchQueue.global().async {
            let delayInSeconds: TimeInterval = 2
            let dispatchGroup = DispatchGroup()

            self.usersArray.enumerated().forEach { index, _ in
                dispatchGroup.enter()

                DispatchQueue.global().asyncAfter(deadline: .now() + delayInSeconds * Double(index)) {
                    self.connectedUsersArray.append(true)
                    if index == self.connectedUsersArray.count - 1 {
                        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                            dispatchGroup.leave()
                        }
                    } else {
                        dispatchGroup.leave()
                    }
                }
            }

            dispatchGroup.notify(queue: .main) {
                self.view?.hideUsersView()
                self.view?.startRouletteScroll()
            }
        }
    }

    // MARK: - Private methods

    private func updateReusableCollection() {
        NotificationCenter.default.post(
            name: NSNotification.Name(Resources.ReusableCollectionView.updateCollectionView),
            object: nil
        )
    }

    private func triggerActionAfterDelay(error: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            error()
        }
    }

    // TODO: - fix bug with dividing by 0 in downloadMoviesArray method when there's more matches when count number

    private func parseDataInRouletteArray(from sourceArray: [SelectionMovieCellModel], count: Int) {
        let shuffledArray = sourceArray.shuffled()
        let selectedCount = min(count, sourceArray.count)

        var randomElements: [SelectionMovieCellModel]
        if sourceArray.count > count {
            guard let serverID = getRouletteMovieID(),
                  let selectedMovie = sourceArray.first(where: { $0.id == serverID })
            else { return }

            randomElements = Array(shuffledArray.prefix(selectedCount))
            randomElements.removeAll(where: { $0.id == serverID })

            let middleIndex = randomElements.count / 2
            randomElements.insert(selectedMovie, at: middleIndex)
        } else {
            randomElements = Array(shuffledArray.prefix(selectedCount))
        }
        rouletteMoviesArray = Array(randomElements)
    }

    private func getConnectedUsers() -> [ReusableCollectionCellModel] {
        guard
            let savedData = UserDefaults.standard.data(
                forKey: Resources.InvitingSession.savedUsersArray
            ),
            let decodedUsers = try? JSONDecoder().decode(
                [ReusableCollectionCellModel].self,
                from: savedData
            )
        else { return [] }

        return decodedUsers
    }

    private func getMatchedMoviesFromUserDefaults() -> [SelectionMovieCellModel] {
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
}

    // MARK: - SessionService

extension RoulettePresenter {

    func getRouletteRandomMovie() {
        guard
            let deviceId = UserDefaults.standard.string(
                forKey: Resources.Authentication.savedDeviceID
            ),
            let sessionCode = UserDefaults.standard.string(
                forKey: Resources.Authentication.sessionCode
            )
        else { return }

        sessionService.getRouletteRandomMovie(
            sessionCode: sessionCode,
            deviceId: deviceId
        ) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.randomMovieId = response.randomMovieId
                case .failure(let error):
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
