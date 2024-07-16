//
//  CoincidencesViewController.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 12.06.2024.
//

import UIKit

final class CoincidencesViewController: UIViewController {

    // MARK: - Stored Properties

    private var presenter: CoincidencesPresenterProtocol
    private var customNavBarModel: CustomNavBarModel?
    private var customNavBarRightButtonModel: CustomNavBarRightButtonModel?

    // MARK: - Lazy Properties

    private lazy var navBarView: CustomNavBar = {
        let navBar = CustomNavBar()
        navBar.setupCustomNavBar(with: customNavBarModel)
        return navBar
    }()

    private lazy var paddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        return view
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 12
        return stack
    }()

    private lazy var plugImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.emptyFolderPlug
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        return imageView
    }()

    private lazy var plugLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = Resources.Coincidences.plugLabelText
        label.textColor = .baseText
        label.font = .textLabelFont
        return label
    }()

    private lazy var collectionView: ReusableLikedMoviesUICollectionView = {
        let collectionView = ReusableLikedMoviesUICollectionView()
        collectionView.setupCollectionView(with: self)
        collectionView.isHidden = true

        return collectionView
    }()

    // MARK: - Initializers

    init(presenter: CoincidencesPresenterProtocol) {
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
        navigationController?.setNavigationBarHidden(true, animated: true)

        setupNavBarModel()
        setupSubviews()
        setupConstraints()

        presenter.downloadMoviesArrayFromServer()
    }
}

    // MARK: - Private methods

private extension CoincidencesViewController {

    func setupSubviews() {
        [collectionView, navBarView, paddingView, stackView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [plugImageView, plugLabel].forEach {
            stackView.addArrangedSubview($0)
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

            paddingView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            paddingView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            paddingView.topAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: 16),
            paddingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.centerXAnchor.constraint(equalTo: paddingView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor),

            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: -24),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupNavBarModel() {
        customNavBarModel = CustomNavBarModel(
            titleText: Resources.Coincidences.navBarText,
            subtitleText: nil,
            leftButtonImage: UIImage.customBackIcon,
            leftAction: { [weak self] in
                guard let self else { return }
                self.navigationController?.popViewController(animated: true)
            }
        )
    }

    func setupRightButtonModel() {
        customNavBarRightButtonModel = CustomNavBarRightButtonModel(
            rightButtonImage: UIImage.diceIcon,
            isRightButtonLabelHidden: true,
            rightButtonLabelText: nil,
            rightAction: { [weak self] in
                guard let self else { return }
                self.presenter.diceButtonTapped()
            }
        )
    }
}

    // MARK: - CoincidencesViewProtocol

extension CoincidencesViewController: CoincidencesViewProtocol {
    func updateUIElements() {
        if !presenter.isArrayEmpty {
            paddingView.isHidden = true
            stackView.isHidden = true
            collectionView.isHidden = false

            if presenter.moviesCount >= 3 {
                setupRightButtonModel()
                navBarView.setupRightButton(with: customNavBarRightButtonModel)
            }
        } else {
            paddingView.isHidden = false
            stackView.isHidden = false
            collectionView.isHidden = true
        }
    }
}

    // MARK: - UICollectionViewDataSource

extension CoincidencesViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return presenter.moviesCount
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ReusableLikedMoviesCell.reuseIdentifier,
                for: indexPath
              ) as? ReusableLikedMoviesCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(with: presenter.getMoviesAtIndex(index: indexPath.item))
        return cell
    }
}
