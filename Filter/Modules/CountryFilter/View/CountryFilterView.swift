//
//  CountryFilterView.swift
//  GlobalHoneys
//
//  Created by BEYun on 2023/07/05.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import UIKit

import SnapKit
import Then
import RxSwift
import CommonUI

class CountryFilterView: UIView {
    
    var disposeBag = DisposeBag()
    
    var viewModel : CountryFilterViewModel!
    
    let containerView = UIView().then {
        $0.clipsToBounds = false
        $0.backgroundColor = .white
        $0.roundCorners(cornerRadius: 12, maskedCorners: [.allCorners])
    }
    
    @StackViewProperty(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 0, description: "래퍼 스택뷰 - [타이틀 / 나라 필터 / More 버튼]")
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
        $0.text = "Country (Maximum 5)".localized()
    }
    
    var toggleSwitch = UISwitch().then {
        $0.transform = CGAffineTransform(scaleX: 0.705, y: 0.645)
        $0.onTintColor = .primary500
        $0.offTintColor(color: .greyishTwo)
        $0.isOn = false
        $0.isUserInteractionEnabled = true
    }
    
    @StackViewProperty(axis: .vertical, backgroundColor: .white, distribution: .fill, spacing: 0, description: "Sticky Header 스택 뷰(타이틀 + 국가 태그)")
    var stickyHeaderStackView = UIStackView()
    
    
    // 검색 바 & 대륙 바 & 국가 테이블 뷰
    @StackViewProperty(axis: .vertical, backgroundColor: .white, alignment: .fill, distribution: .fill, spacing: 0, description: "레이아웃 스택")
    var wrapperStackView: UIStackView = .init(frame: .zero).then {
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    @ViewProperty(isHidden: true, description: "태그 스크롤 뷰")
    var tagStackWrapper = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    
    var tagStackView: CountryTagContainer = CountryTagContainer(frame: .init(x: 0, y: 0, width: 0, height: 0))
    
    @ViewProperty(backgroundColor: .white, description: "패딩 뷰")
    var paddingView = UIView()
    
    @ViewProperty(isHidden: false, backgroundColor: .white, isRound: false, description: "서치바 래퍼")
    var inputBarWrapper: UIView = .init(frame: .zero)
    
    var inputBarView = SearchBarView()
    
    @ViewProperty(isHidden: false, backgroundColor: .white, isRound: false, description: "대륙 선택바 래피")
    var continentWrapper: UIView = .init(frame: .zero)
    
    var continentView = ContinentView()
    
    @ViewProperty(isHidden: false, backgroundColor: .white, isRound: false, description: "테이블 뷰 래퍼")
    var tableViewWrapper: UIView = .init(frame: .zero)
    
    var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.separatorColor = .grayF1
        $0.isScrollEnabled = false
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.allowsMultipleSelection = true
        $0.rowHeight = 40
        $0.register(CountryCell.self, forCellReuseIdentifier: CountryCell.identifier)
    }
    
    // More 버튼
    let moreButton = UIView().then {
        $0.backgroundColor = .primary300
        $0.roundCorners(cornerRadius: 8, maskedCorners: [.allCorners])
        $0.isHidden = true
    }
    
    let moreLabelWrapperView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let moreLabel = UILabel().then {
        $0.sizeToFit()
        $0.text = "More".localized()
        $0.font = .m14
        $0.textColor = .gray50
        $0.textAlignment = .center
        $0.setLineHeight(20)
    }
    
    let moreImage = UIImageView().then {
        $0.image = ResourceManager.image.iconMore.image
    }
    
    var countryList: [CountryCode] = []
    
    var searchText = ""
    
    // 선택했을 때 태그를 만들어 처리 한다 // 필터뷰를 열었을 경우 기존 필터를 유지 한다
    var selectedTag: Set<CountryTagView> = [] {
        
        didSet {
            self.setSelectedList()
            self.setCountry()
        }
    }
    
    var inputBarReset: PublishSubject<Void> = .init()
    
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
        addComponents()
        setConstraints()
        setDelegate()
    }
    
   
    
    func addComponents() {
        self.addSubview(containerView)
        
        containerView.addSubview(stackView)
        
        configureStackView()
    }
    
    func setConstraints() {
        wrapperStackView.setCustomSpacing(10, after: inputBarWrapper)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        setStickyHeaderStackViewConstraint()
        
        setWrapperStackViewConstraint()
        
        // 더보기 버튼 숨김
//        setMoreButtonConstraint()
        
    }
    
    func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setCountryList(list: [CountryCode]) {
        self.countryList = list
    }
       
    
    func setCountryList(viewModel: FilterSearchable, continent: String?, newString: String?) {
        let inputString = newString ?? ""
        let continent = continent ?? "All"
        
        if inputString == "" || inputString == SearchBarView.placeHolderText {
            
            let list = self.viewModel._countries.value
            
            if continent == "All" {
                countryList = list
            } else {
                countryList = list
                    .filter( {$0.continent.contains(continent)} )
//                    .sorted(by: { $0.name < $1.name })
            }
            
        } else {
            
            let list = self.viewModel._countries.value.filter {
                $0.name.lowercased().contains(inputString.lowercased())
            }
            
            if continent == "All" {
                countryList = list
            } else {
                countryList = list
                    .filter( {$0.continent.contains(continent)} )
//                    .sorted(by: { $0.name < $1.name })
            }
            
        }
        
        setSelectedLayout()
        updateTableViewHeight()
    }
    
    func setData(searchModel: FilterSearchModel) {
        selectedTag = .init(searchModel.srchLocLCodeList.map(makeSelectedTag(data:)))
        inputBarView.setData(searchText: searchText)
        setSelectedList()
        setSelectedLayout()
        updateTableViewHeight()
    }
    
    func didSearch() {
        searchText = inputBarView.textView.text ?? ""
    }
    
    func expandTableView() {
        if !countryList.isEmpty {
            let countryCnt = self.countryList.count
            
            tableViewWrapper.snp.updateConstraints {
                $0.height.equalTo(40 * countryCnt + 16)
            }
            
//            moreButton.isHidden = true
        }
    }
    
    func setDimmedView(_ isDimmed: Bool) {
        tagStackWrapper.alpha = isDimmed ? 0.4 : 1
        wrapperStackView.alpha = isDimmed ? 0.4 : 1
//        moreButton.alpha = isDimmed ? 0.4 : 1
    }
    
    
    func refreshFilter() {
        isCountry(enable: false)
        selectedTag = []
        searchText = ""
        inputBarView.textView.resignFirstResponder()
        inputBarReset.onNext(())
        tableView.reloadData()
    }
    
}
