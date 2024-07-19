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

    func getMoviesAtIndex(index: Int) -> SelectionMovieCellModel
    func getNamesAtIndex(index: Int) -> ReusableCollectionCellModel
    func downloadMoviesArray()
    func downloadUsersArray()
    func startRouletteController(with delegate: RouletteStartViewControllerDelegate?)
    func finishRoulette()
}
