//
//  CountryFilterView + Subview.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/19.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation

extension CountryFilterView {
    func configureStickyHeaderStackView() -> UIStackView {
        return stickyHeaderStackView.addArrangeSubviews {
            titleWrapperView.addSubviews {
                titleLabel
                toggleSwitch
            }
            paddingView
            tagStackWrapper.addSubviews { tagStackView }
        }
    }
    
    func configureWrapperStackView() -> UIStackView {
        return wrapperStackView.addArrangeSubviews {
            inputBarWrapper.addSubviews { inputBarView }
            continentWrapper.addSubviews { continentView }
            tableViewWrapper.addSubviews { tableView }
        }
    }
    
    func configureMoreButton() -> UIView {
        return moreButton.addSubviews {
            moreLabelWrapperView.addSubviews {
                moreLabel
                moreImage
            }
        }
    }
    
    func configureStackView() {
        stackView.addArrangeSubviews("") {
            configureStickyHeaderStackView()
            
            configureWrapperStackView()
            
            configureMoreButton()
        }
        
        self.stackView.bringSubviewToFront(stickyHeaderStackView)
    }
}
