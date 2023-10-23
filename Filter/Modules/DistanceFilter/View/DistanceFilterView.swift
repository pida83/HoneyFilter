//
//  DistanceFilterView.swift
//  GlobalHoneys
//
//  Created by BEYun on 2023/07/04.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import UIKit
import CoreLocation
import SnapKit
import Then
import RxSwift
import CommonUI

class DistanceFilterView: UIView {
    
    var disposeBag = DisposeBag()
    
    var viewModel : DistanceFilterViewModel!
    
    let containerView = UIView().then {
        $0.clipsToBounds = false
        $0.backgroundColor = .white
        $0.roundCorners(cornerRadius: 12, maskedCorners: [.allCorners])
    }
    
    @StackViewProperty(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 9)
    var stackView = UIStackView()
    
    // 타이틀 & 토글 버튼 섹션
    let titleWrapperView = UIView().then {
        $0.backgroundColor = .clear
    }

    let titleLabel = UILabel().then {
        $0.sizeToFit()
        $0.numberOfLines = 1
        $0.setLineHeight(25)
        $0.textAlignment = .left
        $0.textColor = .gray50
        $0.font = .b17
        $0.text = "Distance".localized()
    }
    
    var toggleSwitch = UISwitch().then {
        $0.transform = CGAffineTransform(scaleX: 0.705, y: 0.645)
        $0.onTintColor = .primary500
        $0.offTintColor(color: .greyishTwo)
        $0.isOn = true
        $0.isUserInteractionEnabled = true
    }
    
    // 거리 섹션
    let distanceWrapperView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    @StackViewProperty(axis: .horizontal, distribution: .fill, spacing: 4)
    var labelStackView = UIStackView()
    
    @LabelProperty(text: "Up to".localized(), textColor: .gray20, font: .m18)
    var upToOrFromLabel = UILabel().then {
        $0.setCharacterSpacing(-0.45)
    }
    
    @LabelProperty(text: "1", textColor: UIColor(r: 149, g: 104, b: 0), font: .b18)
    var minDistanceLabel = UILabel().then {
        $0.setCharacterSpacing(-0.45)
    }
    
    @LabelProperty(text: "to".localized(), textColor: .gray20, font: .m18)
    var toLabel = UILabel().then {
        $0.setCharacterSpacing(-0.45)
    }
    
    @LabelProperty(text: "kilometers".localized(), textColor: UIColor(r: 149, g: 104, b: 0), font: .b18)
    var maxDistanceLabel = UILabel().then {
        $0.setCharacterSpacing(-0.45)
    }
    
    @LabelProperty(text: "away".localized(), textColor: .gray20, font: .m18)
    var awayLabel = UILabel().then {
        $0.setCharacterSpacing(-0.45)
    }
    
    var emptyView = UIView()
    
    var sliderBar = MultiSlider().then {
        $0.orientation = .horizontal
        
        $0.minimumValue = minimumValue
        $0.maximumValue = maximumValue
        $0.value = [ defaultMinValue, defaultMaxValue ]
        
        $0.outerTrackColor = .grayE1
        $0.tintColor = UIColor(r: 242, g: 193, b: 3)
        
        $0.trackWidth = 8
        $0.showsThumbImageShadow = true
        $0.thumbSize = 24
        $0.snapStepSize = 1
        $0.isHapticSnap = false
        $0.distanceBetweenThumbs = 1
        $0.thumbImage = ResourceManager.image.btnSlider.image
        $0.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
    }
    
    var locationManager = CLLocationManager().then { $0.desiredAccuracy = kCLLocationAccuracyBest }
    
    
    // Slider 총 420칸
    // * 이동 단위
    // 1 ~ 100km : 1km (100칸)
    // 100 ~ 1000km : 10km (90칸)
    // 1000 ~ 24000 : 100km (230칸)
    static let minimumValue: CGFloat = 0
    static let maximumValue: CGFloat = 420
    static let defaultMinValue: CGFloat = 0
    static let defaultMaxValue: CGFloat = 420
    
