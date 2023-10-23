//
//  DistanceFilterView + Constraint.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/19.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation
import SnapKit
extension DistanceFilterView {
    func setContainerViewConstraint() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setStackViewConstraint() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    func configureArrangeViewConstraint(){
        
        // 타이틀 & 토글
        titleWrapperView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
        }
        
        toggleSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(22)
        }
        
        sliderBar.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview().inset(4)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(36)
        }
    }
}
