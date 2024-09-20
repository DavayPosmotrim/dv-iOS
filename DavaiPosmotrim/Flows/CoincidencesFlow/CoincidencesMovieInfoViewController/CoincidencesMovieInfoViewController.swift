//
//  CoincidencesMovieInfoViewController.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 05.07.2024.
//

import UIKit

final class CoincidencesMovieInfoViewController: UIViewController {

    // MARK: - Stored Properties

    private var customNavBarModel: CustomNavBarModel?
    private var viewModel: SelectionMovieCellModel

    // MARK: - Lazy Properties

    private lazy var navBarView: CustomNavBar = {
        let navBar = CustomNavBar()
        navBar.setupCustomNavBar(with: customNavBarModel)
        return navBar
    }()

    private lazy var movieCard: CustomMovieSelection = {
        let view = CustomMovieSelection(model: viewModel)
        view.showButtons = false

        return view
    }()

    private lazy var movieInfo = CustomMovieDetails(model: viewModel.details, viewHeightValue: view.frame.height)

    // MARK: - Initializers

    init(viewModel: SelectionMovieCellModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .baseBackground

        setupNavBarModel()
        setupSubviews()
        setupConstraints()
    }
}

    // MARK: - Private methods

private extension CoincidencesMovieInfoViewController {

    func setupSubviews() {
        [navBarView, movieCard, movieInfo].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            navBarView.topAnchor.constraint(equalTo: view.topAnchor),
            navBarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            navBarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            navBarView.bottomAnchor.constraint(equalTo: safeArea.topAnchor, constant: 64),

            movieCard.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            movieCard.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            movieCard.topAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: 16),
            movieCard.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -67),

            movieInfo.topAnchor.constraint(equalTo: movieCard.bottomAnchor, constant: 16),
            movieInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieInfo.heightAnchor.constraint(equalToConstant: movieInfo.countViewHeight())
        ])
    }

    func setupNavBarModel() {
        customNavBarModel = CustomNavBarModel(
            titleText: Resources.Coincidences.navBarTitle,
            subtitleText: nil,
            leftButtonImage: UIImage.customBackIcon,
            leftAction: { [weak self] in
                guard let self else { return }
                self.navigationController?.popViewController(animated: true)
            }
        )
    }
}
