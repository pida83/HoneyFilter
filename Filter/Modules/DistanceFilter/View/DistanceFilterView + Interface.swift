//
//  DistanceFilterView + Interface.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/19.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension DistanceFilterView: DistanceFilterViewInterface {
    
    func setViewModel(viewModel: DistanceFilterViewModel) {
        self.viewModel = viewModel
    }
    
    
    func selectDistance(minDistance: CGFloat, maxDistance: CGFloat) {
        var model = self.viewModel.getSearchModel()
        
        
            model.srchMinDistance = getSearchValue(sliderValue: minDistance) ?? FilterView.Default._DEFAULT_MIN_DISTANCE
            model.srchMaxDistance = getSearchValue(sliderValue: maxDistance) ?? FilterView.Default._DEFAULT_MAX_DISTANCE
        
        updateDistanceLabel(minDistance: Int(minDistance), maxDistance: Int(maxDistance))
        
        self.viewModel.setSearch(model: model)
    }
    
    func updateDistanceLabel(minDistance: Int, maxDistance: Int) {
        if minDistance <= 0 {
            maxDistanceLabel.text = "\(makeDistanceText(value: maxDistance)) " + "kilometers".localized()
            upToOrFromLabel.text      = "Up to".localized()
            maxDistanceLabel.isHidden = false
            minDistanceLabel.isHidden = true
            toLabel.isHidden          = true
            awayLabel.isHidden        = false
            
        } else {
            
            let minimumText = makeDistanceText(value: minDistance) + " "  + "kilometers".localized()
            let maximumText = makeDistanceText(value: maxDistance) + " "  + "kilometers".localized()
            let pointColor  = UIColor(r: 149, g: 104, b: 0)
            upToOrFromLabel.text = "minimum %@ to maximum %@".localized(minimumText, maximumText)
            upToOrFromLabel.textColorChange(color: pointColor, range: minimumText, maximumText)
            
            maxDistanceLabel.isHidden = true
            minDistanceLabel.isHidden = true
            toLabel.isHidden          = true
            awayLabel.isHidden        = true
            
        }
    }
    
    
    func makeDistanceText(value: Int) -> String {
        var text = "\(value)"
        
        switch value {
        case 101...190:
            text = "\(100 + (value - 100) * 10)"
            return text
            
        case 191...420:
            text = "\(1000 + (value - 190) * 100)"
            return text
            
        default:
            break
        }
        
        return text
    }
    
    
    
    func isDistance(enable: Bool) {
        
        viewModel._switchSelected.onNext(enable ? .distance : .country)
        
        setDimmedView(!enable)
        self.viewModel._currentState = enable ? .distance : .country
        self.toggleSwitch.setOn(enable, animated: true)
    }
    
    func setDimmedView(_ isDimmed: Bool) {
        distanceWrapperView.alpha = isDimmed ? 0.4 : 1
        
        let state = isDimmed ? MultiSlider.SliderState.deactivate : MultiSlider.SliderState.activate
        sliderBar.updateUI(state: state)
    }
    
}

