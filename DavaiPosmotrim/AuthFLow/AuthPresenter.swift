//
//  AuthPresenter.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 04.05.2024.
//

import Foundation

final class AuthPresenter: AuthPresenterProtocol {

    // MARK: - Public Properties

    weak var coordinator: AuthCoordinator?
    weak var view: AuthViewProtocol?

    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }

    func authFinish() {
        guard let coordinator else { return }
        coordinator.finish()
    }
    
}
