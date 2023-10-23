//
//  CountryFilterView+TableView.swift
//  GlobalHoneys
//
//  Created by BEYun on 2023/07/06.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import UIKit

extension CountryFilterView {
    
    // 태그를 선택한 경우 레이아웃을 처리를 위한 메서드
    func setSelectedList() {
        self.tagStackView.removeAll()
        
        self.selectedTag.enumerated().forEach {
            self.tagStackView.addArrangedSubview($0.element)
            
        }
        
        self.titleLabel.text = self.selectedTag.count == 0 ? "Country (Maximum 5)".localized() : "Country (%@)".localized("\(self.selectedTag.count)")
        tagStackWrapper.isHidden = self.selectedTag.isEmpty ? true : false
    }
    
    // 테이블 리로드 와 이 후 선택됐던 셀을 다시 그려주기 위한 메서드
    func setSelectedLayout() {
        self.tableView.reloadData()
        
        let codes = self.selectedTag.map{ $0.data.code}
        
        self.countryList.enumerated().forEach{ row in
            if codes.contains(where: { $0 == row.element.code}) {
                tableView.selectRow(at: .init(row: row.offset, section: 0), animated: false, scrollPosition: .none)
            }
        }
    }
    
    func makeSelectedTag(data: CountryCode) -> CountryTagView {
        let tag = CountryTagView(frame: CGRect(x: 0, y: 0, width: 0, height: 27))

        tag.bind(data: data)
        
        tag.tapGesture
            .withUnretained(self)
            .subscribe(onNext: { (this, _) in
                this.selectedTag.remove(tag)
                this.setSelectedLayout()
            })
            .disposed(by: disposeBag)
        
        return tag
    }
    
    // 검색된 나라 갯수에 따른 테이블 뷰의 가변적인 높이를 적용하기 위한 메소드
    func updateTableViewHeight() {
        let countryCnt = self.countryList.count
        self.tableViewWrapper.snp.updateConstraints {
            // 테이블 셀 높이(40) * 셀 개수 + 탑 바텀 인셋(16)
            $0.height.equalTo(40 * countryCnt + 16)
        }
        
//        if countryCnt > 8 {
//            self.tableViewWrapper.snp.updateConstraints {
//                $0.height.equalTo(336)
//            }
//
////            self.moreButton.isHidden = self.wrapperStackView.isHidden
//
//        } else {
//
//
////            self.moreButton.isHidden = true
//        }
        
    }
}


extension CountryFilterView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countryList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = countryList[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.identifier, for: indexPath) as? CountryCell else {
            return UITableViewCell()
        }
        
        cell.configUI(countryCode: data)
        
        return cell
    }
}

extension CountryFilterView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.toggleSwitch.isOn == false {
            self.isCountry(enable: true)
        }
        
        guard let countryCode = self.countryList[safe: indexPath.row] else {
            return
        }
        
        isCountryAppendable() ? self.selectCountry(code: countryCode) : tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        guard let countryCode = self.countryList[safe: indexPath.row] else {
            return
        }
        
        self.selectCountry(code: countryCode)
    }
}
