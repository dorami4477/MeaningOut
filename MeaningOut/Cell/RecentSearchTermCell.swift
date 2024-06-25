//
//  RecentSearchTermCell.swift
//  MeaningOut
//
//  Created by 박다현 on 6/24/24.
//

import UIKit

class RecentSearchTermCell: UICollectionViewCell {
    let bubbleView = UIView()
    let titleLabel = UILabel()
    let deleteButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    private func configureHierarchy(){
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(titleLabel)
        bubbleView.addSubview(deleteButton)
    }
    private func configureLayout(){
        bubbleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.trailing.greaterThanOrEqualTo(deleteButton.snp.leading).offset(10)
        }
        deleteButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
        }
    }
    private func configureUI(){
        bubbleView.backgroundColor = .lightGray
        bubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        bubbleView.layer.cornerRadius = 20
        bubbleView.layer.masksToBounds = true
        titleLabel.textColor = AppColor.white
        
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = AppColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
