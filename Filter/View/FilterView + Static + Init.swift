//
//  FilterView + Init.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/17.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation
import UIKit

extension FilterView {
    public static func createFilter(frame: CGRect, dependLocation: FilterViewLocation) -> FilterView {
        let filterView = FilterView(frame: frame)
            filterView.setViewModel(viewModel: FilterView.createDefaultFilterViewModel(dependLocation: dependLocation))
        return filterView
    }
    
    static func createFilterSearchModel() -> FilterSearchModel {
        
        return FilterSearchModel(
            searchMarriageType: FilterView.Default._DEFAULT_MARRIAGE_TYPE,
            searchGender: FilterView.Default._DEFAULT_GENDER_TYPE,
            searchMinAge: FilterView.Default._DEFAULT_SEARCH_MIN_AGE,
            searchMaxAge: FilterView.Default._DEFAULT_SEARCH_MAX_AGE
        )
    }
    
    static func createDefaultFilterViewModel(dependLocation: FilterViewLocation) -> DefaultFilterViewModel {
        return DefaultFilterViewModel(
            dependLocation: dependLocation,
            searchModel: FilterView.createFilterSearchModel(),
            countryCnt: 8,
            currentState: .initial,
            useCase: DefaultResourceUseCase(repository: DefaultResourceRepository()))
    }
}
