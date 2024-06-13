//
//  SplashScreenPresenter.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 05.06.2024.
//

import UIKit
import CoreMotion

final class SplashScreenPresenter: SplashScreenPresenterProtocol {
    weak var coordinator: SplashScreenCoordinator?
    weak var view: SplashScreenViewControllerProtocol?

    private var motion = CMMotionManager()
    private var queue = OperationQueue.current

    init(coordinator: SplashScreenCoordinator) {
        self.coordinator = coordinator
    }

    func splashDidFinish() {
        guard let coordinator else { return }
        coordinator.finish()
    }

    func startMoving(gravity: UIGravityBehavior) {
        guard let queue = queue else { return }
        motion.startDeviceMotionUpdates(to: queue) { motion, _ in
            guard let motion = motion else { return }
            let grav: CMAcceleration = motion.gravity
            let xAxis = CGFloat(grav.x)
            let yAxis = CGFloat(grav.y)
            let point = CGPoint(x: xAxis, y: yAxis)
            let vector = CGVector(dx: point.x, dy: 0 - point.y)
            gravity.gravityDirection = vector
        }
    }
}
