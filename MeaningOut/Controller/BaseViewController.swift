//
//  BaseViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/25/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    func configureHierarchy(){}
    func configureLayout(){}
    func configureView(){}
    


}
