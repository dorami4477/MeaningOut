//
//  ViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/13/24.
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "MeaningOut"
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
    private let startbutton = PrimaryButton(title: "시작하기", active: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        setButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true;
    }
    
    private func configureHierarchy(){
        view.addSubview(mainImageView)
        view.addSubview(titleLabel)
        view.addSubview(startbutton)
    }
    private func configureLayout(){

        mainImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(30)
            make.centerY.equalTo(view.snp.centerY)
            make.height.equalTo(mainImageView.snp.width).multipliedBy(0.75)
        }
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(30)
            make.bottom.equalTo(mainImageView.snp.top).offset(-50)
        }
        startbutton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
    }
    private func configureUI(){
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true;
    }

    private func setButtonAction(){
        startbutton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc private func startButtonTapped(){
        let nextVc = ProfileNickNameViewController()
        navigationController?.pushViewController(nextVc, animated: true)
    }

}

