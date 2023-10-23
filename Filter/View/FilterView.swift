//
//  FilterView.swift
//  GlobalHoneys
//
//  Created by BEYun on 2023/06/29.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import UIKit
import CoreLocation

import SnapKit
import RxSwift
import RxCocoa
import Then
import CommonUI
import Core



class FilterView: UIView {
    // 필터 초기값
    enum Default {
        static var _DEFAULT_SEARCH_MIN_AGE: Int = 18
        static var _DEFAULT_SEARCH_MAX_AGE: Int = 120
        static var _DEFAULT_MARRIAGE_TYPE : Set<MarriageType>  = [.marriage, .digamy, .buddy] // 일반유형이 추가되면 버디까지 넣어주자
        static var _DEFAULT_GENDER_TYPE : Set<Gender>          = [.male, .female]
        static var _DEFAULT_MIN_DISTANCE : Int = 0
        static var _DEFAULT_MAX_DISTANCE : Int = 24000
    }
    
    // 필터 애니메이션
    enum FilterAnimateState {
        case show
        case hide
    }
    
    var disposeBag = DisposeBag()
    
    var viewModel: FilterViewModel!
    
    @ViewProperty(backgroundColor: .dimView40)
    var dimView = UIView()
    
    @ViewProperty(backgroundColor: .white)
    var containerView = UIView().then {
        $0.roundCorners(cornerRadius: 12, maskedCorners: [.topLeft, .topRight])
    }
    
    @ViewProperty(backgroundColor: .clear)
    var dismissInteractionView = UIView()
    
    var dismissBar = UIImageView(frame: .init(origin: .zero, size: .init(width: 120, height: 4))).then {
        $0.image = ResourceManager.image.dismissBar.image
    }
    
    var closeButton = UIImageView(frame: .init(origin: .zero, size: .init(width: 36, height: 36))).then {
        $0.image = ResourceManager.image.iconClose.image
    }
    
    @ViewProperty(backgroundColor: .white)
    var contentView = UIView()
    
    @ViewProperty(backgroundColor: .clear)
    var titleWrapperView = UIView()
    
    var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    @StackViewProperty(axis: .vertical, backgroundColor: .clear, alignment: .fill, distribution: .fill, spacing: 10, description: "필터 스택 뷰")
    var stackView = UIStackView()
    
    var conditionFilterView: ConditionFilterView = ConditionFilterView(frame: .zero)
    
    var distanceFilterView: DistanceFilterView = DistanceFilterView(frame: .zero)
    
    var countryFilterView: CountryFilterView = CountryFilterView(frame: .zero)
    
    @ViewProperty(backgroundColor: .clear)
    var paddingView = UIView()
    
    var buttonGradientView = UIView().then {
        $0.frame.size = CGSize(width: DeviceManager.Size.width - 24, height: 50)
        $0.setGradient(color1: UIColor(rgb: 255, a: 0), color2: UIColor(rgb: 255, a: 1), axis: .vertical)
    }
    
    let buttonStackView = UIStackView().then {
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        $0.backgroundColor = .clear
        
        $0.axis = .horizontal
        $0.spacing = 6
        $0.distribution = .fill
    }
    
    let confirmButton = MainButton(.main, title: "Confirm".localized(), textLine: 1)
    
    let resetButton = MainButton(.light, title: "Reset".localized(), textLine: 1)
    
    @ViewProperty(backgroundColor: .clear)
    var confirmShadow = UIView()
    
    @ViewProperty(backgroundColor: .clear)
    var resetShadow = UIView()
    
    let scrollToTopButton = UIImageView().then {
        $0.image = ResourceManager.image.btnUp.image
        $0.isHidden = true
    }
    
//    convenience init(frame: CGRect, viewModel: FilterViewModel) {
//        self.init(frame: frame)
//        self.viewModel = viewModel
//        
//        if viewModel.dependLocation == .main {
//            conditionFilterView.setViewModel(viewModel: viewModel)
//        }
//        
//        
//        distanceFilterView.setViewModel(viewModel: viewModel)
//        countryFilterView.setViewModel(viewModel: viewModel)
//    }
//    
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.confirmShadow.layer.applySketchShadow(alpha: 0.24, x: 0, y: 2, blur: 6, radius: 12)
        self.resetShadow.layer.applySketchShadow(alpha: 0.24, x: 0, y: 2, blur: 6, radius: 12)
    }
    
    func commonInit() {
        addComponents()
        setConstraints()
        setDelegate()
        reset()
    }
    
    func addComponents() {
        addKeyboardObserver()
        addSwipeGesture()
        
        self.addSubviews("메인 뷰") {
            dimView
            containerView.addSubviews {
                getContentView()
                scrollToTopButton
                getButtonGradientView()
            }
        }
    }
    /// setConstraint
    func setConstraints() {
        setDimViewConstaint()
        setContainerViewConstraint()
        setContentViewConstraint()
        setScrollViewConstraint()
        setArrangedViewConstraint()
        setScrollToTopButtonConstraint()
        setButtonGradientViewConstraint()
        
        //섹션 별 구분선 추가
        makeSeparator()
    }
    
    func setDelegate() {
        scrollView.delegate = self
    }
    
    func addKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func addSwipeGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(swipeUpAndDown))
        dismissInteractionView.addGestureRecognizer(gesture)
    }
    
    func updateCountryViewHeight() {
        // [타이틀 / 태그 / 검색 바 / 대륙] => 160
        // [테이블 뷰 셀 높이 * 나라 갯수 + 테이블 뷰 인셋] => 160 + 40 * countryCnt + 16
        
        let contryCnt = viewModel.countryCnt
        
        countryFilterView.snp.updateConstraints {
            $0.height.lessThanOrEqualTo(160 + 40 * contryCnt + 16)
        }
    }
    
    // .show -> 기존 frame.y로 애니메이션
    // .hide -> 기기 화면 아래로 애니메이션
    func animateView(state: FilterAnimateState) {
        
        switch state {
        case .show:
            self.isHidden = false
            UIView.animate(withDuration: 0.7,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0.3,
                           options: .curveEaseIn) {[weak self] in
                guard let self = self else { return }
                
                self.containerView.frame.origin.y = DeviceManager.Inset.top + 50
            }
            
        case .hide:
            UIView.animate(withDuration: 0.7,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0.3,
                           options: .curveEaseIn){ [weak self] in
                guard let self = self else { return }
                
                self.containerView.frame.origin.y = DeviceManager.Size.height
                self.dimView.isUserInteractionEnabled = false
            } completion: { _ in
                self.isHidden = true
                self.dimView.isUserInteractionEnabled = true
            }
            self.resetIfNeeds()
        }
    }
    
