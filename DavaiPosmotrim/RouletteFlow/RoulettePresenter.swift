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
    private var usersArray = [ReusableCollectionCellModel]() {
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

    func getNamesAtIndex(index: Int) -> ReusableCollectionCellModel {
        usersArray[index]
    }

    // Метод для имитации присоединения пользователей
    func downloadUsersArray() {
        DispatchQueue.global().async {
            let downloadedNames = [
                ReusableCollectionCellModel(title: "Эльдар(вы)"),
                ReusableCollectionCellModel(title: "Юрий"),
                ReusableCollectionCellModel(title: "Сергей"),
                ReusableCollectionCellModel(title: "Александр"),
                ReusableCollectionCellModel(title: "Максим")
            ]

            let delayInSeconds: TimeInterval = 2
            let dispatchGroup = DispatchGroup()

            downloadedNames.enumerated().forEach { index, name in
                dispatchGroup.enter()
                DispatchQueue.global().asyncAfter(deadline: .now() + delayInSeconds * Double(index)) {
                    self.usersArray.append(name)
                    dispatchGroup.leave()
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
