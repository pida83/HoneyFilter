//
//  CountryFilterView + Constraint.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/19.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
extension CountryFilterView {
    func setStickyHeaderStackViewConstraint() {
        
        // 타이틀 + 국가 태그 Sticky
        stickyHeaderStackView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }

        // 타이틀 & 토클 버튼
        titleWrapperView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(25)
        }

        titleLabel.snp.makeConstraints {
            $0.top.bottom.left.equalToSuperview()
        }

        toggleSwitch.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        paddingView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(10)
        }
        
        tagStackWrapper.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.height.equalTo(39)
        }

        tagStackView.snp.makeConstraints{
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    
    func setWrapperStackViewConstraint() {
        // 검색 바 & 대륙 바 & 국가 테이블 뷰
        wrapperStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }

        inputBarWrapper.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        inputBarView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }

        continentWrapper.snp.makeConstraints {
            $0.height.equalTo(32)
        }

        continentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        tableViewWrapper.snp.makeConstraints {
            // 테이블 셀 높이(40) * 셀 개수 기본값 8개 + 탑 바텀 인셋(16)
            $0.height.equalTo(336)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview()
        }

    }
    
    // 사용하지않음
    func setMoreButtonConstraint() {
        // More 버튼
        moreButton.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(36)
        }

        moreLabelWrapperView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
        }

        moreLabel.snp.makeConstraints {
            $0.top.bottom.left.equalToSuperview()
        }

        moreImage.snp.makeConstraints {
            $0.left.equalTo(moreLabel.snp.right).offset(2)
            $0.right.equalToSuperview()
            $0.centerY.equalTo(moreLabel.snp.centerY)
            $0.size.equalTo(16)
        }
    }
}
