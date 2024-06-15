//
//  RecentSearchHeader.swift
//  MeaningOut
//
//  Created by 박다현 on 6/14/24.
//

import UIKit

class RecentSearchHeader: UITableViewHeaderFooterView {

    let titleLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.text = "최근 검색"
        return label
    }()

    let deleteButton = {
        let button = UIButton()
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(AppColor.primary, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(deleteAllButtonClicked), for: .touchUpInside)
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
    
    @objc func deleteAllButtonClicked(){
        print("전체 삭제 클릭")
    }
}
