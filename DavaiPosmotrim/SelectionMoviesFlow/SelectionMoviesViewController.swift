//
//  SelectionMoviesViewController.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 30.05.24.
//

import Foundation

import UIKit

final class SelectionMoviesViewController: UIViewController {

    // MARK: - Public Properties

    var presenter: SelectionMoviesPresenter?

    // MARK: - Private Properties

    private var currentMovieId: UUID?
    private enum Keys: String {
        case titleNavBarText = "Выберите фильм"
    }

    // MARK: - Layout variables

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .baseBackground
        return view
    }()

    private lazy var upperPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        return view
    }()

    private lazy var customNavBar: UIView = {
        let customNavBar = CustomNavigationBarTwoButtons(
            title: Keys.titleNavBarText.rawValue,
            imageBatton: "likeIcon"
        )
        customNavBar.delegate = self
        return customNavBar
    }()

    private lazy var centralPaddingView: CustomMovieSelection = {
        guard let presenter = presenter,
              let firstSelection = presenter.getFirstMovie() else {
            fatalError("Presenter or selectionsMovie is empty")
        }
        self.currentMovieId = firstSelection.id
        let view = CustomMovieSelection(model: firstSelection)
        view.showButtons = true
        if view.showButtons {
            view.isUserInteractionEnabled = true
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            view.addGestureRecognizer(panGesture)
            view.delegate = self
        }
        return view
    }()

    // MARK: - Initializers

    init(presenter: SelectionMoviesPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        setupConstraints()
    }

    // MARK: - Actions

    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let percentage = translation.x / view.bounds.width
        let rotationAngle: CGFloat = .pi / 6 * percentage
        switch gesture.state {
        case .changed:
            centralPaddingView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            centralPaddingView.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y / 2)
            self.centralPaddingView.updateYesButtonImage(for: percentage)
        case .ended:
            let velocity = gesture.velocity(in: view)
            if abs(velocity.x) > 500 {
                let direction: CGFloat = velocity.x > 0 ? 1 : -1
                animateSwipe(direction: direction)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.centralPaddingView.transform = .identity
                    self.centralPaddingView.center = self.view.center
                }, completion: { _ in
                    self.centralPaddingView.updateYesButtonImage(for: 0)
                })
            }
        default:
            break
        }
    }
}

// MARK: - Private methods

private extension SelectionMoviesViewController {
    func setupSubviews() {
        [
            backgroundView,
            centralPaddingView,
            upperPaddingView,
            customNavBar
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            upperPaddingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            upperPaddingView.topAnchor.constraint(equalTo: view.topAnchor),
            upperPaddingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            upperPaddingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            centralPaddingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            centralPaddingView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: 16),
            centralPaddingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            centralPaddingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -67)
        ])
    }

    func updateRandomMatchCount() {
        if let customNavBar = customNavBar as? CustomNavigationBarTwoButtons,
           let randomMatchCount = presenter?.getRandomMatchCount() {
            customNavBar.updateMatchCountLabel(withRandomCount: randomMatchCount)
        }
    }

    func showNextMovie() {
        guard let nextModel = presenter?.getNextMovie() else {
            return
        }
        centralPaddingView.updateModel(nextModel)
        updateRandomMatchCount()
    }

    func showComeMovie() {
        guard let nextModel = presenter?.getPreviousMovie() else {
            return
        }
        centralPaddingView.updateModel(nextModel)
    }
    
    func animateSwipe(direction: CGFloat) {
        guard let currentMovieId = currentMovieId else {
            return
        }
        let translationX: CGFloat = direction * view.bounds.width
        let rotationAngle: CGFloat = direction * .pi / 6
        UIView.animate(withDuration: 0.5, animations: {
            self.centralPaddingView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            self.centralPaddingView.center = CGPoint(x: self.view.center.x + translationX, y: self.view.center.y)
            self.centralPaddingView.alpha = 0
        }) { _ in
            self.centralPaddingView.alpha = 0
            self.centralPaddingView.transform = .identity
            self.centralPaddingView.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.centralPaddingView.alpha = 1
            }
            if direction > 0 {
                self.presenter?.addToLikedMovies(withId: currentMovieId)
                self.showNextMovie()
            } else {
                self.presenter?.removeFromLikedMovies(withId: currentMovieId)
                self.showNextMovie()
            }
        }
    }

    func animateOffscreen(direction: CGFloat, completion: @escaping () -> Void) {
        let viewWidth = centralPaddingView.bounds.width
        let screenWidth = UIScreen.main.bounds.width
        let translationTransform = CGAffineTransform(translationX: direction * (screenWidth + viewWidth), y: 0)
        let rotationAngle: CGFloat = direction * .pi / 6
        UIView.animate(withDuration: 0.7, animations: {
            let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
            let combinedTransform = rotationTransform.concatenating(translationTransform)
            self.centralPaddingView.transform = combinedTransform
            self.centralPaddingView.alpha = 0
        }) { _ in
            self.centralPaddingView.transform = .identity
            self.centralPaddingView.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.centralPaddingView.alpha = 1
            }
            completion()
        }
    }
}

// MARK: - CustomMovieSelectionDelegate

extension SelectionMoviesViewController: CustomMovieSelectionDelegate {
    func noButtonTapped(withId id: UUID) {
        presenter?.removeFromLikedMovies(withId: id)
        animateOffscreen(direction: -1) {
            self.showNextMovie()
        }
    }

    func yesButtonTapped(withId id: UUID) {
        presenter?.addToLikedMovies(withId: id)
        animateOffscreen(direction: 1) {
            self.showNextMovie()
        }
    }

    func comeBackButtonTapped() {
        self.showComeMovie()
        let originalFrame = self.centralPaddingView.frame
        let originalTransform = self.centralPaddingView.transform
        let startY = self.customNavBar.frame.maxY - originalFrame.height
        var startFrame = originalFrame
        startFrame.origin.y = startY
        self.centralPaddingView.frame = startFrame
        self.centralPaddingView.transform = CGAffineTransform(
            scaleX: self.view.frame.width / originalFrame.width,
            y: 1.0
        )
        UIView.animate(withDuration: 0.7, animations: {
            self.centralPaddingView.transform = .identity
            self.centralPaddingView.frame = originalFrame
        })
        UIView.animate(
            withDuration: 0.7,
            delay: 0.7,
            options: [],
            animations: {
                self.centralPaddingView.transform = originalTransform
            },
            completion: nil
        )
    }
}

// MARK: - CustomNavigationBarDelegate

extension SelectionMoviesViewController: CustomNavigationBarTwoButtonsDelegate {
    func matchRightButtonTapped() {
        guard let navigationController = navigationController else { return }
        let coincidencesViewController = CoincidencesViewController()
        navigationController.pushViewController(coincidencesViewController, animated: true)
    }

    func backButtonTapped() {
        guard let navigationController = navigationController else { return }
        navigationController.popViewController(animated: true)
    }
}
