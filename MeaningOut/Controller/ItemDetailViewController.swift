//
//  ItemDetailViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/15/24.
//

import UIKit
import WebKit

final class ItemDetailViewController: UIViewController {

    private let webView = WKWebView()
    var data:Item?{
        didSet{
            favorite = UserDefaultsManager.favorite[data!.productId] ?? false
            configureWebView()
        }
    }

    var favorite:Bool = false
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
        configureNavigationItem()
    }
    
    private func configureHierarchy(){
        view.addSubview(webView)
    }
    private func configureLayout(){
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        view.backgroundColor = .white
        navigationItem.title = data?.title
    }
    
    private func configureNavigationItem(){
        if favorite{
            let fav = UIBarButtonItem(image: UIImage(systemName: IconName.bagFill), style: .plain, target: self, action: #selector(favButtonTapped))
            fav.tintColor = AppColor.gray01
            navigationItem.rightBarButtonItem = fav
        }else{
            let fav = UIBarButtonItem(image: UIImage(systemName: IconName.bag), style: .plain, target: self, action: #selector(favButtonTapped))
            fav.tintColor = AppColor.gray01
            navigationItem.rightBarButtonItem = fav
        }
            
    }
    
    private func configureWebView(){
        let url = URL(string: data!.link)!
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    //즐겨찾기 버튼 액션
    @objc private func favButtonTapped(){
        favorite.toggle()
        configureNavigationItem()
        
        UserDefaultsManager.favorite[data!.productId] = favorite
    }

}
