//
//  DistanceFilterView + Bind.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/19.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxGesture

extension DistanceFilterView {
    func bindGesture(){
        
        toggleSwitch.rx.isOn
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { owner, isOn in
                
                owner.isDistance(enable: isOn)
                
            }).disposed(by: disposeBag)
        
        sliderBar.rx.panGesture()
            .filter({ $0.state == .began })
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { owner, gesture in
                if !owner.toggleSwitch.isOn {
                    owner.isDistance(enable: true)
                }
            }).disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        viewModel
            ._switchSelected
            .withUnretained(self)
            .filter{ this, state in
                this.toggleSwitch.isOn != (state == .distance)
            }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { this, state in
                this.isDistance(enable: state == .distance)
        }).disposed(by: disposeBag)
    }
}
