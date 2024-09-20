//
//  SplashScreenPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 05.06.2024.
//

import UIKit

protocol SplashScreenPresenterProtocol: AnyObject {
    func splashDidFinish()
    func startMoving(gravity: UIGravityBehavior)
}
