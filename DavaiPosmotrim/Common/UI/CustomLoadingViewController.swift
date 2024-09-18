//
//  LoadingViewController.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 08.08.24.
//

import UIKit

final class CustomLoadingViewController: UIViewController {

    private lazy var loaderView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.loader
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .baseTertiaryAccent.withAlphaComponent(0.3)
        view.addSubview(loaderView)
        setupConstraints()
        startLoadingAnimation()
    }

    static func show(in parent: UIViewController) -> CustomLoadingViewController {
        let loadingVC = CustomLoadingViewController()
        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve
        parent.present(loadingVC, animated: true, completion: nil)
        return loadingVC
    }

    func hide() {
        self.dismiss(animated: true, completion: nil)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loaderView.widthAnchor.constraint(equalToConstant: 80),
            loaderView.heightAnchor.constraint(equalToConstant: 80),
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func startLoadingAnimation() {
        let rotation = CABasicAnimation(keyPath: Resources.LoadingKeys.keyPath)
        rotation.toValue = NSNumber(value: 2 * Double.pi)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.infinity
        loaderView.layer.add(rotation, forKey: Resources.LoadingKeys.forKey)
    }
}
