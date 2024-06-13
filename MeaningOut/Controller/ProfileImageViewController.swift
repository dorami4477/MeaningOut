//
//  ProfileImageViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/13/24.
//

import UIKit

class ProfileImageViewController: UIViewController {

    let profileView = UIView()
    let profileImageView = ProfileImageView("profile_\(Int.random(in: 0...11))", active: true)
    let cameraImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "camera.fill")
        img.backgroundColor = AppColor.primary
        img.tintColor = AppColor.white
        img.layer.cornerRadius = 15
        img.clipsToBounds = true
        img.contentMode = .center
        return img
    }()
    
    lazy var profileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        profileCollectionView.backgroundColor = .blue
    }
    private func configureHierarchy(){
        view.addSubview(profileView)
        [profileImageView, cameraImageView].forEach{ profileView.addSubview($0) }
        view.addSubview(profileCollectionView)
    }
    private func configureLayout(){
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(view.snp.centerX)
            make.width.height.equalTo(100)
        }
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        cameraImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.width.height.equalTo(30)
        }
        profileCollectionView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
    }
    private func configureUI(){
        view.backgroundColor = .white
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
    }

    private func collectionViewLayout() -> UICollectionViewLayout{
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionCellWidth = (UIScreen.main.bounds.width - CVCell.spacingWidth * (CVCell.cellColumns - 1)) / CVCell.cellColumns
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        flowLayout.minimumLineSpacing = CVCell.spacingWidth
        flowLayout.minimumInteritemSpacing = CVCell.spacingWidth
        flowLayout.sectionInset = UIEdgeInsets(top: CVCell.spacingWidth, left: CVCell.spacingWidth, bottom: CVCell.spacingWidth, right: CVCell.spacingWidth)
        return flowLayout
        
    }


}

extension ProfileImageViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCell.identifier, for: indexPath) as! ProfileImageCell
        return cell
    }
    
    
}
