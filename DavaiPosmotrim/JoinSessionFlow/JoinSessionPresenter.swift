//
//  JoinSessionPresenter.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 23.05.2024.
//

import Foundation

final class JoinSessionPresenter: JoinSessionPresenterProtocol {

    private var namesArray = [
        "Эльдар(вы)",
        "Юрий",
        "Сергей",
        "Александр",
        "Максим"
    ]

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

    func getNamesCount() -> Int {
        namesArray.count
    }

    func getNamesAtIndex(index: Int) -> String {
        namesArray[index]
    }

    func checkCreatedCodeProperty() -> String {
        guard let createdCode = UserDefaults.standard.string(
            forKey: Resources.JoinSession.joinSessionCreatedCode
        ) else {
            return ""
        }
        return createdCode
    }
}
