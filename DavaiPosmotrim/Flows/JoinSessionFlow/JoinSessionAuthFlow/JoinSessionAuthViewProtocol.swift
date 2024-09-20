//
//  JoinSessionAuthViewProtocol.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.07.2024.
//

import UIKit

protocol JoinSessionAuthViewProtocol: AnyObject {
    func updateUIElements(
        text: String?,
        font: UIFont?,
        labelIsHidden: Bool,
        buttonIsEnabled: Bool
    )
}
