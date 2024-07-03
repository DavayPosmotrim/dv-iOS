//
//  SplashScreenViewController.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 28.05.2024.
//

import UIKit
import CoreGraphics

final class SplashScreenViewController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - Public properties

    var presenter: SplashScreenPresenterProtocol?

    // MARK: - Private properties

    private var animator = UIDynamicAnimator()
    private var gravity = UIGravityBehavior()
    private var animationTimer = Timer()
    private var bordersTimer = Timer()

    // MARK: - Lazy properties

    private lazy var tapView: UIView = {
        var tapView = UIView()
        return tapView
    }()

    private lazy var leftView: UIView = {
        var leftView = UIView()
        return leftView
    }()

    private lazy var rightView: UIView = {
        var rightView = UIView()
        return rightView
    }()

    private lazy var topView: UIView = {
        var topView = UIView()
        return topView
    }()

    private lazy var bottomView: UIView = {
        var bottomView = UIView()
        return bottomView
    }()

    private lazy var davayImageView: UIImageView = {
        let davayImageView = UIImageView(image: UIImage.davay)
        return davayImageView
    }()

    private lazy var backgroundView: UIImageView = {
        var backgroundView = UIImageView(image: UIImage.launchScreenBackground)
        backgroundView.contentMode = .scaleToFill
        return backgroundView
    }()

    private lazy var musicalLabel: UILabel = {
        var musicalLabel = UILabel(frame: CGRect(
            x: 200,
            y: -490,
            width: 119,
            height: 40
        ))
        setupLabel(label: musicalLabel)
        musicalLabel.text = Resources.SplashScreen.musicalText
        musicalLabel.transform = CGAffineTransform(rotationAngle: -.pi/6)
        return musicalLabel
    }()

    private lazy var thrillerLabel: UILabel = {
        var thrillerLabel = UILabel(frame: CGRect(
            x: 100,
            y: -445,
            width: 124,
            height: 40
        ))
        setupLabel(label: thrillerLabel)
        thrillerLabel.text = Resources.SplashScreen.thrillerText
        thrillerLabel.transform = CGAffineTransform(rotationAngle: .pi/6)
        return thrillerLabel
    }()

    private lazy var melodrammaLabel: UILabel = {
        var melodrammaLabel = UILabel(frame: CGRect(
            x: 50,
            y: -400,
            width: 151,
            height: 40
        ))
        setupLabel(label: melodrammaLabel)
        melodrammaLabel.text = Resources.SplashScreen.melodrammaText
        melodrammaLabel.transform = CGAffineTransform(rotationAngle: -.pi/3)
        return melodrammaLabel
    }()

    private lazy var biographyLabel: UILabel = {
        var biographyLabel = UILabel(frame: CGRect(
            x: 120,
            y: -355,
            width: 147,
            height: 40
        ))
        setupLabel(label: biographyLabel)
        biographyLabel.text = Resources.SplashScreen.biographyText
        biographyLabel.transform = CGAffineTransform(rotationAngle: -.pi/6)
        return biographyLabel
    }()

    private lazy var boevikLabel: UILabel = {
        var boevikLabel = UILabel(frame: CGRect(
            x: 220,
            y: -310,
            width: 111,
            height: 40
        ))
        setupLabel(label: boevikLabel)
        boevikLabel.text = Resources.SplashScreen.boevikText
        boevikLabel.transform = CGAffineTransform(rotationAngle: .pi/6)
        return boevikLabel
    }()

    private lazy var fantasyLabel: UILabel = {
        var fantasyLabel = UILabel(frame: CGRect(
            x: 70,
            y: -265,
            width: 155,
            height: 40
        ))
        setupLabel(label: fantasyLabel)
        fantasyLabel.text = Resources.SplashScreen.fantasyText
        fantasyLabel.transform = CGAffineTransform(rotationAngle: -.pi/6)
        return fantasyLabel
    }()

    private lazy var posmotrimLabel: UILabel = {
        var posmotrimLabel = UILabel(frame: CGRect(
            x: 150,
            y: -40,
            width: 164,
            height: 40
        ))
        setupLabel(label: posmotrimLabel)
        posmotrimLabel.textColor = UIColor.whiteText
        posmotrimLabel.backgroundColor = UIColor.basePrimaryAccent
        posmotrimLabel.text = Resources.SplashScreen.posmotrimText
        return posmotrimLabel
    }()

    private lazy var multfilmLabel: UILabel = {
        var multfilmLabel = UILabel(frame: CGRect(
            x: 180,
            y: -220,
            width: 164,
            height: 40
        ))
        setupLabel(label: multfilmLabel)
        multfilmLabel.text = Resources.SplashScreen.multfilmText
        multfilmLabel.transform = CGAffineTransform(rotationAngle: .pi/6)
        return multfilmLabel
    }()

    private lazy var familyLabel: UILabel = {
        var familyLabel = UILabel(frame: CGRect(
            x: 80,
            y: -175,
            width: 144,
            height: 40
        ))
        setupLabel(label: familyLabel)
        familyLabel.text = Resources.SplashScreen.familyText
        familyLabel.transform = CGAffineTransform(rotationAngle: .pi/6)
        return familyLabel
    }()

    private lazy var documentaryLabel: UILabel = {
        var documentaryLabel = UILabel(frame: CGRect(
            x: 100,
            y: -130,
            width: 210,
            height: 40
        ))
        setupLabel(label: documentaryLabel)
        documentaryLabel.text = Resources.SplashScreen.documentaryText
        documentaryLabel.transform = CGAffineTransform(rotationAngle: .pi/3)
        return documentaryLabel
    }()

    private lazy var adventureLabel: UILabel = {
        var adventureLabel = UILabel(frame: CGRect(
            x: 100,
            y: -85,
            width: 176,
            height: 40
        ))
        setupLabel(label: adventureLabel)
        adventureLabel.text = Resources.SplashScreen.adventureText
        adventureLabel.transform = CGAffineTransform(rotationAngle: -.pi/6)
        return adventureLabel
    }()

    // MARK: - Initializers

    init(presenter: SplashScreenPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .baseBackground
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        setupConstraints()
        setupAnimationBehaviour()
        addTapRecognition()

        animationTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
            self.dismissSplashScreen()
        }
    }
}

