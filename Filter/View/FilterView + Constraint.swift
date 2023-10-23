//
//  FilterView + Layout.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/17.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import SnapKit
import UIKit

extension FilterView {
    
   
    
    func setDimViewConstaint(){
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setContainerViewConstraint(){
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(DeviceManager.Inset.top + 50)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }

    func setContentViewConstraint() {
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dismissInteractionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        dismissBar.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
        }
    }

    func setScrollViewConstraint() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(dismissInteractionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-DeviceManager.Inset.bottom)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.bottom.equalToSuperview().offset(-74)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.width.equalToSuperview().inset(12)
        }
    }

    func setArrangedViewConstraint() {
        if self.viewModel.dependLocation == .main {
            conditionFilterView.snp.makeConstraints {
                $0.height.equalTo(258)
            }
        }
        
        
        distanceFilterView.snp.makeConstraints {
            $0.height.equalTo(101)
        }
        
        countryFilterView.snp.makeConstraints {
            // [타이틀 / 태그 / 검색 바 / 대륙] => 160
            // [테이블 뷰 셀 높이 * 나라 갯수 + 테이블 뷰 인셋] => 160 + 40 * countryCnt + 16
            $0.height.lessThanOrEqualTo(160 + 40 * viewModel.countryCnt + 16)
        }
        
        paddingView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0)
        }
    }
    func setScrollToTopButtonConstraint() {
        scrollToTopButton.snp.makeConstraints {
            $0.bottom.equalTo(buttonStackView.snp.top).offset(-5)
            $0.trailing.equalToSuperview().inset(4)
            $0.size.equalTo(62)
        }
    }
    func setButtonGradientViewConstraint() {
        buttonGradientView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(DeviceManager.Inset.bottom > 0 ? -DeviceManager.Inset.bottom : -11)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        resetShadow.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(100)
        }
        
        resetButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        confirmShadow.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func makeSeparator() {
        let count = stackView.subviews.count
        if count > 0 {
            for i in 0..<count / 2 {
                let wrapper = UIView()
                let separator = UIView()
                wrapper.backgroundColor = .white
                separator.backgroundColor = .grayF1
                
                wrapper.addSubview(separator)
                
                stackView.insertArrangedSubview(wrapper, at: i * 2 + 1)
                
                wrapper.snp.makeConstraints {
                    $0.height.equalTo(1)
                }
                
                separator.snp.makeConstraints {
                    $0.center.equalToSuperview()
                    $0.width.equalToSuperview().inset(12)
                    $0.height.equalTo(1)
                }
            }
        }
    }
}
