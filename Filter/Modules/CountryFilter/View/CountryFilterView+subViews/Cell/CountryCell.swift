//
//  CountryCell.swift
//  GlobalHoneys
//
//  Created by yeoboya on 2023/04/13.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation
import UIKit
import CommonUI
import Kingfisher
import SnapKit
import Then

import RxSwift

class CountryCell: UITableViewCell {
    
    static let identifier = "CountryCell"
    
    var disposeBag = DisposeBag()
    
    var countryCode: String?
    
    let flagImageView = UIImageView()
    
    var countryLabel = UILabel().then {
        $0.textColor = .warmGrey
        $0.font = .m15
        $0.setLineHeight(21)
        $0.setCharacterSpacing(-0.45)
    }
    
    @DefaultUIImageView(image: ResourceManager.image.stateIcon.image, isHidden: true, contentMode: .scaleAspectFit)
    var checkIcon = UIImageView()
    
    var separatorLine = UIView().then {
        $0.backgroundColor = .grayF1
    }
    
    var isCheck: Bool = false {
        didSet {
            didSelected()
        }
    }
    
    func didSelected() {
        self.contentView.backgroundColor = isCheck ? .primary100 : .white
        self.checkIcon.isHidden = !isCheck
        self.countryLabel.textColor = isCheck ? .gray20 : .warmGrey
    }
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setCommonCell()
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCommonCell() {
        addComponent()
        setConstraints()
    }
    
    func addComponent() {
        [flagImageView, countryLabel, checkIcon, separatorLine].forEach(self.contentView.addSubview(_:))
        
    }
    
    func setConstraints() {
        flagImageView.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(24)
            $0.left.equalToSuperview().inset(13)
            $0.centerY.equalToSuperview()
        }
        
        countryLabel.snp.makeConstraints {
            $0.left.equalTo(flagImageView.snp.right).offset(8)
            $0.top.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(11)
            $0.right.equalTo(checkIcon.snp.left).offset(-8)
        }
        
        checkIcon.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.right.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview().offset(-1)
        }
        
        separatorLine.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func configUI(countryCode: CountryCode) {
        
        if let url = URL(string: countryCode.flagURL) {
            flagImageView.kf.setImage(with: url)
        }
        
        self.countryCode = countryCode.code
        
        countryLabel.text = countryCode.name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        isCheck = selected
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        checkIcon.isHidden  = true
        isCheck             = false
        flagImageView.image = nil
        countryLabel.text   = nil
        disposeBag          = DisposeBag()
        countryCode         = nil
    }
}
