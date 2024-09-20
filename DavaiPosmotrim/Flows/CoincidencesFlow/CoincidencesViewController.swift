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
    private var paddingViewHeightAnchor: NSLayoutConstraint?

    private let params = CellGeometricParams(
        cellCount: 2,
        cellHeight: 240,
        cellSpacing: 16,
        lineSpacing: 16
    )

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

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            ReusableLikedMoviesCell.self,
            forCellWithReuseIdentifier: ReusableLikedMoviesCell.reuseIdentifier
        )
        collectionView.contentInset = UIEdgeInsets(top: 56, left: 16, bottom: 16, right: 16)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = false

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
        [
            paddingView,
            collectionView,
            navBarView,
            stackView
        ].forEach {
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

            stackView.centerXAnchor.constraint(equalTo: paddingView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor),

            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: -24),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        paddingViewHeightAnchor = paddingView.heightAnchor.constraint(equalTo: collectionView.heightAnchor)
        paddingViewHeightAnchor?.isActive = true
    }

    func setupNavBarModel() {
        customNavBarModel = CustomNavBarModel(
            titleText: Resources.Coincidences.navBarText,
            subtitleText: nil,
            leftButtonImage: UIImage.customBackIcon,
            leftAction: { [weak self] in
                guard let self else { return }
                self.presenter.backButtonTapped()
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
            stackView.isHidden = true
            collectionView.isHidden = false

            if presenter.moviesCount >= 3 {
                setupRightButtonModel()
                navBarView.setupRightButton(with: customNavBarRightButtonModel)
            }
        } else {
            stackView.isHidden = false
            collectionView.isHidden = true
        }
        collectionView.reloadData()
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

    // MARK: - UICollectionViewDelegateFlowLayout

extension CoincidencesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let collectionInset: CGFloat = 16
        let availableWidth = collectionView.frame.width - collectionInset * 2 - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)

        return CGSize(width: cellWidth, height: params.cellHeight)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return params.lineSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return params.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.coincidencesCellTapped()
    }
}

// MARK: - UIScrollViewDelegate

extension CoincidencesViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        paddingView.transform = CGAffineTransform(translationX: 0, y: min(-offset.y - scrollView.contentInset.top, 0))

        paddingViewHeightAnchor?.constant = max(0, offset.y + 40)
    }
}
