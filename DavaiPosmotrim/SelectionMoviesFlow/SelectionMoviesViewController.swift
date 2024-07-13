//
//  SelectionMoviesViewController.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 30.05.24.
//

import UIKit

final class SelectionMoviesViewController: UIViewController {

    // MARK: - Public Properties

    var presenter: SelectionMoviesPresenter
   private var matchSelectionVC: MatchSelectionMoviesViewController?

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
            title: Resources.SelectionMovies.titleNavBarText,
            imageButton: "likeIcon"
        )
        customNavBar.delegate = self
        return customNavBar
    }()

    private lazy var centralPaddingView: CustomMovieSelection = {
        let firstSelection = presenter.getFirstMovie()
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
        view.backgroundColor = .whiteBackground
        setupSubviews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - Actions

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let percentage = translation.x / view.bounds.width
        let rotationAngle: CGFloat = .pi / 6 * percentage
        switch gesture.state {
        case .changed:
            centralPaddingView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            centralPaddingView.center = CGPoint(x: view.center.x + translation.x, y: centralPaddingView.center.y)
            self.centralPaddingView.updateButtonImage(for: percentage)
        case .ended:
            let velocity = gesture.velocity(in: view)
            if abs(velocity.x) > 500 {
                let direction: CGFloat = velocity.x > 0 ? 1 : -1
                animateSwipe(direction: direction)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.centralPaddingView.transform = .identity
                    self.centralPaddingView.center = CGPoint(x: self.view.center.x, y: self.centralPaddingView.center.y)
                }, completion: { _ in
                    self.centralPaddingView.updateButtonImage(for: 0)
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

    func animateSwipe(direction: CGFloat) {
        guard let currentMovieId = presenter.currentMovieId else {
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
            self.presenter.swipeNextMovie(withId: currentMovieId, direction: direction)
        }
    }

    func animateComeBack() {
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

    func animateMatchViewControllerToHeartIcon() {
        guard let matchVC = matchSelectionVC,
              let customNavBar = customNavBar as? CustomNavigationBarTwoButtons else { return }
        let heartIconFrame = customNavBar.matchRightButton.convert(customNavBar.matchRightButton.bounds, to: view)
        let scaleX = heartIconFrame.width / matchVC.view.bounds.width
        let scaleY = heartIconFrame.height / matchVC.view.bounds.height
        let translationX = heartIconFrame.midX - matchVC.view.center.x
        let translationY = heartIconFrame.midY - matchVC.view.center.y
        UIView.animate(withDuration: 0.5, animations: {
            matchVC.view.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
                .concatenating(CGAffineTransform(translationX: translationX, y: translationY))
        }) { _ in
            matchVC.dismiss(animated: false, completion: nil)
            self.presenter.updateRandomMatchCount()
        }
    }
}

// MARK: - SelectionMoviesViewProtocol

extension SelectionMoviesViewController: SelectionMoviesViewProtocol {
    func updateMatchCountLabel(withRandomCount count: Int) {
        if let customNavBar = customNavBar as? CustomNavigationBarTwoButtons {
            customNavBar.updateMatchCountLabel(withRandomCount: count)
        }
    }

    func showNextMovie(_ nextModel: SelectionMovieCellModel) {
        centralPaddingView.updateModel(nextModel)
    }

    func showPreviousMovie(_ nextModel: SelectionMovieCellModel) {
        centralPaddingView.updateModel(nextModel)
        animateComeBack()
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

    func showCancelSessionDialog() {
        guard let navigationController else { return }
        let viewController = DismissSelectionMoviesViewController()
        viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        navigationController.present(viewController, animated: true)
    }

    func showMatch(matchModel: SelectionMovieCellModel) {
        guard let navigationController else { return }
        let viewController = MatchSelectionMoviesViewController(matchSelection: matchModel)
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        navigationController.present(viewController, animated: true)
        self.matchSelectionVC = viewController
        viewController.dismissCompletion = { [weak self] in
            self?.animateMatchViewControllerToHeartIcon()
        }
    }
}

// MARK: - CustomMovieSelectionDelegate

extension SelectionMoviesViewController: CustomMovieSelectionDelegate {
    func noButtonTapped(withId id: UUID) {
        presenter.noButtonTapped(withId: id)
    }

    func yesButtonTapped(withId id: UUID) {
        presenter.yesButtonTapped(withId: id)
    }

    func comeBackButtonTapped() {
        presenter.comeBackButtonTapped()
    }
}

// MARK: - CustomNavigationBarTwoButtonsDelegate

extension SelectionMoviesViewController: CustomNavigationBarTwoButtonsDelegate {
    func matchRightButtonTapped() {
        presenter.didTapMatchRightButton()
    }

    func backButtonTapped() {
        presenter.cancelButtonTapped()
    }
}

// MARK: - DismissJoinSessionDelegate

extension SelectionMoviesViewController: DismissSelectionMoviesDelegate {
    func finishSelectionMoviesFlow() {
        presenter.cancelButtonAlertTapped()
    }
}
