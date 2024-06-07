//
//  SplashScreenPresenter.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 05.06.2024.
//

import Foundation

final class SplashScreenPresenter: SplashScreenPresenterProtocol {
    weak var coordinator: SplashScreenCoordinator?
    weak var view: SplashScreenViewControllerProtocol?

    init(coordinator: SplashScreenCoordinator) {
        self.coordinator = coordinator
    }

    func splashDidFinish() {
        guard let coordinator else { return }
        coordinator.finish()
    }
//TODO: Перенести ещё методы из ViewController
}
