//
//  SelectionMoviesViewController.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 30.05.24.
//

import Foundation

import UIKit

final class SelectionMoviesViewController: UIViewController {

    // MARK: - Private Properties

    private var selectionsMovie = selectionMovieMockData
    private var currentIndex: Int = 0
    private var likedMovies: [UUID] = []
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
        guard let firstSelection = selectionsMovie.first else {
            fatalError("selectionsMovie is empty")
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
        let rotationAngle: CGFloat = .pi / 3 * percentage
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

//            centralPaddingView.heightAnchor.constraint(equalToConstant: 584),
            centralPaddingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            centralPaddingView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: 16),
            centralPaddingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            centralPaddingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -67)
        ])
    }

    func updateRandomMatchCount() {
        let randomMatchCount = Int.random(in: 0...10)
        if let customNavBar = customNavBar as? CustomNavigationBarTwoButtons {
            customNavBar.updateMatchCountLabel(withRandomCount: randomMatchCount)
        }
    }

    func showNextMovie() {
        currentIndex += 1
        guard currentIndex < selectionsMovie.count else { return }
        let nextModel = selectionsMovie[currentIndex]
        centralPaddingView.updateModel(nextModel)
        updateRandomMatchCount()
    }

    func showComeMovie() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        let nextModel = selectionsMovie[currentIndex]
        centralPaddingView.updateModel(nextModel)
    }

    func animateSwipe(direction: CGFloat) {
        guard let currentMovieId = currentMovieId else {
            return
        }
        let translationX: CGFloat = direction * view.bounds.width
        let rotationAngle: CGFloat = direction * .pi / 20
        UIView.animate(withDuration: 0.5, animations: {
            self.centralPaddingView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            self.centralPaddingView.center = CGPoint(x: self.view.center.x + translationX, y: self.view.center.y)
            self.centralPaddingView.alpha = 0
        }) { _ in
            self.centralPaddingView.transform = .identity
            self.centralPaddingView.alpha = 1
            self.centralPaddingView.center = self.view.center
            if direction > 0 {
                self.yesButtonTapped(withId: currentMovieId)
            } else {
                self.noButtonTapped(withId: currentMovieId)
            }
        }
    }
}

// MARK: - CustomMovieSelectionDelegate

extension SelectionMoviesViewController: CustomMovieSelectionDelegate {
    func noButtonTapped(withId id: UUID) {
        if likedMovies.contains(id) {
            likedMovies.removeAll { $0 == id }
        }
        showNextMovie()
    }

    func yesButtonTapped(withId id: UUID) {
        likedMovies.append(id)
        showNextMovie()
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
