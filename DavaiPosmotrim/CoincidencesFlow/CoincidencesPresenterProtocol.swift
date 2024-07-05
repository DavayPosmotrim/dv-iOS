//
//  CoincidencesPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 12.06.2024.
//

import Foundation

protocol CoincidencesPresenterProtocol: AnyObject {
    var moviesCount: Int { get }
    var isArrayEmpty: Bool { get }

    func diceButtonTapped()
    func getMoviesAtIndex(index: Int) -> ReusableLikedMoviesCellModel
    func downloadMoviesArrayFromServer()
    func getMovieInfo(from array: [SelectionMovieCellModel]) -> SelectionMovieCellModel?
}
