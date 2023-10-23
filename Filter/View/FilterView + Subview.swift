//
//  FilterView + AddSubview.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/17.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import UIKit

extension FilterView {
    
    
    func getContentView() -> UIView {
        return contentView.addSubviews {
            getDismissView()
            getScrollView()
        }
    }
    
    func getDismissView() -> UIView {
        return dismissInteractionView.addSubviews {
            dismissBar
            closeButton
        }
    }
    
    func getScrollView() -> UIScrollView {
        return scrollView.addSubviews {
            stackView.addArrangeSubviews(getStackView)
        }
    }
    
    func getStackView() -> [UIView] {
        var stack = [
            conditionFilterView,
            distanceFilterView,
            countryFilterView,
            paddingView
        ]
        
        // 스와이프에서는 컨디션필터뷰를 사용하지않는다
        if viewModel.dependLocation == .swipe {
            stack.removeFirst()
        }
        
        return stack
    }
    
    func getButtonGradientView() -> UIView {
        return buttonGradientView.addSubviews {
            buttonStackView.addArrangeSubviews {
                resetShadow.addSubviews { resetButton }
                confirmShadow.addSubviews { confirmButton }
            }
        }
    }
}
