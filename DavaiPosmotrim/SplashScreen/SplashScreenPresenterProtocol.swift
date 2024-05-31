//
//  SplashScreenPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 28.05.2024.
//

import Foundation

protocol SplashScreenPresenterProtocol {
    func dismiss(completion: (() -> Void)?)
    func present()
}
