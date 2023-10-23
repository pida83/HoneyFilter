//
//  ConditionFilterView + Constraint.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/19.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation
import SnapKit

extension ConditionFilterView {
    
    func setContainerViewConstraint() {
        titleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview()
        }
        
        // 프로필 섹션
        profileWrapperView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview()
        }
        // 성별 섹션
        genderWrapperView.snp.makeConstraints {
            $0.top.equalTo(profileWrapperView.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
        }
        // 나이 섹션
        ageWrapperView.snp.makeConstraints {
            $0.top.equalTo(genderWrapperView.snp.bottom).offset(8)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    func setProfileWrapperViewConstraint() {
        marriageCheckView.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5).inset(4)
        }
        
        buddyCheckView.snp.makeConstraints {
            $0.top.equalTo(marriageCheckView.snp.bottom).offset(8)
            $0.left.equalToSuperview()
            $0.width.equalTo(marriageCheckView.snp.width)
        }
        
        digamyCheckView.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.left.equalTo(marriageCheckView.snp.right).offset(8)
        }
    }
    
    
    func setGenterWrapperViewConstraint() {
        genderTitleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview()
        }
        
        maleCheckView.snp.makeConstraints {
            $0.top.equalTo(genderTitleLabel.snp.bottom).offset(5)
            $0.bottom.left.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5).inset(4)
        }
        
        femaleCheckView.snp.makeConstraints {
            $0.top.equalTo(genderTitleLabel.snp.bottom).offset(5)
            $0.bottom.right.equalToSuperview()
            $0.left.equalTo(maleCheckView.snp.right).offset(8)
        }
    }
    
    
    func setAgeWrapperViewConstraint() {
        ageTitleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview()
        }
        
        ageLabel.snp.makeConstraints {
            $0.top.right.equalToSuperview()
        }
        
        ageSettingSlider.snp.makeConstraints {
            $0.top.equalTo(ageTitleLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(4)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(36)
        }
    }
}
