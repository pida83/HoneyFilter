//
//  FilterViewInterface.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/19.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation

//메인페이지 필터 로직 정리
//
//    •    ON, OFF -> CheckBox 및 Toggle의 ON/OFF
//
//    0.    메인페이지 검색바
//    0.    필터 검색 모델이 초기 값이 아닐 경우, 필터 아이콘이 체크 아이콘으로 변경됨
//
//    0.    필터 검색 모델의 초기값
//    0.    조건 탭(성별, 나이등) 모두 ON
//    0.    거리 탭 ON
//    0.    국가 탭 OFF
//
//    0.    거리/국가 토글 관련 로직
//    0.    두 토글 스위치 중 하나는 무조건 켜져있어야 함
//    0.    XOR 관계
//
//    0.    조건 탭
//    0.    [결혼/재혼/친구] 섹션과 [남성/여성] 섹션은 1개 이상이 선택되어야 검색 가능
//=> 모두 OFF인 경우, 검색 불가능
//
//    0.    거리 탭
//    0.    ON/OFF 영역 : 거리 타이틀 및 거리 토글 스위치
//    0.    OFF -> ON 전환 :
//1) 1의 ON/OFF 영역 탭
//2) Slide 영역 PanGesture
//
//    6.    국가 탭
//    1.    ON/OFF 영역 : 국가 타이틀 및 국가 토글 스위치
//    2.    OFF -> ON 전환 :
//1) 1의 ON/OFF 영역 탭
//2) 검색 바 & 대륙 바 & 국가 테이블 뷰 탭 (wrapperStackView가 SuperView)
//    3.    국가 미선택 후 검색 = 필터 초기값으로 검색이며, 필터뷰 또한 초기값인 [거리ON/국가OFF]로 초기화

enum FilterViewLocation {
    case main
    case swipe
}

// 필터 기준
// initial -> Distance On / Country Off
// distance -> Distance On / Country Off
// country -> Distance Off / Country On
enum FilterViewState {
    case initial
    case distance
    case country
}
protocol ConditionFilterViewInterface {
    func setViewModel(viewModel: ConditionFilterViewModel)
    
    func selectConditions(type: MarriageType)
    func selectConditions(type: Gender)
    func selectAge(minAge: Int, maxAge: Int)
}

protocol DistanceFilterViewInterface {
    func setViewModel(viewModel: DistanceFilterViewModel)
    func isDistance(enable: Bool)
    func selectDistance(minDistance: CGFloat, maxDistance: CGFloat)
}

protocol CountryFilterViewInterface {
    func setViewModel(viewModel: CountryFilterViewModel)
    func setCountry()
    func selectCountry(code: CountryCode)
    func isCountry(enable: Bool)
    
}

protocol FilterViewInterface: UserInterface {
    
    // TODO: @ 구조를 변경하여 프로토콜로 바꾸자
    var conditionFilterView: ConditionFilterView {get set}
    var distanceFilterView: DistanceFilterView  {get set}
    var countryFilterView: CountryFilterView  {get set}
    
//    func selectConditions(type: MarriageType)     // 검색할 성혼 유형을 선택할 수 있다
//    func selectConditions(type: Gender)           // 검색할 성별 유형을 선택할 수 있다
//    func selectAge(minAge: Int, maxAge: Int)      // 검색할 나이를 선택할 수 있다
//    func isDistance(enable: Bool)                 // 거리를 기준으로 검색할지 선택 할 수 있다
//    func selectDistance(minDistance: CGFloat, maxDistance: CGFloat)   // 검색할 거리를 선택할 수 있다
//    func selectCountry(code: CountryTagView)                         // 국가를 선택할 수 있다
//    func setCountry()                                                // 국가를 추가 했다
//    func isCountry(enable: Bool)                            // 국가로 검색할 수 있다
    func setViewModel(viewModel: FilterViewModel)
    func confirm(to viewModel : FilterSearchable)
    func reset()
    func close()
}

