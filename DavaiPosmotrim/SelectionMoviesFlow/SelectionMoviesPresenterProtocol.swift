//
//  SelectionMoviesPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 15.06.24.
//

import Foundation

protocol SelectionMoviesPresenterProtocol: AnyObject {
    func updateRandomMatchCount()
    func noButtonTapped(withId id: UUID)
    func yesButtonTapped(withId id: UUID)
    func swipeNextMovie(withId id: UUID, direction: CGFloat)
    func comeBackButtonTapped()
    func canGetPreviousMovie() -> Bool
    func getFirstMovie() -> SelectionMovieCellModel
    func getNextMovie() -> SelectionMovieCellModel?
    func getPreviousMovie() -> SelectionMovieCellModel?
    func addToLikedMovies(withId id: UUID)
    func removeFromLikedMovies(withId id: UUID)
    func didTapMatchRightButton()
    func cancelButtonTapped()
    func cancelButtonAlertTapped()
}
