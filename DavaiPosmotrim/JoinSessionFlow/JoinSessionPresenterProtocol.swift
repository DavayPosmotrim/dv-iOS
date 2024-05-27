//
//  JoinSessionPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 23.05.2024.
//

import Foundation

protocol JoinSessionPresenterProtocol: AnyObject {
    func authFinish()
    func getNamesCount() -> Int
    func getNamesAtIndex(index: Int) -> ReusableCollectionCellModel
    func addNameToArray(name: ReusableCollectionCellModel)
    func deleteNameFromArray(with id: UUID?)
    func checkCreatedCodeProperty() -> String
}
