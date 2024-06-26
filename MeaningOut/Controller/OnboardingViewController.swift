//
//  ViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/13/24.
//

import UIKit
import SnapKit

final class OnboardingViewController: BaseViewController {
    
    private let mainView = OnboardingView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true;
    }
    
    override func configureView(){
        self.navigationController?.navigationBar.isHidden = true;
    }

    private func setButtonAction(){
        mainView.startbutton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc private func startButtonTapped(){
        let nextVc = ProfileNickNameViewController()
        navigationController?.pushViewController(nextVc, animated: true)
    }

}

