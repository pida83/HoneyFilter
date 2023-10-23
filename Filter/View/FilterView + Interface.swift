//
//  FilterView + Interface.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/18.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation
import RxSwift


extension FilterView: FilterViewInterface {
    func setViewModel(viewModel: FilterViewModel) {
        self.viewModel = viewModel

        if viewModel.dependLocation == .main {
            conditionFilterView.setViewModel(viewModel: viewModel)
        }

        distanceFilterView.setViewModel(viewModel: viewModel)
        countryFilterView.setViewModel(viewModel: viewModel)
    }
    
    
    func confirm(to viewModel : FilterSearchable) {
        viewModel._isFiltered.onNext(self.checkConditions())
        
        switch self.viewModel._currentState {
        case .initial, .country:
            var searchModel = self.viewModel.getSearchModel()
                searchModel.memLongitude = nil
                searchModel.memLatitude = nil
                searchModel.srchMaxDistance = nil
                searchModel.srchMinDistance = nil
            self.viewModel.setSearch(model: searchModel)
            
            viewModel.search(searchModel: searchModel, for: self.viewModel.dependLocation)
            
        case .distance:
            self.countryFilterView.refreshFilter()
            self.distanceFilterView.searchDistance()
            
        default:
            break
        }
        
        self.animateView(state: .hide)
    }
    
    func resetIfNeeds() {
        if self.viewModel.getSearchModel() == FilterView.createFilterSearchModel() {
            let defaultList = FilterView.createFilterSearchModel().srchLocLCodeList
            let modelList = self.viewModel.getSearchModel().srchLocLCodeList
            log.d(defaultList)
            log.d(modelList)
            log.d(modelList == defaultList)
            self.reset()
        }
    }
    
    // 초기화 버튼
    // 뷰만 초기화, 검색모델은 초기화 하지 않음
    func reset() {
        
        self.viewModel._currentState = .distance
        let defaultSearchModel = FilterView.createFilterSearchModel()
        
        if self.viewModel.dependLocation == .main {
            conditionFilterView.refreshFilter()
            conditionFilterView.setData(searchModel: defaultSearchModel)
        }
        
        distanceFilterView.refreshFilter()
        countryFilterView.refreshFilter()
        
        self.viewModel.setSearch(model: FilterView.createFilterSearchModel())
    }
    
    func close() {
        
    }
}
