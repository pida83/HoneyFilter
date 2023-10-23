//
//  ConditionFilterView + bind.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/19.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxGesture

extension ConditionFilterView {
    
    func bindGesture() {
        self.marriageCheckView.tapGesture.share()
            .withUnretained(self)
            .bind{ (this, _) in
                this.selectConditions(type: .marriage)
            }.disposed(by: disposeBag)
        
        self.digamyCheckView.tapGesture.share()
            .withUnretained(self)
            .bind{ (this, _) in
                this.selectConditions(type: .digamy)
            }.disposed(by: disposeBag)
        
        self.buddyCheckView.tapGesture.share()
            .withUnretained(self)
            .bind{ (this , _) in
                this.selectConditions(type: .buddy)
            }.disposed(by: disposeBag)
        
        self.maleCheckView.tapGesture.share()
            .withUnretained(self)
            .bind{ this, _ in
                this.selectConditions(type: .male)
            }.disposed(by: disposeBag)
        
        
        self.femaleCheckView.tapGesture.share()
            .withUnretained(self)
            .bind{ this, _ in
                this.selectConditions(type: .female)
            }.disposed(by: disposeBag)
    }

    func bindViewModel() {
        viewModel
            ._searchModel
            .distinctUntilChanged{ first, second in
                first == second
            }
            .withUnretained(self)
            .subscribe(onNext: { (this, model) in
                this.setData(searchModel: model)
            }).disposed(by: disposeBag)
    }

}
