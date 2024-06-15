//
//  SelectionMoviesPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 15.06.24.
//

import Foundation

protocol SelectionMoviesPresenterProtocol: AnyObject {
    func getRandomMatchCount() -> Int
    func canGetPreviousMovie() -> Bool
    func getCurrentMovieId() -> UUID?
    func getFirstMovie() -> SelectionMovieCellModel?
    func getNextMovie() -> SelectionMovieCellModel?
    func getPreviousMovie() -> SelectionMovieCellModel?
    func addToLikedMovies(withId id: UUID)
    func removeFromLikedMovies(withId id: UUID)
}
