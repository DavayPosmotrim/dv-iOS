//
//  JoinSessionPresenter.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 23.05.2024.
//

import Foundation

final class JoinSessionPresenter: JoinSessionPresenterProtocol {

    // MARK: - Public Properties

    weak var coordinator: JoinSessionCoordinator?
    weak var view: JoinSessionViewProtocol?

    // MARK: - Initializers

    init(coordinator: JoinSessionCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Public methods

    func authFinish() {
        guard let coordinator else { return }
        coordinator.finish()
    }
}