    var searchMinValue: Int {
        get {
            return getSearchValue(sliderValue: sliderBar.value.first) ?? Int(DistanceFilterView.defaultMinValue)
        }
    }
    
    var searchMaxValue: Int {
        get {
            return getSearchValue(sliderValue: sliderBar.value.last) ?? Int(DistanceFilterView.defaultMaxValue)
        }
    }
    
    var _requestSearch: PublishSubject<Void> = .init()
    
    var _toggle: PublishSubject<Bool> = .init()
    
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
        setDelegate()
        addComponents()
        setConstraints()
    }
    
    func setDelegate() {
        locationManager.delegate = self
    }
    
  
    func addComponents() {
        configureContainerView()
        configureStackView()
        configureArrangeView()
    }
    
 
    func setConstraints() {
        setContainerViewConstraint()
        setStackViewConstraint()
        setStackViewConstraint()
        configureArrangeViewConstraint()
    }
   
    
    func bind() {
        bindGesture()
        bindViewModel()
    }
    
    func setData(searchModel: FilterSearchModel) {
        var distanceMaxValue: CGFloat = 0
        var distanceMinValue: CGFloat = 0
        
        distanceMaxValue = getSliderValue(srchValue: searchModel.srchMaxDistance) ?? DistanceFilterView.defaultMaxValue
        distanceMinValue = getSliderValue(srchValue: searchModel.srchMinDistance) ?? DistanceFilterView.defaultMinValue
        
        sliderBar.value = [ distanceMinValue, distanceMaxValue ]
        updateDistanceLabel(minDistance: Int(distanceMinValue), maxDistance: Int(distanceMaxValue))
    }
    
    func getSliderValue(srchValue: Int?) -> CGFloat? {
        guard let srchValue else { return nil }
        
        switch srchValue {
        case 101...1000:
            let value = 100 + (srchValue - 100) / 10
            return CGFloat(value)
            
        case 1001...24000:
            let value = 190 + (srchValue - 1000) / 100
            return CGFloat(value)
            
        default:
            return CGFloat(srchValue)
        }
    }
    
    func getSearchValue(sliderValue: CGFloat?) -> Int? {
        guard let sliderValue else { return nil }
        
        switch sliderValue {
        case 101...190:
            let value = 100 + (sliderValue - 100) * 10
            return Int(value)
            
        case 191...420:
            let value = 1000 + (sliderValue - 190) * 100
            return Int(value)
            
        default:
            return Int(sliderValue)
        }
    }
    
  
    
    func refreshFilter() {
        self.isDistance(enable: true)
        sliderBar.value = [ DistanceFilterView.defaultMinValue, DistanceFilterView.defaultMaxValue ]
        updateDistanceLabel(minDistance: Int(DistanceFilterView.defaultMinValue), maxDistance: Int(DistanceFilterView.defaultMaxValue))
    }
    
    func requestSearch() {
        let curCoordinate = locationManager.location?.coordinate
        
        log.i("위치: ( \(curCoordinate?.latitude), \(curCoordinate?.longitude) )")
        
        var searchModel = self.viewModel.getSearchModel()
            searchModel.memLatitude = curCoordinate?.latitude
            searchModel.memLongitude = curCoordinate?.longitude
        log.d(searchModel)

        self.viewModel.setSearch(model: searchModel)
        
        _requestSearch.onNext(())
    }
    

    
    @objc func sliderChanged(_ slider: MultiSlider) {
        
        DeviceManager.Vibration.medium.vibrate()
        
        if let minValue = slider.value.first,
        let maxValue = slider.value.last {
            let minIntValue = Int(minValue)
            let maxIntValue = Int(maxValue)
            
            if minValue > 410 {
                sliderBar.value = [ 410 , maxValue ]
            }
            
            self.selectDistance(minDistance: minValue, maxDistance: maxValue)
        }
    }
    
}
