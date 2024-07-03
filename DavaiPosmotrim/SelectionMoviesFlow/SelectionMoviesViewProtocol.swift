//
//  SelectionMoviesViewProtocol.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 22.06.24.
//

import Foundation

protocol SelectionMoviesViewProtocol: AnyObject {
    func updateMatchCountLabel(withRandomCount count: Int)
    func animateOffscreen(direction: CGFloat, completion: @escaping () -> Void)
    func showNextMovie(_ nextModel: SelectionMovieCellModel)
    func showPreviousMovie(_ nextModel: SelectionMovieCellModel)
    func showCancelSessionDialog()
}
