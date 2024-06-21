//
//  SelectionMoviesFactor.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 15.06.24.
//

import Foundation

struct SelectionMoviesFactory {
    static func makeSelectionMoviesViewController(
        with coordinator: SelectionMoviesCoordinator
    ) -> SelectionMoviesViewController {
        let presenter = SelectionMoviesPresenter(coordinator: coordinator)
        let viewController = SelectionMoviesViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
