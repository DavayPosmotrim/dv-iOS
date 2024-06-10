//
//  CreateSessionPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 14.05.24.
//

import UIKit

protocol CreateSessionPresenterProtocol: AnyObject {
    func isSessionEmpty(segmentIndex: Int) -> Bool
    func getSelectionsMoviesCount() -> Int
    func getGenresMoviesCount() -> Int
    func getSelectionsMovie(index: Int) -> TableViewCellModel
    func getGenreAtIndex(index: Int) -> CollectionsCellModel
    func backButtonTapped()
    func didTapNextButton()
    func didAddCollection(id: UUID?)
    func didRemoveCollection(id: UUID?)
    func didAddGenres(id: UUID?)
    func didRemoveGenres(id: UUID?)
}
