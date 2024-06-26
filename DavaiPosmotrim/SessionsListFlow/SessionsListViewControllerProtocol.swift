//
//  SessionsListViewControllerProtocol.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 22.06.2024.
//

import Foundation

protocol SessionsListViewControllerProtocol: AnyObject {
    var presenter: SessionsListPresenterProtocol { get set }
    func showListOrEmptyView()
}