//    // 검색 모델 생성
//    func makeSearchModel() -> FilterSearchModel {
//        
//        var model: FilterSearchModel = viewModel.getSearchModel()
//        switch self.viewModel._currentState {
//        case .distance:
//            let curCoordinate = distanceFilterView.locationManager.location?.coordinate
//            log.i("위치: ( \(curCoordinate?.latitude), \(curCoordinate?.longitude) )")
//
//            model.memLatitude = curCoordinate?.latitude ?? 0
//            model.memLongitude = curCoordinate?.longitude ?? 0
//            model.srchMinDistance = distanceFilterView.searchMinValue
//            model.srchMaxDistance = distanceFilterView.searchMaxValue
//
//        case .country:
//            self.countryFilterView.didSearch()
//
//            if countryFilterView.selectedTag.isEmpty {
//                self.viewModel._currentState = .initial
//            }
//
//            model.srchLocLCodeList = Set(countryFilterView.selectedTag.map{ $0.data })
//
//        case .initial:
//            break
//        }
//
////        self.resetView()
//        self.animateView(state: .hide)
//
//        return model
//    }
    
    // dimView 탭, 스와이프
    // 검색모델을 통한 데이터 로드
//    func loadFilterData() {
//        conditionFilterView.setData(searchModel: self.viewModel.getSearchModel())
//        distanceFilterView.setData(searchModel: self.viewModel.getSearchModel())
//        countryFilterView.setData(searchModel: self.viewModel.getSearchModel())
//
//        self.countryFilterView.inputBarView.textView.resignFirstResponder()
//        self.scrollView.setContentOffset(.zero, animated: false)
//
//    }
    
    // 상태값에 맞게 뷰 초기화
    func resetView() {
        switch self.viewModel._currentState {
        case .initial:
            countryFilterView.refreshFilter()
            distanceFilterView.refreshFilter()
        case .distance:
            countryFilterView.refreshFilter()
        case .country:
            distanceFilterView.refreshFilter()
            
        default:
            break
        }
        
        self.scrollView.setContentOffset(.zero, animated: false)
    }
    
//    func setCurrentState() {
//        let distanceToggle = distanceFilterView.toggleSwitch.isOn
//        let countryToggle = countryFilterView.toggleSwitch.isOn
//        
//        var state: FilterViewState = .initial
//        
//        if !distanceToggle && !countryToggle {
//            state = .initial
//        } else if distanceToggle {
//            state = .distance
//        } else if countryToggle {
//            state = .country
//        }
//        
//        self.viewModel._currentState = state
//    }
    
    func checkConditions() -> Bool {
        let model = self.viewModel.getSearchModel()
        let marriageIsDefault = model.searchMarriageType.count == Default._DEFAULT_MARRIAGE_TYPE.count
        let genderIsDefault = model.searchGender.count == Default._DEFAULT_GENDER_TYPE.count
        let ageIsDefault = model.searchMinAge == Default._DEFAULT_SEARCH_MIN_AGE &&
        model.searchMaxAge == Default._DEFAULT_SEARCH_MAX_AGE

        switch self.viewModel._currentState {
        case .initial,
             .country where self.countryFilterView.selectedTag.isEmpty:
            return !(marriageIsDefault && genderIsDefault && ageIsDefault)

        case .distance, .country:
            return true

        default:
            return false
        }

    }
    
//    func setCurrentToggledView() {
////        switch viewModel.currentState {
////
////        case .initial, .distance:
////            isDistance(enable: true)
////            isCountry(enable: false)
////
////        case .country:
////            isDistance(enable: false)
////            isCountry(enable: true)
////        }
//    }
    
    func scrollToTop() {
        self.scrollView.setContentOffset(.zero, animated: true)
    }
}

