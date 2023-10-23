//
//  CountryFilterView + Interface.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/19.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import UIKit

extension CountryFilterView: CountryFilterViewInterface {
    
    func setViewModel(viewModel: CountryFilterViewModel) {
        self.viewModel = viewModel
    }
    
    func isCountry(enable: Bool) {
        viewModel._switchSelected.onNext(enable ? .country : .distance)
        setDimmedView(!enable)
        self.viewModel._currentState = enable ? .country : .distance
        self.toggleSwitch.setOn(enable, animated: true)
        
        if !enable {
            inputBarView.textView.resignFirstResponder()
        }
    }
    
    func selectCountry(code: CountryCode) {
        
        guard let isContains = self.selectedTag.first(where: {$0.countryName.text == code.name}) else {
            // 없다면 추가
            self.selectedTag.insert(makeSelectedTag(data: code))
            return
        }
        
        // 있다면 제거
        self.selectedTag.remove(isContains)
    }
    
    func setCountry() {
        // 뷰 모델로 전송
        self.viewModel.setCountry(model: Set(self.selectedTag.map{$0.data}))
    }
    
    
    func isCountryAppendable() -> Bool {
        var isAvailabe =  self.selectedTag.count < 5
        
        defer {
            if isAvailabe == false {
                App._CHANNEL_SERVICE._makeToast(model: ToastModel(message: "You can select up to 5.".localized()), on: .topViewController)
            }
        }
        
        return isAvailabe
    }
    
    
}
