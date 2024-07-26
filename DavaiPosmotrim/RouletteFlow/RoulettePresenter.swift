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
        let totalElements = moviesArray.count + buffer
        return totalElements
    }

    var usersCount: Int {
        usersArray.count
    }

    var movieIDs: [UUID] {
        return moviesArray.map { $0.id }
    }

    // MARK: - Private Properties

    private var moviesArray = [SelectionMovieCellModel]()
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

    func finishRoulette() {
        guard let coordinator else { return }
        coordinator.finish()
    }

    func getMoviesAtIndex(index: Int) -> SelectionMovieCellModel {
        let safeIndex = index % moviesArray.count

        return moviesArray[safeIndex]
    }

    // Метод для имитации загрузки фильмов
    func downloadMoviesArray() {
        let downloadedMovies = selectionMovieMockData

        for movie in downloadedMovies {
            moviesArray.append(movie)
        }
    }

    func getNamesAtIndex(index: Int) -> RouletteUsersCollectionCellModel {
        usersArray[index]
    }

    func getConnectedProperty(index: Int) -> Bool {
        guard index < connectedUsersArray.count else { return false }
               return connectedUsersArray[index]
    }

    func downloadUsersArray() {
        let downloadedNames = [
            RouletteUsersCollectionCellModel(title: "Эльдар(вы)", isConnected: false),
            RouletteUsersCollectionCellModel(title: "Юрий", isConnected: false),
            RouletteUsersCollectionCellModel(title: "Сергей", isConnected: false),
            RouletteUsersCollectionCellModel(title: "Александр", isConnected: false),
            RouletteUsersCollectionCellModel(title: "Максим", isConnected: false),
            RouletteUsersCollectionCellModel(title: "Витька", isConnected: false),
            RouletteUsersCollectionCellModel(title: "Михалыч", isConnected: false),
            RouletteUsersCollectionCellModel(title: "Петька", isConnected: false),
            RouletteUsersCollectionCellModel(title: "Ослик", isConnected: false),
            RouletteUsersCollectionCellModel(title: "Суслик", isConnected: false)
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
                            dispatchGroup.leave()                        }
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
}
