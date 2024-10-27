//
//  RoulettePresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 08.07.2024.
//

import Foundation

protocol RoulettePresenterProtocol: AnyObject {
    var moviesCount: Int { get }
    var usersCount: Int { get }
    var movieIDs: [Int] { get }

    func getMoviesAtIndex(index: Int) -> SelectionMovieCellModel
    func getMovieByID(id: Int) -> SelectionMovieCellModel?
    func getNamesAtIndex(index: Int) -> RouletteUsersCollectionCellModel
    func getConnectedProperty(index: Int) -> Bool
    func downloadMoviesArray()
    func downloadUsersArray()
    func getRouletteMovieID() -> Int?
    func connectUsers()
    func startRouletteController(with delegate: RouletteStartViewControllerDelegate?)
    func showMatchViewController(matchModel: SelectionMovieCellModel, and completion: (() -> Void)?)
    func showSessionsList()
    func finishRoulette()
}
