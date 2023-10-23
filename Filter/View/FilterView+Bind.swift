//
//  FilterView+Bind.swift
//  GlobalHoneys
//
//  Created by BEYun on 2023/07/06.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import UIKit

import RxSwift

extension FilterView {
    
    func bind(to viewModel: FilterSearchable) {
        if self.viewModel.dependLocation == .main {
            conditionFilterView.bind()
        }
        
        distanceFilterView.bind()
        countryFilterView.bind(to: viewModel)
        self.bind()
        tapBind(to: viewModel)
        
        
        distanceFilterView._requestSearch
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                log.d(owner.viewModel.getSearchModel())
                viewModel.search(searchModel: owner.viewModel.getSearchModel(), for: owner.viewModel.dependLocation)
            }).disposed(by: disposeBag)
    }
    
    func bind() {
        self.viewModel
            ._isConfirmEnable
            .withUnretained(self)
            .subscribe(onNext: { (this, isEnable) in
                this.confirmButton.isEnabled = isEnable
        }).disposed(by: disposeBag)
        
        self.viewModel._countries
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner , _  in
                log.d("_countries.subscribe")
                owner.updateCountryViewHeight()
            }).disposed(by: disposeBag)
    }
    
    func tapBind(to viewModel: FilterSearchable) {
        
        scrollToTopButton.tapGesture
            .when(.recognized)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, _ in
                owner.scrollToTop()
            })
        
        dimView.tapGesture
            .when(.recognized)
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { owner, _ in
                owner.animateView(state: .hide)
//                owner.loadFilterData()
            }).disposed(by: disposeBag)
        
        closeButton.tapGesture
            .when(.recognized)
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { owner, _ in
                owner.animateView(state: .hide)
//                owner.loadFilterData()
            }).disposed(by: disposeBag)
        
        resetButton.tapGesture
            .when(.recognized)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, _ in
                owner.reset()
            }).disposed(by: disposeBag)
        
        confirmButton.tapGesture
            .when(.recognized)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, _ in
                owner.confirm(to: viewModel)
            }).disposed(by: disposeBag)
        
    }
}
