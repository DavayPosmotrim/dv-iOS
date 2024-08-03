//
//  joinSessionAuthPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.07.2024.
//

import Foundation

protocol JoinSessionAuthPresenterProtocol: AnyObject {
    func finishSessionAuth()
    func showJoinSession()
    func checkSessionCode(with code: String)
    func downloadSessionCode()
}
