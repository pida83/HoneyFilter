//
//  ConditionFilterView + Subview.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/19.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

extension ConditionFilterView {
    func configureContainerView(){
        containerView.addSubviews("") {
            titleLabel
            profileWrapperView
            genderWrapperView
            ageWrapperView
        }
    }
    
    func configureProfileWrapperView(){
        
        profileWrapperView.addSubviews("체크박스 뷰") {
            marriageCheckView
            buddyCheckView
            digamyCheckView
        }
    }
   
    func configureGenderWrapperView(){
        genderWrapperView.addSubviews("") {
            genderTitleLabel
            maleCheckView
            femaleCheckView
        }
    }
    
    func configureAgeWrapperView(){
        ageWrapperView.addSubviews("") {
            ageTitleLabel
            ageLabel
            ageSettingSlider
        }
    }
  
}

