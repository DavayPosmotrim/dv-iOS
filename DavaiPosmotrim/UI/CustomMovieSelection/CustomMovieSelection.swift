//
//  CustomMovieSelection.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 01.06.24.
//

import UIKit

protocol CustomMovieSelectionDelegate: AnyObject {
    func noButtonTapped(withId id: UUID)
    func yesButtonTapped(withId id: UUID)
    func comeBackButtonTapped()
}

class CustomMovieSelection: UIView {

    // MARK: - Public Properties

    weak var delegate: CustomMovieSelectionDelegate?
    var showButtons: Bool = false {
        didSet {
            noButton.isHidden = !showButtons
            comeBackButton.isHidden = !showButtons
            yesButton.isHidden = !showButtons
            let buttonOffset: CGFloat = -8
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: buttonOffset).isActive = true
        }
    }

    // MARK: - Private Properties

    private var genresMovie: [CollectionsCellModel] = []
    private var currentMovieId: UUID
    private var collectionViewHeightConstraint: NSLayoutConstraint?

    // MARK: - Layout variables

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 24
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var nameMovieLabel: UILabel = {
        let label = UILabel()
        label.font = .textHeadingFont
        label.textColor = .headingText
        return label
    }()

    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .textParagraphBoldFont
        label.textColor = .doneAdditional
        return label
    }()

    private lazy var nameMovieEnLabel: UILabel = {
        let label = UILabel()
        label.font = .textParagraphRegularFont
        label.textColor = .baseText
        return label
    }()

    private lazy var informationLabel: UILabel = {
        let label = UILabel()
        label.font = .textCaptionRegularFont
        label.textColor = .baseText
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewLayout.createLeftAlignedLayout(itemHeight: 28)
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            CustomMovieCollectionCell.self,
            forCellWithReuseIdentifier: CustomMovieCollectionCell.reuseIdentifier
        )
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    private lazy var noButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "inactiveNoSelectionIcon"), for: .normal)
        button.addTarget(
            self,
            action: #selector(noButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var comeBackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "inactiveRotateIcon"), for: .normal)
        button.addTarget(
            self,
            action: #selector(comeBackButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var yesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "inactiveLikeIcon"), for: .normal)
        button.addTarget(
            self,
            action: #selector(yesButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var linearGradientView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var overlayYesView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        return view
}()

    private lazy var overlayNoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        return view
}()

    // MARK: - Initializers

    init(model: SelectionMovieCellModel) {
        self.currentMovieId = model.id
        super.init(frame: .zero)
        backgroundColor = .whiteBackground
        layer.cornerRadius = 24
        collectionView.dataSource = self
        setupSubviews()
        setupConstraints()
        updateModel(model)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    override func layoutSubviews() {
        super.layoutSubviews()
        linearGradientView.layer.sublayers?.first?.frame = linearGradientView.bounds
    }

    func updateModel(_ model: SelectionMovieCellModel) {
        configureWithModel(model: model)
        collectionView.reloadData()
        updateCollectionViewHeightConstraint()
    }

    func updateYesButtonImage(for percentage: CGFloat) {
        if percentage > 0 {
            yesButton.setImage(UIImage(named: "activeLikeIcon"), for: .normal)
            overlayYesView.alpha = 1 - percentage
        } else if percentage < 0 {
            noButton.setImage(UIImage(named: "activeNoSelectionIcon"), for: .normal)
            overlayNoView.alpha = 1 + percentage
        } else {
            yesButton.setImage(UIImage(named: "inactiveLikeIcon"), for: .normal)
            noButton.setImage(UIImage(named: "inactiveNoSelectionIcon"), for: .normal)
            overlayYesView.alpha = 0
            overlayNoView.alpha = 0
        }
    }

    // MARK: - Actions

    @objc private func noButtonTapped() {
        delegate?.noButtonTapped(withId: currentMovieId)
    }

    @objc private func comeBackButtonTapped() {
        delegate?.comeBackButtonTapped()
    }

    @objc private func yesButtonTapped() {
        delegate?.yesButtonTapped(withId: currentMovieId)
    }

    // MARK: - Private Methods

    private func configureWithModel(model: SelectionMovieCellModel) {
        self.currentMovieId = model.id
        let image = UIImage(named: model.movieImage)
        imageView.image = image
        nameMovieLabel.text = model.nameMovieRu
        ratingLabel.text = model.ratingMovie
        nameMovieEnLabel.text = model.nameMovieEn
        informationLabel.text = "\(model.yearMovie) · \(model.countryMovie.joined(separator: " · ")) · \(model.timeMovie)"
        self.genresMovie = model.genre
        updateYesButtonImage(for: 0)
    }

    private func setupSubviews() {
        [
            imageView,
            linearGradientView,
            nameMovieLabel,
            ratingLabel,
            nameMovieEnLabel,
            informationLabel,
            collectionView,
            noButton,
            comeBackButton,
            yesButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        [overlayYesView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            yesButton.addSubview($0)
        }
        [overlayNoView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            noButton.addSubview($0)
        }
        gradientLayer(linearGradientView)
    }

    private func setupConstraints() {
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(
            equalToConstant: calculateCollectionViewHeight()
        )
        collectionViewHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 584),

            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            linearGradientView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            linearGradientView.topAnchor.constraint(equalTo: imageView.centerYAnchor),
            linearGradientView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            linearGradientView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),

            nameMovieLabel.heightAnchor.constraint(equalToConstant: 28),
            nameMovieLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameMovieLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            nameMovieLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            ratingLabel.heightAnchor.constraint(equalToConstant: 20),
            ratingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            ratingLabel.topAnchor.constraint(equalTo: nameMovieLabel.bottomAnchor, constant: 12),

            nameMovieEnLabel.heightAnchor.constraint(equalToConstant: 20),
            nameMovieEnLabel.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            nameMovieEnLabel.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 8),

            informationLabel.heightAnchor.constraint(equalToConstant: 16),
            informationLabel.leadingAnchor.constraint(equalTo: ratingLabel.leadingAnchor),
            informationLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 8),

            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: informationLabel.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),

            noButton.widthAnchor.constraint(equalToConstant: 48),
            noButton.heightAnchor.constraint(equalToConstant: 48),
            noButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            noButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            noButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),

            comeBackButton.widthAnchor.constraint(equalToConstant: 40),
            comeBackButton.heightAnchor.constraint(equalToConstant: 40),
            comeBackButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            comeBackButton.centerYAnchor.constraint(equalTo: noButton.centerYAnchor),

            yesButton.widthAnchor.constraint(equalToConstant: 48),
            yesButton.heightAnchor.constraint(equalToConstant: 48),
            yesButton.centerYAnchor.constraint(equalTo: noButton.centerYAnchor),
            yesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            overlayYesView.widthAnchor.constraint(equalTo: yesButton.widthAnchor),
            overlayYesView.heightAnchor.constraint(equalTo: yesButton.heightAnchor),
            overlayYesView.centerXAnchor.constraint(equalTo: yesButton.centerXAnchor),
            overlayYesView.centerYAnchor.constraint(equalTo: yesButton.centerYAnchor),

            overlayNoView.widthAnchor.constraint(equalTo: noButton.widthAnchor),
            overlayNoView.heightAnchor.constraint(equalTo: noButton.heightAnchor),
            overlayNoView.centerXAnchor.constraint(equalTo: noButton.centerXAnchor),
            overlayNoView.centerYAnchor.constraint(equalTo: noButton.centerYAnchor)
        ])
    }

    private func calculateCollectionViewHeight() -> CGFloat {
        let rowCount = genresMovie.count
        if rowCount > 3 {
            return 96
        } else {
            return 60
        }
    }

    private func updateCollectionViewHeightConstraint() {
        let collectionViewHeight = calculateCollectionViewHeight()
        collectionViewHeightConstraint?.constant = collectionViewHeight
        layoutIfNeeded()
    }

    private func gradientLayer(_ view: UIView) {
        let gradientLayer = CAGradientLayer()
        let startColor: UIColor = .white.withAlphaComponent(.zero)
        let endColor: UIColor = .white
        let gradientColors: [CGColor] = [startColor.cgColor, endColor.cgColor]
        gradientLayer.colors = gradientColors
        let radius = view.bounds.width / 2.0
        gradientLayer.cornerRadius = radius
        gradientLayer.frame = view.bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

// MARK: - UICollectionViewDataSource

extension CustomMovieSelection: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return genresMovie.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomMovieCollectionCell.reuseIdentifier,
            for: indexPath
        ) as? CustomMovieCollectionCell else {
            return UICollectionViewCell()
        }
        let genre = genresMovie[indexPath.row]
        cell.configure(model: genre)
        return cell
    }
}
