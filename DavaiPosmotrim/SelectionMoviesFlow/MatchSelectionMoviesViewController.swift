//
//  MatchSelectionMoviesViewController.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 10.07.24.
//

import UIKit

final class MatchSelectionMoviesViewController: UIViewController {

    // MARK: - Stored properties

    var matchSelection: SelectionMovieCellModel?
    var dismissCompletion: (() -> Void)?

    // MARK: - Lazy properties

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .baseBackground
        return view
    }()

    private lazy var centralPaddingView: CustomMovieSelection = {
        guard let matchSelection = matchSelection else {
            fatalError("Match selection model is required.")
        }
        let view = CustomMovieSelection(model: matchSelection)
        view.showButtons = false
        return view
    }()

    private lazy var lookImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.coincidencelabel)
        imageView.alpha = 0
        return imageView
    }()

    private lazy var lowerPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 24
        return view
    }()

    private lazy var progressButton: CustomButtons = {
        let button = CustomButtons()
        button.setupView(with: button.progressButton)
        button.progressButton.setTitle(Resources.SelectionMovies.continueButtonText, for: .normal)
        button.progressButton.addTarget(
            self,
            action: #selector(didTapProgressButton),
            for: .touchUpInside
        )
        button.onProgressComplete = { [weak self] in
            print("Progress completed")
            self?.closeViewController()
        }
        return button
    }()

    // MARK: - Lifecycle

    init(matchSelection: SelectionMovieCellModel?) {
        self.matchSelection = matchSelection
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteBackground
        setupSubviews()
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateImageViewAppearance()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        progressButton.startProgress(duration: 4)
    }

    // MARK: - Actions

    @objc private func didTapProgressButton() {
        closeViewController()
    }

    // MARK: - Private methods

    private func animateImageViewAppearance() {
        lookImageView.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
        UIView.animate(withDuration: 0.2, animations: {
            self.lookImageView.transform = .identity
            self.lookImageView.alpha = 1
        }, completion: nil)
    }

    private func closeViewController() {
        self.dismissCompletion?()
    }

    private func setupSubviews() {
        [
            backgroundView,
            lowerPaddingView,
            centralPaddingView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        [lookImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            centralPaddingView.addSubview($0)
        }
        [progressButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            lowerPaddingView.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            lowerPaddingView.heightAnchor.constraint(equalToConstant: 84),
            lowerPaddingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lowerPaddingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lowerPaddingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            centralPaddingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            centralPaddingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            centralPaddingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            centralPaddingView.bottomAnchor.constraint(equalTo: lowerPaddingView.topAnchor, constant: -16),

            lookImageView.heightAnchor.constraint(equalToConstant: 136),
            lookImageView.widthAnchor.constraint(equalToConstant: 320),
            lookImageView.centerXAnchor.constraint(equalTo: centralPaddingView.centerXAnchor),
            lookImageView.centerYAnchor.constraint(equalTo: centralPaddingView.centerYAnchor),

            progressButton.heightAnchor.constraint(equalToConstant: 48),
            progressButton.leadingAnchor.constraint(equalTo: lowerPaddingView.leadingAnchor, constant: 16),
            progressButton.topAnchor.constraint(equalTo: lowerPaddingView.topAnchor, constant: 16),
            progressButton.trailingAnchor.constraint(equalTo: lowerPaddingView.trailingAnchor, constant: -16)
        ])
    }
}
