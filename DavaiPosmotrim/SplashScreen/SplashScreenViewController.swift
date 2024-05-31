//
//  SplashScreenViewController.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 28.05.2024.
//

import Foundation
import UIKit
import CoreMotion
import CoreGraphics

final class SplashScreenViewController: UIViewController, UIGestureRecognizerDelegate {
    // MARK: Private Properties
    private var animator: UIDynamicAnimator!
    private var gravity: UIGravityBehavior!
    private var motion: CMMotionManager!
    private var queue: OperationQueue!
    private var animationTimer = Timer()
    private var bordersTimer = Timer()
    private var tapView: UIView = {
        var tapView = UIView()
        tapView.backgroundColor = .clear
        return tapView
    }()
    private var leftView: UIView = {
        var leftView = UIView()
        leftView.backgroundColor = .clear
        return leftView
    }()
    private var rightView: UIView = {
        var rightView = UIView()
        rightView.backgroundColor = .clear
        return rightView
    }()
    private var topView: UIView = {
        var topView = UIView()
        topView.backgroundColor = .clear
        return topView
    }()
    private var bottomView: UIView = {
        var bottomView = UIView()
        bottomView.backgroundColor = .clear
        return bottomView
    }()
    private var davayImageView: UIImageView = {
        let davayImageView = UIImageView(image: UIImage(named: "davayLabelImage"))
        return davayImageView
    }()
    private var backgroundView: UIImageView = {
        var backgroundView = UIImageView(image: UIImage(named: "launchScreenBackground"))
        backgroundView.contentMode = .scaleToFill
        return backgroundView
    }()
    private var musicalLabel: UILabel = {
        var musicalLabel = UILabel(frame: CGRect(x: 200, y: -490, width: 119, height: 40))
        musicalLabel.textAlignment = .center
        musicalLabel.textColor = UIColor(named: "baseTextColor")
        musicalLabel.backgroundColor = UIColor(named: "attentionAdditionalColor")
        musicalLabel.layer.masksToBounds = true
        musicalLabel.layer.cornerRadius = 16
        musicalLabel.text = "Мюзикал"
        musicalLabel.font = .systemFont(ofSize: 20)
        musicalLabel.transform = CGAffineTransform(rotationAngle: -.pi/6)
        return musicalLabel
    }()
    private var thrillerLabel: UILabel = {
        var thrillerLabel = UILabel(frame: CGRect(x: 100, y: -445, width: 124, height: 40))
        thrillerLabel.textAlignment = .center
        thrillerLabel.textColor = UIColor(named: "baseTextColor")
        thrillerLabel.backgroundColor = UIColor(named: "attentionAdditionalColor")
        thrillerLabel.layer.masksToBounds = true
        thrillerLabel.layer.cornerRadius = 16
        thrillerLabel.text = "Триллер"
        thrillerLabel.font = .systemFont(ofSize: 20)
        thrillerLabel.transform = CGAffineTransform(rotationAngle: .pi/6)
        return thrillerLabel
    }()
    private var melodrammaLabel: UILabel = {
        var melodrammaLabel = UILabel(frame: CGRect(x: 50, y: -400, width: 151, height: 40))
        melodrammaLabel.textAlignment = .center
        melodrammaLabel.textColor = UIColor(named: "baseTextColor")
        melodrammaLabel.backgroundColor = UIColor(named: "attentionAdditionalColor")
        melodrammaLabel.layer.masksToBounds = true
        melodrammaLabel.layer.cornerRadius = 16
        melodrammaLabel.text = "Мелодрамма"
        melodrammaLabel.font = .systemFont(ofSize: 20)
        melodrammaLabel.transform = CGAffineTransform(rotationAngle: -.pi/3)
        return melodrammaLabel
    }()
    private var biographyLabel: UILabel = {
        var biographyLabel = UILabel(frame: CGRect(x: 120, y: -355, width: 147, height: 40))
        biographyLabel.textAlignment = .center
        biographyLabel.textColor = UIColor(named: "baseTextColor")
        biographyLabel.backgroundColor = UIColor(named: "attentionAdditionalColor")
        biographyLabel.layer.masksToBounds = true
        biographyLabel.layer.cornerRadius = 16
        biographyLabel.text = "Биография"
        biographyLabel.font = .systemFont(ofSize: 20)
        biographyLabel.transform = CGAffineTransform(rotationAngle: -.pi/6)
        return biographyLabel
    }()
    private var boevikLabel: UILabel = {
        var boevikLabel = UILabel(frame: CGRect(x: 220, y: -310, width: 111, height: 40))
        boevikLabel.textAlignment = .center
        boevikLabel.textColor = UIColor(named: "baseTextColor")
        boevikLabel.backgroundColor = UIColor(named: "attentionAdditionalColor")
        boevikLabel.layer.masksToBounds = true
        boevikLabel.layer.cornerRadius = 16
        boevikLabel.text = "Боевик"
        boevikLabel.font = .systemFont(ofSize: 20)
        boevikLabel.transform = CGAffineTransform(rotationAngle: .pi/6)
        return boevikLabel
    }()
    private var fantasyLabel: UILabel = {
        var fantasyLabel = UILabel(frame: CGRect(x: 70, y: -265, width: 155, height: 40))
        fantasyLabel.textAlignment = .center
        fantasyLabel.textColor = UIColor(named: "baseTextColor")
        fantasyLabel.backgroundColor = UIColor(named: "attentionAdditionalColor")
        fantasyLabel.layer.masksToBounds = true
        fantasyLabel.layer.cornerRadius = 16
        fantasyLabel.text = "Фантастика"
        fantasyLabel.font = .systemFont(ofSize: 20)
        fantasyLabel.transform = CGAffineTransform(rotationAngle: -.pi/6)
        return fantasyLabel
    }()
    private var posmotrimLabel: UILabel = {
        var posmotrimLabel = UILabel(frame: CGRect(x: 150, y: -40, width: 164, height: 40))
        posmotrimLabel.textAlignment = .center
        posmotrimLabel.textColor = UIColor(named: "whiteTextColor")
        posmotrimLabel.backgroundColor = UIColor(named: "basePrimaryAccentColor")
        posmotrimLabel.layer.masksToBounds = true
        posmotrimLabel.layer.cornerRadius = 16
        posmotrimLabel.text = "Посмотрим?"
        posmotrimLabel.font = .systemFont(ofSize: 20)
        return posmotrimLabel
    }()
    private var multfilmLabel: UILabel = {
        var multfilmLabel = UILabel(frame: CGRect(x: 180, y: -220, width: 164, height: 40))
        multfilmLabel.textAlignment = .center
        multfilmLabel.textColor = UIColor(named: "baseTextColor")
        multfilmLabel.backgroundColor = UIColor(named: "attentionAdditionalColor")
        multfilmLabel.layer.masksToBounds = true
        multfilmLabel.layer.cornerRadius = 16
        multfilmLabel.text = "Мультфильм"
        multfilmLabel.font = .systemFont(ofSize: 20)
        multfilmLabel.transform = CGAffineTransform(rotationAngle: .pi/6)
        return multfilmLabel
    }()
    private var familyLabel: UILabel = {
        var familyLabel = UILabel(frame: CGRect(x: 80, y: -175, width: 144, height: 40))
        familyLabel.textAlignment = .center
        familyLabel.textColor = UIColor(named: "baseTextColor")
        familyLabel.backgroundColor = UIColor(named: "attentionAdditionalColor")
        familyLabel.layer.masksToBounds = true
        familyLabel.layer.cornerRadius = 16
        familyLabel.text = "Семейный"
        familyLabel.font = .systemFont(ofSize: 20)
        familyLabel.transform = CGAffineTransform(rotationAngle: .pi/6)
        return familyLabel
    }()
    private var documentaryLabel: UILabel = {
        var documentaryLabel = UILabel(frame: CGRect(x: 100, y: -130, width: 210, height: 40))
        documentaryLabel.textAlignment = .center
        documentaryLabel.textColor = UIColor(named: "baseTextColor")
        documentaryLabel.backgroundColor = UIColor(named: "attentionAdditionalColor")
        documentaryLabel.layer.masksToBounds = true
        documentaryLabel.layer.cornerRadius = 16
        documentaryLabel.text = "Документальный"
        documentaryLabel.font = .systemFont(ofSize: 20)
        documentaryLabel.transform = CGAffineTransform(rotationAngle: .pi/3)
        return documentaryLabel
    }()
    private var adventureLabel: UILabel = {
        var adventureLabel = UILabel(frame: CGRect(x: 100, y: -85, width: 176, height: 40))
        adventureLabel.textAlignment = .center
        adventureLabel.textColor = UIColor(named: "baseTextColor")
        adventureLabel.backgroundColor = UIColor(named: "attentionAdditionalColor")
        adventureLabel.layer.masksToBounds = true
        adventureLabel.layer.cornerRadius = 16
        adventureLabel.text = "Приключение"
        adventureLabel.font = .systemFont(ofSize: 20)
        adventureLabel.transform = CGAffineTransform(rotationAngle: -.pi/6)
        return adventureLabel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "baseBackgroundColor")
        setupConstraints()
        setupAnimationBehaviour()
        addTapRecognition()
        animationTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
            print("WHY")
            self.dismissSplashScreen()
        }
    }
    func setupConstraints() {
        var safeArea: UIEdgeInsets {
                let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                return scene?.windows.first?.safeAreaInsets ?? .zero
            }
        leftView.frame =  CGRect(x: 0, y: 0, width: 24, height: 1000)
        rightView.frame =  CGRect(x: view.safeAreaLayoutGuide.layoutFrame.width - 24, y: 0, width: 24, height: 1000)
        bottomView.frame = CGRect(x: 0, y: view.safeAreaLayoutGuide.layoutFrame.maxY - 64, width: 1000, height: 32)
        topView.frame = CGRect(x: 0, y: safeArea.top, width: 1000, height: 32)
        davayImageView.frame = CGRect(x: view.frame.width - 224, y: view.frame.height - safeArea.bottom - 32 - 45, width: 200, height: 45)
        [backgroundView,
         davayImageView,
         boevikLabel,
         familyLabel,
         fantasyLabel,
         musicalLabel,
         multfilmLabel,
         thrillerLabel,
         adventureLabel,
         biographyLabel,
         posmotrimLabel,
         melodrammaLabel,
         documentaryLabel,
         topView,
         bottomView,
         rightView,
         leftView,
         tapView].forEach {
            view.addSubview($0)
        }
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        tapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tapView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            tapView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0)
        ])
    }
    func setupAnimationBehaviour() {
        queue = OperationQueue.current
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior(items: [
            boevikLabel,
            familyLabel,
            fantasyLabel,
            musicalLabel,
            multfilmLabel,
            thrillerLabel,
            adventureLabel,
            biographyLabel,
            posmotrimLabel,
            melodrammaLabel,
            documentaryLabel
        ])
        motion = CMMotionManager()
        let collision = UICollisionBehavior(items: [
            boevikLabel,
            familyLabel,
            fantasyLabel,
            musicalLabel,
            multfilmLabel,
            thrillerLabel,
            adventureLabel,
            biographyLabel,
            posmotrimLabel,
            melodrammaLabel,
            documentaryLabel
        ])
        gravity.magnitude = 1
        bordersTimer = Timer.scheduledTimer(withTimeInterval: 1.6, repeats: false) { _ in
            collision.addBoundary(withIdentifier: "topBorder" as NSCopying,
                                  for: UIBezierPath(rect: self.topView.frame))
            self.startMoving()
        }
        collision.addBoundary(withIdentifier: "leftBorder" as NSCopying,
                              for: UIBezierPath(rect: leftView.frame))
        collision.addBoundary(withIdentifier: "rightBorder" as NSCopying,
                              for: UIBezierPath(rect: rightView.frame))
        collision.addBoundary(withIdentifier: "bottomBorder" as NSCopying,
                              for: UIBezierPath(rect: bottomView.frame))
        collision.addBoundary(withIdentifier: "davayImageView" as NSCopying,
                              for: UIBezierPath(rect: self.davayImageView.frame))
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
    }
    func startMoving() {
        motion.startDeviceMotionUpdates(to: queue) { motion, error in
            guard let motion = motion else { return }
            let grav: CMAcceleration = motion.gravity
            let xAxis = CGFloat(grav.x)
            let yAxis = CGFloat(grav.y)
            var point = CGPoint(x: xAxis, y: yAxis)

            if let orientation = UIApplication
                .shared
                .connectedScenes
                .flatMap({ ($0 as? UIWindowScene)?.windows ?? [] })
                .first(where: { $0.isKeyWindow })?
                .windowScene?
                .interfaceOrientation {
                if orientation == .landscapeLeft {
                    let xPoint = point.x
                    point.x = 0 - point.y
                    point.y = xPoint
                } else if orientation == .landscapeRight {
                    let xPoint = point.x
                    point.x = point.y
                    point.y = 0 - xPoint
                } else if orientation == .portraitUpsideDown {
                    point.x *= -1
                    point.y *= -1
                }
            }

            let vector = CGVector(dx: point.x, dy: 0 - point.y)
            self.gravity.gravityDirection = vector
        }
    }
    
    func addTapRecognition() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTapped(gestureRecognizer:)))
        tapView.addGestureRecognizer(tapRecognizer)
        tapRecognizer.delegate = self
        tapView.isUserInteractionEnabled = true
    }
    
    func dismissSplashScreen() {
        guard let window = UIApplication
            .shared
            .connectedScenes
            .flatMap({ ($0 as? UIWindowScene)?.windows ?? [] })
            .first(where: { $0.isKeyWindow }) else {
            fatalError("App Delegate does not  have a window")
        }
        animationTimer.invalidate()
        bordersTimer.invalidate()
        self.dismiss(animated: true) {
            let transition = CATransition()
            transition.type = .push
            window.layer.add(transition, forKey: "transition")
            let navigationController = UINavigationController()
            let appCoordinator = AppCoordinator(type: .app, navigationController: navigationController)
            appCoordinator.start()
            window.rootViewController = navigationController
        }
    }
    
    @objc func screenTapped(gestureRecognizer: UITapGestureRecognizer) {
        dismissSplashScreen()
    }
}
