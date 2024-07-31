//
//  JoinSessionAuthPresenter.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.07.2024.
//

import Foundation

final class JoinSessionAuthPresenter: JoinSessionAuthPresenterProtocol {

    // MARK: - Public properties

    weak var coordinator: JoinSessionAuthCoordinator?
    weak var view: JoinSessionAuthViewProtocol?

    // MARK: - Initializers

    init(coordinator: JoinSessionAuthCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Public properties

    func finishSessionAuth() {
        guard let coordinator else { return }
        coordinator.finish()
    }

    func showJoinSession() {
        guard let coordinator else { return }
        coordinator.showJoinSessionFlow()
    }
}
