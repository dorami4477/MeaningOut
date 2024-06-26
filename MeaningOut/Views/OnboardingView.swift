//
//  OnboardingView.swift
//  MeaningOut
//
//  Created by 박다현 on 6/26/24.
//

import UIKit


final class OnboardingView:BaseView{
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "FavoriteBOX"
        label.font = .systemFont(ofSize: 38, weight: .black)
        label.textColor = AppColor.primary
        label.textAlignment = .center
        return label
    }()
    
    private let mainImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "launch")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let startbutton = PrimaryButton(title: "시작하기", active: true)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy(){
        addSubview(mainImageView)
        addSubview(titleLabel)
        addSubview(startbutton)
    }
    
    override func configureLayout(){
        mainImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(30)
            make.centerY.equalTo(snp.centerY)
            make.height.equalTo(mainImageView.snp.width).multipliedBy(0.75)
        }
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(30)
            make.bottom.equalTo(mainImageView.snp.top).offset(-50)
        }
        startbutton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }
}
