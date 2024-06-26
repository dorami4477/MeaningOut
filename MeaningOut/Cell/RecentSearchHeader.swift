//
//  RecentSearchHeader.swift
//  MeaningOut
//
//  Created by 박다현 on 6/14/24.
//

import UIKit

final class RecentSearchHeader: UITableViewHeaderFooterView {

    let titleLabel = {
        let label = UILabel()
        label.font = AppFont.size15Bold
        label.text = "최근 검색"
        return label
    }()

    let deleteButton = {
        let button = UIButton()
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(AppColor.primary, for: .normal)
        button.titleLabel?.font = AppFont.size13
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
    }
    private func configureHierarchy(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(deleteButton)
    }
    private func configureLayout(){
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
