//
//  recentSearchCell.swift
//  MeaningOut
//
//  Created by 박다현 on 6/14/24.
//

import UIKit

class RecentSearchCell: UITableViewCell {

    let iconImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "clock")
        img.tintColor = .black
        return img
    }()
    let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let deleteButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureHierarchy(){
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(deleteButton)
    }
    private func configureLayout(){
        iconImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(iconImageView.snp.height)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
        }
        deleteButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(15)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(iconImageView.snp.height)
        }
    }
    private func configureUI(){
        
    }

    @objc func deleteButtonClicked(){
        print("삭제 클릭")
    }

}
