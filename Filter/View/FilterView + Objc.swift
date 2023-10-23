//
//  FilterView + Objc.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/19.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation

// MARK: Objc Methods
extension FilterView {
    
    @objc func keyboardWillShow(_ sender: Notification){
        let userInfo = sender.userInfo!
        let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let keyboardAnimationOptions = UIView.AnimationOptions(rawValue: curve << 16)
        let keyboardAnimationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: keyboardAnimationOptions, animations: {[weak self] () in
                
                guard let `self` = self else {
                    return
                }
                
                self.paddingView.snp.updateConstraints {
                    $0.height.equalTo(keyboardSize.height + 86)
                }
                
                // 398 => Condition + Distance + Insets를 더한 값
                self.scrollView.setContentOffset(.init(x: 0, y: 398), animated: true)
                
            })
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification){
        let userInfo = sender.userInfo!
        let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let keyboardAnimationOptions = UIView.AnimationOptions(rawValue: curve << 16)
        let keyboardAnimationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: keyboardAnimationOptions, animations: {[weak self] () in
                
                guard let `self` = self else {
                    return
                }
                
                self.paddingView.snp.updateConstraints {
                    $0.height.equalTo(0)
                }
                
            })
        }
    }
    
    @objc func swipeUpAndDown(_ sender: UIPanGestureRecognizer) {
        let location = sender.translation(in: self.dismissInteractionView)
        let velocity = sender.velocity(in: self.dismissInteractionView)
        
        let defaultY = DeviceManager.Inset.top + 50
        let currentY = containerView.frame.origin.y
        let maxY = containerView.frame.height / 2
        
        switch sender.state {
        case .changed:
            containerView.frame.origin.y = defaultY + max(location.y, 0)
            
        case .ended where currentY >= 0 && currentY <= maxY:
            if velocity.y > 1000 {
                fallthrough
            }
            animateView(state: .show)
            
        case .ended:
            animateView(state: .hide)
//            self.loadFilterData()
        default:
            break
        }
        
    }
}
