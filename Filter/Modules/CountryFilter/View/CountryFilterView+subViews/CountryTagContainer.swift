//
//  CountryTagView.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/04/20.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import UIKit
import SnapKit
import Then
import SweeterSwift
import Kingfisher
import CommonUI

public class CountryTagView: UIView {
    
    var data: CountryCode!
    
    var flagImage: UIImageView  = .init(frame: CGRect(x: 0, y: 0, width: 19, height: 19))
    
    @LabelProperty(text: "", textColor: UIColor.gray20, font: .m13, lines: 0, textAlignment: .left, description: "국가명")
    var countryName: UILabel    = .init()
    
    @DefaultUIImageView(image: ResourceManager.image.iconDeleteTag.image, isHidden: false, contentMode: .scaleAspectFit )
    var closeImage: UIImageView = .init(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
    
    
    
    var wrapper: UIStackView = .horizontalStackView().then{
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 4, left: 8, bottom: 4, right: 6)
        $0.distribution = .fill
        $0.spacing = 4
    }
    
    func getTagSize() -> CGFloat {
        let flagWidth   : CGFloat = 19
        let closeWidth  : CGFloat = 18
        let margin      : CGFloat = 4
        let leftMargin  : CGFloat = 8
        let rightMargin : CGFloat = 6
        
        return countryName.frame.width + flagWidth + closeWidth + margin + leftMargin + rightMargin
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .primary150
        
        setLayout()
        
        setConstraint()

    }
    
    required public init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        
    }

    func bind(data: CountryCode) {
        self.data = data
        
        if let url = URL(string: data.flagURL) {
            flagImage.kf.setImage(with: url)
        }
        
        countryName.text           = data.name
        countryName.sizeToFit()
    }
    
    func setLayout() {
        
        setRadiusAndBorder(radius: 12, width: 1, color: .primary500)
        
        countryName.text           = "Bangladesh"
        
        closeImage.backgroundColor = .clear
        
        wrapper.addArrangeSubviews("") {
            flagImage
            countryName
            closeImage
//            UIView().addSubviews{closeImage}
            
        }
        
        wrapper.setCustomSpacing(0, after: countryName)
        
        addSubview(wrapper)
    }
    
    func setConstraint() {
        wrapper.snp.makeConstraints{
            $0.height.equalTo(27)
            $0.edges.equalToSuperview()
        }
        
        flagImage.snp.makeConstraints{
            $0.centerY.equalToSuperview()
//            $0.left.equalToSuperview().offset(8)
            $0.size.equalTo(19)
        }
        
//        countryName.snp.makeConstraints {
//            $0.leading.equalTo(flagImage.snp.trailing).offset(4)
//        }
        
        closeImage.snp.makeConstraints{
//            $0.top.equalToSuperview().inset(5)
//            $0.top.bottom.equalToSuperview().inset(4)
//            $0.leading.equalTo(countryName.snp.trailing)
//            $0.trailing.equalToSuperview().inset(6)
            $0.size.equalTo(18)
            $0.centerY.equalToSuperview()
        }
    }
    
}


public class CountryTagContainer: UIStackView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    
    public required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func setLayout() {
        axis = .horizontal
        alignment = .fill
        backgroundColor = .white
        distribution = .equalSpacing
        spacing = 4
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    func removeAll(){
        self.removeAllArrangedSubviewsCompletely()
    }
}
