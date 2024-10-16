//
//  JoinSessionPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 23.05.2024.
//

import Foundation

protocol JoinSessionPresenterProtocol: AnyObject {
    var code: String { get }

    func quitSessionButtonTapped()
    func getNamesCount() -> Int
    func getNamesAtIndex(index: Int) -> ReusableCollectionCellModel
    func downloadNamesArrayFromServer()
    func connectToWebSockets()
}
