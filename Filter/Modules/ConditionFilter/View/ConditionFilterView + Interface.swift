//
//  ConditionFilterView + Interface.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/18.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation

extension ConditionFilterView: ConditionFilterViewInterface {
    
    func setViewModel(viewModel: ConditionFilterViewModel) {
        self.viewModel = viewModel
    }
    
    func selectConditions(type: MarriageType) {
        switch type {
        case .marriage:
            self.viewModel.setMarriageBox(isChecked: self.marriageCheckView.isCheck)
        case .digamy:
            self.viewModel.setDigamyBox(isChecked: self.digamyCheckView.isCheck)
        case .buddy:
            self.viewModel.setBuddyBox(isChecked: self.buddyCheckView.isCheck)
        }
    }
    
    func selectConditions(type: Gender) {
        switch type {
        case .male:
            self.viewModel.setMaleBox(isChecked: self.maleCheckView.isCheck)
        case .female:
            self.viewModel.setFemaleBox(isChecked: self.femaleCheckView.isCheck)
        case .bisexual:
            break
        }
    }
    
    func selectAge(minAge: Int, maxAge: Int) {
        var model = self.viewModel.getSearchModel()
        
        model.searchMinAge = minAge
        model.searchMaxAge = maxAge
        
        self.viewModel.setSearch(model: model)
    }
    
}