extension SplashScreenViewController {
    // MARK: - Private methods

    private func setupConstraints() {
        var safeArea: UIEdgeInsets {
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            return scene?.windows.first?.safeAreaInsets ?? .zero
        }

        let rightViewX = view.safeAreaLayoutGuide.layoutFrame.width - 24
        let bottomViewY = view.safeAreaLayoutGuide.layoutFrame.maxY - 64
        let davayImageViewX = view.frame.width - 224
        let davayImageViewY = view.frame.height - safeArea.bottom - 77

        leftView.frame =  CGRect(x: 0, y: 0, width: 24, height: 1000)
        rightView.frame =  CGRect(x: rightViewX, y: 0, width: 24, height: 1000)
        bottomView.frame = CGRect(x: 0, y: bottomViewY, width: 1000, height: 32)
        topView.frame = CGRect(x: 0, y: safeArea.top, width: 1000, height: 32)
        davayImageView.frame = CGRect(x: davayImageViewX, y: davayImageViewY, width: 200, height: 45)

        [
            leftView,
            rightView,
            bottomView,
            topView,
            backgroundView
        ].forEach {
            $0.backgroundColor = .clear
        }

        [
            backgroundView,
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
            tapView
        ].forEach {
            view.addSubview($0)
        }

        [backgroundView, tapView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setupBackAndTapViewsConstraints()
    }

    private func setupBackAndTapViewsConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tapView.topAnchor.constraint(equalTo: view.topAnchor),
            tapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tapView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }

    private func setupAnimationBehaviour() {
        let labels = [
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
        ]

        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior(items: labels)
        let collision = UICollisionBehavior(items: labels)

        bordersTimer = Timer.scheduledTimer(withTimeInterval: 1.6, repeats: false) { _ in
            collision.addBoundary(
                withIdentifier: "topBorderIdent" as NSCopying,
                for: UIBezierPath(rect: self.topView.frame)
            )
            self.presenter?.startMoving(gravity: self.gravity)
        }

        collision.addBoundary(withIdentifier: "leftBorderIdent" as NSCopying, for: UIBezierPath(rect: leftView.frame))
        collision.addBoundary(withIdentifier: "rightBorderIdent" as NSCopying, for: UIBezierPath(rect: rightView.frame))
        collision.addBoundary(
            withIdentifier: "bottomBorderIdent" as NSCopying,
            for: UIBezierPath(rect: bottomView.frame)
        )
        collision.addBoundary(
            withIdentifier: "davayImageViewIdent" as NSCopying,
            for: UIBezierPath(rect: self.davayImageView.frame)
        )

        animator.addBehavior(gravity)
        animator.addBehavior(collision)
    }

    private func setupLabel(label: UILabel) {
        label.font = UIFont.textSplashFont
        label.textAlignment = .center
        label.textColor = UIColor.baseText
        label.backgroundColor = UIColor.attentionAdditional
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 16
    }

    private func addTapRecognition() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTapped(gestureRecognizer:)))
        tapView.addGestureRecognizer(tapRecognizer)
        tapRecognizer.delegate = self
        tapView.isUserInteractionEnabled = true
    }

    private func dismissSplashScreen() {
        animationTimer.invalidate()
        bordersTimer.invalidate()
        presenter?.splashDidFinish()
    }

    // MARK: - Handlers

    @objc private func screenTapped(gestureRecognizer: UITapGestureRecognizer) {
        dismissSplashScreen()
    }
}

// MARK: - SplashScreenViewControllerProtocol

extension SplashScreenViewController: SplashScreenViewControllerProtocol {}
