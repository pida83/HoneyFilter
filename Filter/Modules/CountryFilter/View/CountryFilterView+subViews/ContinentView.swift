//
//  ContinentView.swift
//  GlobalHoneys
//
//  Created by yeoboya on 2023/06/08.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation
import UIKit
import CommonUI
import SnapKit
import Then

import RxSwift

class ContinentView: CustomView {
    
    lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = .init(width: 60, height: 32)
        $0.minimumInteritemSpacing = 0
        $0.minimumLineSpacing = 0
        $0.scrollDirection = .horizontal
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.contentInset = .zero
        $0.register(ContinentCell.self, forCellWithReuseIdentifier: ContinentCell.identifier)
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.dataSource = self
    }
    
    var underLine = UIView().then {
        $0.backgroundColor = .grayE1
    }
    
    var continentList: [String] = ["All", "America", "Asia", "Europe", "Africa", "Oceania"]
    
    var _selectedContinent: BehaviorSubject<String> = .init(value: "All")
    
    override func initView() {
        super.initView()
        
        
        if let index = continentList.firstIndex(of: "All") {
            collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .left)
        }
    }
    
    override func addComponents() {
        self.addSubviews {
            underLine
            collectionView
        }
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        underLine.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func reset() {
        
        if let index = continentList.firstIndex(of: "All") {
            collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .left)
            _selectedContinent.onNext(continentList[index])
        }
    }
}

extension ContinentView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return continentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContinentCell.identifier, for: indexPath) as? ContinentCell else {
            return UICollectionViewCell()
        }
        
        cell.configUI(text: continentList[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _selectedContinent.onNext(continentList[indexPath.item])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContinentCell.identifier, for: indexPath) as? ContinentCell else {
            return .zero
        }

        cell.configUI(text: continentList[indexPath.item])

        let labelWidth = cell.label.frame.width
        let cellWidth = labelWidth + 16 < 60 ? 60 : labelWidth + 16
        
        return CGSize(width: cellWidth, height: 32)
    }
    
}

class ContinentCell: UICollectionViewCell {
    
    static let identifier = "ContinentCell"
    
    var label = UILabel().then {
        $0.font = .m14
        $0.textColor = .warmGrey
        $0.textAlignment = .center
        $0.layer.masksToBounds = false
    }

    var underLine = UIView().then {
        $0.backgroundColor = .gray20
        $0.isHidden = true
        
    }
    
    var disposeBag = DisposeBag()
    
    override var isSelected: Bool {
        didSet {
            underLine.isHidden = !isSelected
            label.font = isSelected ? .b14 : .m14
            label.textColor = isSelected ? .gray20 : .warmGrey
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initCell() {
        addComponents()
        setConstraints()
    }
    
    func addComponents() {
        self.addSubviews {
            label
            underLine
        }
    }

    func setConstraints() {
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        underLine.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    func configUI(text: String) {
        label.text = text.localized()
        label.sizeToFit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
}
