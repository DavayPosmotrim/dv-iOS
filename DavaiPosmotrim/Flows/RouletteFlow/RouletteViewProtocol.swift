//
//  RouletteViewProtocol.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 08.07.2024.
//

import Foundation

protocol RouletteViewProtocol: AnyObject {
    func startRouletteScroll()
    func hideUsersView()
    func updateUsersCollectionViewHeight(with titles: [String])
}
