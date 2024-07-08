//
//  RoulettePresenter.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 08.07.2024.
//

import Foundation

final class RoulettePresenter: RoulettePresenterProtocol {

    // MARK: - Stored Properties

    weak var coordinator: RouletteCoordinator?
    weak var view: RouletteViewProtocol?

    // MARK: - Initializers

    init(coordinator: RouletteCoordinator) {
        self.coordinator = coordinator
    }
}
