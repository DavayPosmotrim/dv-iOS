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

    var movieIDs: [UUID] {
        return rouletteMoviesArray.map { $0.id }
    }

    // MARK: - Private Properties

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

    init(coordinator: RouletteCoordinator) {
        self.coordinator = coordinator
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

    func getMovieByID(id: UUID) -> SelectionMovieCellModel? {
        return rouletteMoviesArray.first { $0.id == id }
    }

    func getNamesAtIndex(index: Int) -> RouletteUsersCollectionCellModel {
        usersArray[index]
    }

    func getConnectedProperty(index: Int) -> Bool {
        guard index < connectedUsersArray.count else { return false }
               return connectedUsersArray[index]
    }

    // Метод для имитации загрузки фильмов
    func downloadMoviesArray() {
        let downloadedMovies = selectionMovieMockData

        for movie in downloadedMovies {
            downloadedMoviesArray.append(movie)
        }

        parseDataInRouletteArray(from: downloadedMoviesArray, count: 20)
    }

    // Метод для имитации загрузки списка пользователей
    func downloadUsersArray() {
        let downloadedNames = [
            RouletteUsersCollectionCellModel(title: "Эльдар(вы)", isConnected: false),
            RouletteUsersCollectionCellModel(title: "Юрий", isConnected: false),
            RouletteUsersCollectionCellModel(title: "Сергей", isConnected: false),
            RouletteUsersCollectionCellModel(title: "Александр", isConnected: false),
            RouletteUsersCollectionCellModel(title: "Максим", isConnected: false)
        ]

        var titlesArray = [String]()

        for name in downloadedNames {
            usersArray.append(name)
            titlesArray.append(name.title)
        }
        DispatchQueue.main.async {
            self.view?.updateUsersCollectionViewHeight(with: titlesArray)
        }
    }

    func getRouletteMovieID() -> UUID? {
        let middleIndex = movieIDs.count / 2
        let serverID = movieIDs[middleIndex]

        return serverID
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
}
