//
//  SearchBarView.swift
//  GlobalHoneys
//
//  Created by yeoboya on 2023/04/13.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation
import UIKit
import CommonUI
import SnapKit
import Then

import RxSwift

class SearchBarView: CustomView {
    var wrapperView = UIView().then {
        $0.backgroundColor = UIColor(rgb: 242, a: 242)
        $0.layer.cornerRadius = 12
    }
    
    var textView = UITextField().then {
        $0.text = "Search country".localized()
        $0.textColor = .gray20
        $0.font = .m16
        $0.backgroundColor = .clear
    }
    
    var searchButton = UIButton().then {
        $0.setImage(ResourceManager.image.searchIcon.image, for: .normal)
    }
    
    static let placeHolderText = "Search country".localized()
    
    override func addComponents() {
        [wrapperView].forEach(self.addSubview(_:))
        
        [textView, searchButton].forEach(wrapperView.addSubview(_:))
    }
    
    override func setConstraints() {
        wrapperView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        textView.snp.makeConstraints {
//            $0.height.equalTo(24)
            $0.top.bottom.equalToSuperview().inset(13)
            $0.left.equalToSuperview().inset(16)
        }
        
        searchButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(textView.snp.right).offset(4)
            $0.right.equalToSuperview().inset(10)
        }
    }
    
//    func bind(to viewModel: ProfileListViewModel) {
////        textView.rx.text.with
//    }
    
    func setData(searchText: String) {
        textView.text = searchText.isEmpty ? SearchBarView.placeHolderText : searchText
        textView.sendActions(for: .editingChanged)
    }
    
    func reset() {
        textView.text = SearchBarView.placeHolderText
        textView.sendActions(for: .editingChanged)
    }
}
