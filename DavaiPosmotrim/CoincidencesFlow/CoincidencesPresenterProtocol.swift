//
//  CoincidencesPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 12.06.2024.
//

import Foundation

protocol CoincidencesPresenterProtocol: AnyObject {
    var moviesArray: [String]? { get }
    func diceButtonTapped()
}
