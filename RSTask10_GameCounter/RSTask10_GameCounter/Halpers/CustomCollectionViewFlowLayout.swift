//
//  CustomCollectionViewFlowLayout.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 29.08.2021.
//

import Foundation
import UIKit

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var padding: CGFloat = 60
    override init() {
        super.init()
        self.scrollDirection = .horizontal
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let leftInset = padding
        let horizontalOffset = proposedContentOffset.x + leftInset // leftInset is for "where you want the item stop on the left"
        let targetRect = CGRect(origin: CGPoint(x: proposedContentOffset.x, y: 0), size: self.collectionView!.bounds.size)

        for layoutAttributes in super.layoutAttributesForElements(in: targetRect)! {
            let itemOffset = layoutAttributes.frame.origin.x
            if (abs(itemOffset - horizontalOffset) < abs(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        }

        let targetPoint = CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
        return targetPoint

    }
}
