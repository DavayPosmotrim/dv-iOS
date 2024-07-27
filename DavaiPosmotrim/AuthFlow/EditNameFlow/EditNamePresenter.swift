//
//  EditNamePresenter.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.07.2024.
//

import Foundation

final class EditNamePresenter: EditNamePresenterProtocol {

    // MARK: - Public properties

    weak var coordinator: EditNameCoordinator?
    weak var view: EditNameViewProtocol?
    
    // MARK: - Initializers

    init(coordinator: EditNameCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Public properties

    func finishEdit() {
        guard let coordinator else { return }
        coordinator.finish()
    }
}
