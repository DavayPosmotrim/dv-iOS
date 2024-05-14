//
//  CreateSessionPresenter.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 14.05.24.
//

import UIKit

final class CreateSessionPresenter: CreateSessionPresenterProtocol {

    // MARK: - Public Properties

    var createSession = CreateSesseionModel(collections: [], genres: [])

    // MARK: - Public Methods

    func didAddCollection(title: String?) {
        guard let title = title else {
            return
        }
        createSession.collections.append(title)
    }

    func didRemoveCollection(title: String?) {
        guard let title = title,
              let index = createSession.collections.firstIndex(of: title) else {
            return
        }
        createSession.collections.remove(at: index)
    }

    func didAddGenres(title: String?) {
        guard let title = title else {
            return
        }
        createSession.genres.append(title)
    }

    func didRemoveGenres(title: String?) {
        guard let title = title,
              let index = createSession.genres.firstIndex(of: title) else {
            return
        }
        createSession.genres.remove(at: index)
    }

    func showPreviousScreen(navigationController: UINavigationController?) {
        guard let navigationController = navigationController else { return }
        navigationController.popViewController(animated: true)
    }

    func showNextScreen(navigationController: UINavigationController?) {
        guard let navigationController = navigationController else { return }
        let invitingUsersViewController = InvitingUsersViewController()
        navigationController.pushViewController(invitingUsersViewController, animated: true)
    }
}
