//
//  ConditionFilterViewModel.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/18.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol FilterSearchable {
    var _isFiltered: PublishSubject<Bool> {get set}
    func search(searchModel: FilterSearchModel, for: FilterViewLocation)
}


protocol FilterViewModel: AnyObject, ConditionFilterViewModel, DistanceFilterViewModel, CountryFilterViewModel {
    var dependLocation: FilterViewLocation {get set}
    var countryCnt: Int {get set}
    var _currentState: FilterViewState {get set}
    var useCase: FetchResourceUseCase {get set}
    
    /// output
    var _countryListDidLoad : PublishSubject<Void> {get set}
    var _isConfirmEnable: BehaviorSubject<Bool> {get set}
}

protocol ConditionFilterViewModel {
    /// output
    var _searchModel : BehaviorRelay<FilterSearchModel> {get set}
    
    func getSearchModel() -> FilterSearchModel
    func setSearch(model: FilterSearchModel)
    
    func setMarriageBox(isChecked: Bool)
    func setDigamyBox(isChecked: Bool)
    func setBuddyBox(isChecked: Bool)
    func setMaleBox(isChecked: Bool)
    func setFemaleBox(isChecked: Bool)
}


protocol CountryFilterViewModel {
    /// output
    var _searchModel : BehaviorRelay<FilterSearchModel> {get set}
    var _currentState: FilterViewState {get set}
    var _switchSelected: PublishSubject<FilterViewState> {get set}
    var _countries : BehaviorRelay<[CountryCode]> {get set}
    
    func getSearchModel() -> FilterSearchModel
    func setSearch(model: FilterSearchModel)
    func setCountry(model : Set<CountryCode>)
    
}

protocol DistanceFilterViewModel {
    /// output
    var _searchModel : BehaviorRelay<FilterSearchModel> {get set}
    var _switchSelected: PublishSubject<FilterViewState> {get set}
    var _currentState: FilterViewState {get set}
    
    func getSearchModel() -> FilterSearchModel
    func setSearch(model: FilterSearchModel)
}

