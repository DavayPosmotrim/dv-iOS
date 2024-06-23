//
//  CoincidencesPresenter.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 12.06.2024.
//

import Foundation

final class CoincidencesPresenter: CoincidencesPresenterProtocol {

    // MARK: - Public Properties

    weak var coordinator: CoincidencesCoordinator?
    weak var view: CoincidencesViewProtocol?

    var moviesArray: [String]?

    // MARK: - Initializers

    init(coordinator: CoincidencesCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Public methods

    func diceButtonTapped() {
        guard let coordinator else { return }
        coordinator.finish()
    }
}
