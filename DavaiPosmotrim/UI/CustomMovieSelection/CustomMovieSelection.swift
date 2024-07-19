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

    var showCollection: Bool = false {
        didSet {
            collectionView.isHidden = !showCollection

            let collectionOffset: CGFloat = -24
            informationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: collectionOffset).isActive = true
        }
    }

    var showMovieCountries: Bool = true {
        didSet {
            guard let additionalModel else { return }
            configureUpdatedModel(model: additionalModel)
        }
    }

    // MARK: - Private Properties

    private var genresMovie: [CollectionsCellModel] = []
    private var currentMovieId: UUID
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    private var additionalModel: SelectionMovieCellModel?

    // MARK: - Layout variables

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 24
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var nameMovieLabel: UILabel = {
        let label = UILabel()
        label.font = .textHeadingFont
        label.textColor = .headingText
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .textParagraphBoldFont
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
        button.setImage(UIImage.inactiveNoSelectionIcon, for: .normal)
        button.setImage(UIImage.activeNoSelectionIcon, for: .highlighted)
        button.addTarget(
            self,
            action: #selector(noButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var comeBackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.inactiveRotateIcon, for: .normal)
        button.setImage(UIImage.activeRotateIcon, for: .highlighted)
        button.addTarget(
            self,
            action: #selector(comeBackButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var yesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.inactiveLikeIcon, for: .normal)
        button.setImage(UIImage.activeLikeIcon, for: .highlighted)
        button.addTarget(
            self,
            action: #selector(yesButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var linearGradientView = UIView()

    private lazy var overlayYesView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteBackground.withAlphaComponent(0.7)
        return view
    }()

    private lazy var overlayNoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteBackground.withAlphaComponent(0.7)
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
        collectionView.layoutIfNeeded()
        updateCollectionViewHeightConstraint()
        resizeImage(for: collectionView.collectionViewLayout.collectionViewContentSize.height)
        linearGradientView.layer.sublayers?.first?.frame = linearGradientView.bounds
    }

    func updateModel(_ model: SelectionMovieCellModel) {
        configureWithModel(model: model)
        collectionView.reloadData()
    }

    func updateButtonImage(for percentage: CGFloat) {
        switch percentage {
        case let percentage where percentage > 0:
            yesButton.setImage(UIImage.activeLikeIcon, for: .normal)
            noButton.setImage(UIImage.inactiveNoSelectionIcon, for: .normal)
            overlayNoView.alpha = 0
            overlayYesView.alpha = 1 - percentage
        case let percentage where percentage < 0:
            noButton.setImage(UIImage.activeNoSelectionIcon, for: .normal)
            yesButton.setImage(UIImage.inactiveLikeIcon, for: .normal)
            overlayYesView.alpha = 0
            overlayNoView.alpha = 1 + percentage
        default:
            yesButton.setImage(UIImage.inactiveLikeIcon, for: .normal)
            noButton.setImage(UIImage.inactiveNoSelectionIcon, for: .normal)
            overlayYesView.alpha = 0
            overlayNoView.alpha = 0
        }
    }

    // MARK: - Actions

    @objc private func noButtonTapped() {
        noButton.setImage(UIImage.activeNoSelectionIcon, for: .normal)
        delegate?.noButtonTapped(withId: currentMovieId)
    }

    @objc private func comeBackButtonTapped() {
        delegate?.comeBackButtonTapped()
    }

    @objc private func yesButtonTapped() {
        yesButton.setImage(UIImage.activeLikeIcon, for: .normal)
        delegate?.yesButtonTapped(withId: currentMovieId)
    }
}

    // MARK: - Private Methods

private extension CustomMovieSelection {
    func configureWithModel(model: SelectionMovieCellModel) {
        additionalModel = model
        currentMovieId = model.id
        let image = UIImage(named: model.movieImage)
        imageView.image = image
        nameMovieLabel.text = model.nameMovieRu
        ratingLabel.text = model.ratingMovie
        ratingLabel.textColor =  Double(model.ratingMovie) ?? 0 < 7 ? .captionDarkText : .doneAdditional
        nameMovieEnLabel.text = model.nameMovieEn
        informationLabel.text = "\(model.yearMovie) · \(model.countryMovie.joined(separator: " · ")) · \(model.timeMovie)"
        self.genresMovie = model.genre
        updateButtonImage(for: 0)
    }

    func configureUpdatedModel(model: SelectionMovieCellModel) {
        informationLabel.text = "\(model.yearMovie) · \(model.timeMovie)"
    }

    func setupSubviews() {
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
        overlayYesView.translatesAutoresizingMaskIntoConstraints = false
        yesButton.addSubview(overlayYesView)
        overlayNoView.translatesAutoresizingMaskIntoConstraints = false
        noButton.addSubview(overlayNoView)
        gradientLayer(linearGradientView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            linearGradientView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            linearGradientView.topAnchor.constraint(equalTo: imageView.centerYAnchor),
            linearGradientView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            linearGradientView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),

            nameMovieLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameMovieLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            nameMovieLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            ratingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            ratingLabel.topAnchor.constraint(equalTo: nameMovieLabel.bottomAnchor, constant: 12),

            nameMovieEnLabel.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            nameMovieEnLabel.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 8),

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

    func updateCollectionViewHeightConstraint() {
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeightConstraint?.constant = contentHeight
    }

    func resizeImage(for collectionHeight: CGFloat) {
        let remainingHeight = calculateRemainingHeight(for: collectionHeight)
        let newSize = sizeForImage(from: remainingHeight)
        imageView.image = imageView.image?.resized(to: newSize)
    }

    func calculateRemainingHeight(for collectionHeight: CGFloat) -> CGFloat {
        let viewTotalHeight: CGFloat = frame.size.height
        let verticalPadding: CGFloat = showButtons ? 52 : 28
        let nameMovieLabelHeight = nameMovieLabel.intrinsicContentSize.height
        let ratingLabelHeight = ratingLabel.intrinsicContentSize.height
        let informationLabelHeight = informationLabel.intrinsicContentSize.height
        let buttonHeight = showButtons ? noButton.intrinsicContentSize.height : 0
        let totalHeight = nameMovieLabelHeight +
        ratingLabelHeight +
        informationLabelHeight +
        buttonHeight +
        collectionHeight +
        verticalPadding
        let remainingHeight = viewTotalHeight - totalHeight
        return remainingHeight
    }

    func sizeForImage(from remainingHeight: CGFloat) -> CGSize {
        return CGSize(width: frame.size.width, height: remainingHeight)
    }

    func gradientLayer(_ view: UIView) {
        let gradientLayer = CAGradientLayer()
        let startColor: UIColor = .white.withAlphaComponent(.zero)
        let endColor: UIColor = .white
        let gradientColors: [CGColor] = [startColor.cgColor, endColor.cgColor]
        gradientLayer.colors = gradientColors
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
        let genre = genresMovie[indexPath.item]
        cell.configure(model: genre)
        return cell
    }
}
