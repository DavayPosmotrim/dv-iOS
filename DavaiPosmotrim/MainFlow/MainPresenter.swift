//
//  MainPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 28.04.24.
//

import Foundation

final class MainPresenter: MainPresenterProtocol {

    // MARK: - Public Properties

    weak var coordinator: MainCoordinator?
    weak var view: MainViewProtocol?

    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }

    func mainFinish(screen: String) {
        guard let coordinator else { return }
        coordinator.showNextScreen(screen: screen)
    }

    func finishCoordinator() {
        guard let coordinator else { return }
        coordinator.finish()
    }
}
