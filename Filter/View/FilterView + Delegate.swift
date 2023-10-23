//
//  FilterView + Delegate.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/19.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation
import UIKit

// MARK: UIScrollViewDelegate
extension FilterView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let headerOffsetY = countryFilterView.stickyHeaderStackView.bounds.minY
        
        // 408 => dismissInteractionView.bottom ~ stickyHeader.top 간격
        countryFilterView.stickyHeaderStackView.transform = CGAffineTransform(translationX: 0, y: max(0, offsetY - 408))
    
        // 597 => tableView의 frame y값
        scrollToTopButton.isHidden = offsetY < 597 ? true : false
    }
}
