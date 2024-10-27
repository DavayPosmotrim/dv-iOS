//
//  SelectionMoviesPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 15.06.24.
//

import Foundation

protocol SelectionMoviesPresenterProtocol: AnyObject {
    func loadData()
    func updateRandomMatchCount()
    func noButtonTapped(withId id: Int)
    func yesButtonTapped(withId id: Int)
    func swipeNextMovie(withId id: Int, direction: CGFloat)
    func comeBackButtonTapped()
    func canGetPreviousMovie() -> Bool
    func getFirstMovie() -> SelectionMovieCellModel
    func addToLikedMovies(withId id: Int)
    func removeFromLikedMovies(withId id: Int)
    func didTapMatchRightButton()
    func cancelButtonTapped()
    func cancelButtonAlertTapped()
}
