//
//  DistanceFilterView + AddSubViews.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/19.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation
import UIKit

extension DistanceFilterView {
    
    func configureContainerView() {
        self.addSubview(containerView)
    }
    
    func configureStackView() {
        containerView.addSubview(stackView)
    }
    
    func configureArrangeView(){
        stackView.addArrangeSubviews("래퍼 스택뷰") {
            titleWrapperView.addSubviews {
                titleLabel
                toggleSwitch
            }
            
            distanceWrapperView.addSubviews {
                labelStackView.addArrangeSubviews {
                    upToOrFromLabel
                    minDistanceLabel
                    toLabel
                    maxDistanceLabel
                    awayLabel
                    emptyView
                }
                
                sliderBar
            }
            
        }
    }
}
