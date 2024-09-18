//
//  CellGeometricParams.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 24.06.2024.
//

import Foundation

struct CellGeometricParams {
    let cellCount: Int
    let cellSpacing: CGFloat
    let lineSpacing: CGFloat
    let cellHeight: CGFloat

    let paddingWidth: CGFloat

    init(cellCount: Int, cellHeight: CGFloat, cellSpacing: CGFloat, lineSpacing: CGFloat) {
        self.cellCount = cellCount
        self.cellHeight = cellHeight
        self.cellSpacing = cellSpacing
        self.lineSpacing = lineSpacing

        self.paddingWidth = CGFloat(cellCount - 1) * cellSpacing
    }
}
