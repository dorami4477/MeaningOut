//
//  recentSearchCell.swift
//  MeaningOut
//
//  Created by 박다현 on 6/14/24.
//

import UIKit

final class RecentSearchCell: UITableViewCell {
    
    let iconImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "clock")
        img.tintColor = .black
        return img
    }()
    let titleLabel = {
        let label = UILabel()
        label.font = AppFont.size14
        return label
    }()
    
    let deleteButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
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
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(iconImageView.snp.height)
        }
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
