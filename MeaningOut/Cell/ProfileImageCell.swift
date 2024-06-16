//
//  ProfileImageCell.swift
//  MeaningOut
//
//  Created by 박다현 on 6/13/24.
//

import UIKit


final class ProfileImageCell: UICollectionViewCell {
    
    let mainImageView = {
        let imgView = UIImageView()
        imgView.layer.borderColor = AppColor.gray01.cgColor
        imgView.layer.borderWidth = 1
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        mainImageView.layer.cornerRadius = mainImageView.frame.width / 2
        
    }
    
    private func configureHierarchy(){
        contentView.addSubview(mainImageView)
    }
    private func configureLayout(){
        mainImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }

    private func configureUI(){
        mainImageView.layer.opacity = 0.5
    }
    
    func isSelected(_ selected :Bool){
        if selected{
            mainImageView.layer.borderColor = AppColor.primary.cgColor
            mainImageView.layer.borderWidth = 3
            mainImageView.layer.opacity = 1
        }else{
            mainImageView.layer.borderColor = AppColor.gray01.cgColor
            mainImageView.layer.borderWidth = 1
            mainImageView.layer.opacity = 0.5
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
