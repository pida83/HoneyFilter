//
//  ProfileFilterView.swift
//  GlobalHoneys
//
//  Created by BEYun on 2023/06/29.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

class ProfileFilterView: UIView {

    let containerView = UIView().then {
        $0.clipsToBounds = false
        $0.backgroundColor = .white
        $0.roundCorners(cornerRadius: 12, maskedCorners: [.allCorners])
    }

    let titleLabel = UILabel().then {
        $0.sizeToFit()
        $0.numberOfLines = 1
        $0.setLineHeight(25)
        $0.textAlignment = .left
        $0.textColor = .gray50
        $0.font = .b17
        $0.text = "Profile type".localized()
    }
    
    let checkBoxWarpperView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let marriageCheckView = CheckboxView(title: "Marriage".localized())
    let buddyCheckView    = CheckboxView(title: "Buddy".localized())
    let digamyCheckView   = CheckboxView(title: "Remarriage".localized())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        addComponents()
        setConstraints()
    }
    
    func addComponents() {
        self.addSubview(containerView)
        
        containerView.addSubviews("래퍼 뷰") {
            titleLabel
            checkBoxWarpperView
        }
        
        checkBoxWarpperView.addSubviews("체크박스 뷰") {
            marriageCheckView
            buddyCheckView
            digamyCheckView
        }
    }
    
    func setConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.left.equalToSuperview().inset(16)
        }
        
        checkBoxWarpperView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.bottom.left.right.equalToSuperview().inset(16)
        }
        
        marriageCheckView.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5).inset(3.5)
        }
        
        buddyCheckView.snp.makeConstraints {
            $0.top.equalTo(marriageCheckView.snp.bottom).offset(8)
            $0.left.equalToSuperview()
            $0.width.equalTo(marriageCheckView.snp.width)
        }
        
        digamyCheckView.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.left.equalTo(marriageCheckView.snp.right).offset(7)
        }
    }
    
    func refreshFilter() {
        // 체크 박스 초기화
        self.marriageCheckView.isCheck = true
        self.digamyCheckView.isCheck   = true
        self.buddyCheckView.isCheck    = true
    }
    
    func setData(searchModel: FilterSearchModel) {
        let marriageType = searchModel.searchMarriageType
        
        self.marriageCheckView.isCheck = marriageType.contains(.marriage)
        self.digamyCheckView.isCheck   = marriageType.contains(.digamy)
        self.buddyCheckView.isCheck    = marriageType.contains(.buddy)
    }
}


