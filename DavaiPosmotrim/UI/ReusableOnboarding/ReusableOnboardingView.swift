//
//  ReusableOnboardingView.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 06.06.2024.
//

import UIKit

struct PageModel {
    let image: UIImage
    let upperText: String
    let upperColoredText: String
    let lowerText: String
}

enum OnboardingEvent {
    case firstOnboarding
    case secondOnboarding
}

final class ReusableOnboardingView: UIView {

    // MARK: - Stored properties

    private var onboardingEvent: OnboardingEvent
    private var pages: [PageModel]
    private var nextButtonAction: (() -> Void)?

    // MARK: - Lazy properties

    private lazy var upperPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true

        return view
    }()

    private lazy var lowerPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true

        return view
    }()

    private lazy var nextButton: UIView = {
        let button = CustomButtons()
        button.setupView(with: button.purpleButton)
        button.purpleButton.setTitle(Resources.Onboarding.nextButtonText, for: .normal)
        button.purpleButton.addTarget(self, action: #selector(didTapNextButton(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var beginButton: UIView = {
        let button = CustomButtons()
        button.setupView(with: button.purpleButton)
        button.purpleButton.setTitle(Resources.Onboarding.beginButtonText, for: .normal)
        button.purpleButton.addTarget(self, action: #selector(didTapBeginButton(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(
            ReusableOnboardingCollectionViewCell.self,
            forCellWithReuseIdentifier: ReusableOnboardingCollectionViewCell.reuseIdentifier
        )
        collectionView.isPagingEnabled = true
        collectionView.bouncesZoom = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false

        return collectionView
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = .zero
        pageControl.currentPageIndicatorTintColor = .basePrimaryAccent
        pageControl.pageIndicatorTintColor = .lightTertiaryAccent
        pageControl.addTarget(self, action: #selector(pageChanged(sender:)), for: .valueChanged)
        return pageControl
    }()

    // MARK: - Initializers

    init(frame: CGRect, onboardingEvent: OnboardingEvent, pages: [PageModel]) {
        self.onboardingEvent = onboardingEvent
        self.pages = pages
        super.init(frame: frame)

        backgroundColor = .baseBackground

        collectionView.dataSource = self
        collectionView.delegate = self

        setupSubviews()
        setupConstraints()
        toggleButtons()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func setupNextButtonAction(with buttonAction: (() -> Void)?) {
        guard let buttonAction else { return }
        nextButtonAction = buttonAction
    }

    // MARK: - Private methods

    private func setupSubviews() {
        [
            upperPaddingView,
            collectionView,
            pageControl,
            lowerPaddingView,
            nextButton,
            beginButton
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            upperPaddingView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            upperPaddingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            upperPaddingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            upperPaddingView.bottomAnchor.constraint(equalTo: lowerPaddingView.topAnchor, constant: -16),

            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: upperPaddingView.topAnchor, constant: 32),
            collectionView.bottomAnchor.constraint(equalTo: upperPaddingView.bottomAnchor, constant: -73),

            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: upperPaddingView.bottomAnchor, constant: -28),

            lowerPaddingView.bottomAnchor.constraint(equalTo: bottomAnchor),
            lowerPaddingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lowerPaddingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lowerPaddingView.topAnchor.constraint(equalTo: bottomAnchor, constant: -80),

            beginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            beginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            beginButton.topAnchor.constraint(equalTo: lowerPaddingView.topAnchor, constant: 16),
            beginButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            nextButton.leadingAnchor.constraint(equalTo: beginButton.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: beginButton.trailingAnchor),
            nextButton.topAnchor.constraint(equalTo: beginButton.topAnchor),
            nextButton.bottomAnchor.constraint(equalTo: beginButton.bottomAnchor)
        ])
    }

    private func toggleButtons() {
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
            beginButton.isHidden = false
            nextButton.isHidden = true
        } else {
            beginButton.isHidden = true
            nextButton.isHidden = false
        }
    }

    // MARK: - Handlers

    @objc private func didTapNextButton(sender: AnyObject) {
        guard let currentIndexPath = collectionView.indexPathsForVisibleItems.first
        else {
            return
        }
        let newIndexPath = IndexPath(item: currentIndexPath.item + 1, section: .zero)

        if newIndexPath.item < pages.count {
            collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: true)
            pageControl.currentPage += 1
        }
        toggleButtons()
    }

    @objc private func didTapBeginButton(sender: AnyObject) {
        nextButtonAction?()
    }

    @objc private func pageChanged(sender: AnyObject) {
        guard let pageControl = sender as? UIPageControl else { return }
        collectionView.scrollToItem(
            at: IndexPath(item: pageControl.currentPage, section: .zero),
            at: .centeredHorizontally,
            animated: true
        )
        toggleButtons()
    }
}

    // MARK: - UICollectionViewDataSource

extension ReusableOnboardingView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ReusableOnboardingCollectionViewCell.reuseIdentifier,
            for: indexPath) as? ReusableOnboardingCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        let currentPage = pages[indexPath.item]
        cell.configureCell(with: currentPage, event: onboardingEvent, indexPath: indexPath)

        return cell
    }
}

    // MARK: - UICollectionViewDataSource

extension ReusableOnboardingView: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: collectionView.frame.width,
            height: collectionView.frame.height
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return .zero
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return .zero
    }
}

    // MARK: - UIScrollViewDelegate

extension ReusableOnboardingView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        pageControl.currentPage = currentPage
        toggleButtons()
    }
}
