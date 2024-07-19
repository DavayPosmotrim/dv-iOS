//
//  SessionMoviesPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 22.06.2024.
//

import Foundation

protocol SessionMoviesPresenterProtocol: AnyObject {
    // MARK: - Properties
    var users: [ReusableCollectionCellModel] { get }
    var movies: [ReusableLikedMoviesCellModel] { get }
    var sessionCode: String { get }
    var sessionDateForTitle: String { get }

    // MARK: - Methods
    func viewDidLoad()
    func showMovie(by sessionIndex: Int)
}
