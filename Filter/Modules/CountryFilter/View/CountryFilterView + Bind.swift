//
//  CountryFilterView + bind.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/19.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import RxSwift
import RxCocoa
import RxGesture

extension CountryFilterView {
    
 func bind(to viewModel: FilterSearchable) {
     // 텍스트 필드 바인드
     self.bindTextField(to: viewModel)
     
     // 대륙 선택 뷰 바인드
     self.bindContinentView(to: viewModel)
     
     
     toggleSwitch.rx.isOn
         .withUnretained(self)
         .observe(on: MainScheduler.asyncInstance)
         .subscribe(onNext: { owner, isOn in
             owner.isCountry(enable: isOn)
         }).disposed(by: disposeBag)
     
     // 다른 뷰의 스위치를 올렸을 경우 off
     self.viewModel
         ._switchSelected
         .withUnretained(self)
         .filter{ this, state in
             this.toggleSwitch.isOn != (state == .country)
         }
         .observe(on: MainScheduler.asyncInstance)
         .subscribe(onNext: { this, state in
             this.isCountry(enable: state == .country)
     }).disposed(by: disposeBag)
     
     self.viewModel._countries
         .observe(on: MainScheduler.asyncInstance)
         .withUnretained(self)
         .subscribe(onNext: { owner , _  in
             log.d("_countries.subscribe")
             owner.setCountryList(list: owner.viewModel._countries.value)
             
             owner.updateTableViewHeight()
             
             owner.setSelectedLayout()
             
             owner.expandTableView()
         }).disposed(by: disposeBag)
         
//        국가 비활성화 되어있을 때 국가를 선택하면 국가 필터가 활성화 되면서 국가도 선택되게 하는겁니당
        self.rx.tapGesture(configuration: { gesture, delegate in
            delegate.simultaneousRecognitionPolicy = .never
            gesture.cancelsTouchesInView = false
        })
        .when(.recognized)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, _ in
                if owner.toggleSwitch.isOn == false {
                    owner.isCountry(enable: true)
                }
            }).disposed(by: disposeBag)
     
        titleWrapperView.rx.tapGesture(configuration: { gesture, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        })
        .when(.recognized)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, _ in
                if owner.toggleSwitch.isOn == false {
                    owner.isCountry(enable: true)
                }
//                let toggle = owner.toggleSwitch.isOn
//                owner._toggle.onNext(!toggle)
            }).disposed(by: disposeBag)
     
//     moreButton.tapGesture
//         .withUnretained(self)
//         .observe(on: MainScheduler.instance)
//         .subscribe(onNext: { owner, _ in
//             owner.expandTableView()
//         }).disposed(by: disposeBag)
     self.inputBarView
         .tapGesture
         .withUnretained(self)
         .observe(on: MainScheduler.asyncInstance)
         .subscribe(onNext: {(this, _) in
             
             if this.toggleSwitch.isOn == false {
                 this.isCountry(enable: true)
             }
             
         }).disposed(by: disposeBag)
 }
 
 func bindTextField(to viewModel: FilterSearchable){
    
     self.inputBarView.textView.rx
         .controlEvent([.editingDidBegin])
         .asObservable()
         .withUnretained(self)
         .subscribe(onNext: { (this, _) in
             print("textViewDid begin")
             this._toggle.onNext(true)
             this.inputBarView.textView.text = this.inputBarView.textView.text == SearchBarView.placeHolderText ? "" : this.inputBarView.textView.text
         }).disposed(by: disposeBag)
     
     self.inputBarView.textView.rx
         .controlEvent([.editingDidEnd])
         .asObservable()
         .withUnretained(self)
         .subscribe(onNext: { this, _  in
             if let textCnt = this.inputBarView.textView.text?.count, textCnt < 1 {
                 this.inputBarView.textView.text = SearchBarView.placeHolderText
             }
         
             print("textViewDid end")
         }).disposed(by: disposeBag)
             
     // textField.rx.text의 변경이 있을 때
     self.inputBarView.textView.rx.text
         .distinctUntilChanged()
         .withLatestFrom(continentView._selectedContinent, resultSelector: {($0, $1)})
         .withUnretained(self)
         .subscribe(onNext: { (this , value) in
             let (newValue, continent) = value
             this.setCountryList(viewModel: viewModel, continent: continent, newString: newValue)
             
         }).disposed(by: disposeBag)
     
     inputBarReset
         .withLatestFrom(continentView._selectedContinent)
         .withUnretained(self)
         .observe(on: MainScheduler.instance)
         .subscribe(onNext: { owner, continent in
             owner.inputBarView.reset()
             owner.continentView.reset()
             owner.setCountryList(viewModel: viewModel, continent: continent, newString: owner.inputBarView.textView.text)
             
         }).disposed(by: disposeBag)
 }
 
 func bindContinentView(to viewModel: FilterSearchable) {
     continentView._selectedContinent
         .observe(on: MainScheduler.instance)
         .withLatestFrom(inputBarView.textView.rx.text, resultSelector: { ( $1, $0 )})
         .withUnretained(self)
         .subscribe(onNext: { owner, value in
             let (newValue, continent) = value
             owner.setCountryList(viewModel: viewModel, continent: continent, newString: newValue)
         }).disposed(by: disposeBag)
 }
}
