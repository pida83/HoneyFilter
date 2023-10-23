//
//  DefaultFilterViewModel.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/17.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa




class DefaultFilterViewModel: FilterViewModel {
    
    init(dependLocation: FilterViewLocation, searchModel: FilterSearchModel, countryCnt: Int, currentState: FilterViewState, useCase: FetchResourceUseCase) {
        self.dependLocation     = dependLocation
        self._searchModel       = BehaviorRelay<FilterSearchModel>(value: searchModel)
        self.countryCnt         = countryCnt
        self._currentState       = currentState
        self.useCase            = useCase
        
        getCountryList()
        
        checkSearchEnabled(model: searchModel)
    }
    
    
    public var relay : BehaviorRelay<Bool> = .init(value: true)
    /// # property
    public var dependLocation: FilterViewLocation
    
    public var countryCnt: Int
    
    public var useCase: FetchResourceUseCase
    
    /// # output
    public var _isConfirmEnable: BehaviorSubject<Bool>     = .init(value: true)
    public var _countryListDidLoad : PublishSubject<Void>  = .init()
    public var _searchModel : BehaviorRelay<FilterSearchModel>
    public var _countries : BehaviorRelay<[CountryCode]> = .init(value: [])
    public var _switchSelected: PublishSubject<FilterViewState> = .init()
    public var _currentState: FilterViewState
    
    func getSearchModel() -> FilterSearchModel {
        self._searchModel.value
    }
    
    
    func setSearch(model: FilterSearchModel) {
        DispatchQueue.main.async {
            self.checkSearchEnabled(model: model)
            self._searchModel.accept(model)
        }
    }
    
    func getCountryList() {
        Task {
            do {
                let codeList = try await self.useCase.getCountryCodeList()
                
                let countryList = (try? JSONDecoder().decode([CountryCode].self, from: codeList.rawData())) ?? []
                self.countryCnt = countryList.count
                self._countries.accept(countryList)
                
            } catch {
                
                log.e(error.localizedDescription)
                self.countryCnt = 0
                self._countries.accept([])
            }
        }
    }
}

extension DefaultFilterViewModel {
    
    // 결혼 조건, 성별 최소 하나씩은 있어야함
    func checkSearchEnabled(model: FilterSearchModel) {
        let isConfirmEnable = !model.searchMarriageType.isEmpty && !model.searchGender.isEmpty
        
        _isConfirmEnable.onNext(isConfirmEnable)
    }
    
}


extension DefaultFilterViewModel {

    func setMarriageBox(isChecked: Bool) {
        var model = self.getSearchModel()
        if isChecked {
            model.searchMarriageType.insert(.marriage)
        } else {
            model.searchMarriageType.remove(.marriage)
        }
        
        self.setSearch(model: model)
    }
    
    func setDigamyBox(isChecked: Bool) {
        var model = self.getSearchModel()
        
        if isChecked {
            model.searchMarriageType.insert(.digamy)
        } else {
            model.searchMarriageType.remove(.digamy)
        }
        
        self.setSearch(model: model)
    }
    
    func setBuddyBox(isChecked: Bool) {
        var model = self.getSearchModel()
        
        if isChecked {
            model.searchMarriageType.insert(.buddy)
        } else {
            model.searchMarriageType.remove(.buddy)
        }
        
        self.setSearch(model: model)
    }
    
    func setMaleBox(isChecked: Bool) {
        
        var model = self.getSearchModel()
        
        if isChecked {
            model.searchGender.insert(.male)
        } else {
            model.searchGender.remove(.male)
        }
        
        self.setSearch(model: model)
    }
    
    
    func setFemaleBox(isChecked: Bool) {
        var model = self.getSearchModel()
        
        if isChecked {
            model.searchGender.insert(.female)
        } else {
            model.searchGender.remove(.female)
        }
        
        self.setSearch(model: model)
    }
    
    func setCountry(model: Set<CountryCode>) {
        var searchModel = self.getSearchModel()
            searchModel.srchLocLCodeList = model
        self.setSearch(model: searchModel)
    }
}
