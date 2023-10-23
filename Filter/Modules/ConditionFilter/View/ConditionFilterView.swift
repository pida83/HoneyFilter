//
//  ConditionFilterView.swift
//  GlobalHoneys
//
//  Created by BEYun on 2023/06/29.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import UIKit

import SnapKit
import RxSwift
import Then
import CommonUI

class ConditionFilterView: UIView {
    
    var disposeBag = DisposeBag()
    
    var viewModel: ConditionFilterViewModel!
    
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
        $0.text = "Conditions".localized()
    }
    
    let profileWrapperView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let genderWrapperView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let ageWrapperView = UIView().then {
        $0.backgroundColor = .clear
    }

    // 프로필 섹션
    let marriageCheckView = CheckboxView(title: "Marriage".localized())
    let buddyCheckView    = CheckboxView(title: "Buddy".localized())
    let digamyCheckView   = CheckboxView(title: "Remarriage".localized())
    
    /// 성별 섹션
    let genderTitleLabel = UILabel().then {
        $0.sizeToFit()
        $0.numberOfLines = 1
        $0.setLineHeight(20)
        $0.textAlignment = .left
        $0.textColor = .gray20
        $0.font = .m14
        $0.text = "Gender".localized()
    }
    
    let maleCheckView     = CheckboxView(title: "Male".localized())
    let femaleCheckView   = CheckboxView(title: "Female".localized())

    /// 나이 섹션
    let ageTitleLabel = UILabel().then {
        $0.sizeToFit()
        $0.numberOfLines = 1
        $0.setLineHeight(20)
        $0.textAlignment = .left
        $0.textColor = .gray20
        $0.font = .m14
        $0.text = "Age".localized()
    }
    
    let ageLabel = UILabel().then {
        $0.sizeToFit()
        $0.numberOfLines = 1
        $0.setLineHeight(20)
        $0.setCharacterSpacing(-0.42)
        $0.textAlignment = .left
        $0.textColor = .messageName
        $0.font = .b14
        $0.text = "18 ~ 80"
    }
    
    let ageSettingSlider = MultiSlider().then {
        $0.orientation = .horizontal
        
        $0.minimumValue = 18
        $0.maximumValue = 120
        $0.outerTrackColor = .grayE1
        
        $0.value = [CGFloat(FilterView.Default._DEFAULT_SEARCH_MIN_AGE), CGFloat(FilterView.Default._DEFAULT_SEARCH_MAX_AGE)]
        $0.tintColor = UIColor(r: 242, g: 193, b: 3)
        $0.trackWidth = 8
        $0.showsThumbImageShadow = true
        $0.thumbSize = 24
        $0.snapStepSize = 1
        $0.isHapticSnap = false
        $0.thumbImage = ResourceManager.image.btnSlider.image
        $0.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
    }
    
    var _searchAge: PublishSubject<(Int, Int)> = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        if superview != nil {
            commonInit()
        }
    }
    
    func commonInit() {
        addComponents()
        setConstraints()
    }
   
    
    func addComponents() {
        self.addSubview(containerView)
        configureContainerView()
        configureProfileWrapperView()
        configureGenderWrapperView()
        configureAgeWrapperView()
        
        ageLabel.text = "\(Int(ageSettingSlider.value.first ?? CGFloat(FilterView.Default._DEFAULT_SEARCH_MIN_AGE)))"
                        + " ~ "
                        + "\(Int(ageSettingSlider.value.last ?? CGFloat(FilterView.Default._DEFAULT_SEARCH_MAX_AGE)))"
    }
    
    func setConstraints() {
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        setContainerViewConstraint()
        setProfileWrapperViewConstraint()
        setGenterWrapperViewConstraint()
        setAgeWrapperViewConstraint()
    }
    
    func refreshFilter() {
        // 체크 박스 초기화
        self.marriageCheckView.isCheck = true
        self.digamyCheckView.isCheck   = true
        self.buddyCheckView.isCheck    = true
        
        self.maleCheckView.isCheck     = true
        self.femaleCheckView.isCheck   = true
        
        ageSettingSlider.value = [CGFloat(FilterView.Default._DEFAULT_SEARCH_MIN_AGE), CGFloat(FilterView.Default._DEFAULT_SEARCH_MAX_AGE)]
        ageSettingSlider.minimumValue = 18
        ageSettingSlider.maximumValue = 120
        
        ageLabel.text = "\(FilterView.Default._DEFAULT_SEARCH_MIN_AGE)"
                        + " ~ "
                        + "\(FilterView.Default._DEFAULT_SEARCH_MAX_AGE)"
    }
    
    func bind() {
        bindGesture()
        bindViewModel()
    }
    
    func setData(searchModel: FilterSearchModel) {
        let marriageType = searchModel.searchMarriageType
        let genderType = searchModel.searchGender
        let searchMinAge = searchModel.searchMinAge
        let searchMaxAge = searchModel.searchMaxAge
        
        // 프로필 관련 데이터
        self.marriageCheckView.isCheck = marriageType.contains(.marriage)
        self.digamyCheckView.isCheck   = marriageType.contains(.digamy)
        self.buddyCheckView.isCheck    = marriageType.contains(.buddy)
        
        // 성별 관련 데이터
        self.maleCheckView.isCheck   = genderType.contains(.male)
        self.femaleCheckView.isCheck = genderType.contains(.female)
        
        // 나이 관련 데이터
        self.ageLabel.text = "\(searchMinAge)" + " ~ " + "\(searchMaxAge)"
        
        ageSettingSlider.value = [CGFloat(searchMinAge), CGFloat(searchMaxAge)]
    }
    
    @objc func sliderChanged(_ slider: MultiSlider) {
        
        DeviceManager.Vibration.medium.vibrate()
        
        if let minAge = slider.value.first, let maxAge = slider.value.last {
            
            self.selectAge(minAge: Int(minAge), maxAge: Int(maxAge))
            
            ageLabel.text = "\(Int(minAge))" + " ~ " + "\(Int(maxAge))"
        }
    }
    
}
