//
//  ItemDetailViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/15/24.
//

import UIKit
import WebKit

class ItemDetailViewController: UIViewController {

    let webView = WKWebView()
    var data:Item?{
        didSet{
            favorite = UserDefaultsManager.favorite[data!.productId] ?? false
            configureWebView()
        }
    }

    var favorite:Bool = false
    
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
    func configureNavigationItem(){

        if favorite{
            let fav = UIBarButtonItem(image: UIImage(systemName: "bag.fill.badge.minus"), style: .plain, target: self, action: #selector(favButtonTapped))
            fav.tintColor = AppColor.gray01
            navigationItem.rightBarButtonItem = fav
        }else{
            let fav = UIBarButtonItem(image: UIImage(systemName: "bag.badge.plus"), style: .plain, target: self, action: #selector(favButtonTapped))
            fav.tintColor = AppColor.gray01
            navigationItem.rightBarButtonItem = fav
        }
            
    }
    
    
    private func configureWebView(){
        let url = URL(string: data!.link)!
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    

    @objc private func favButtonTapped(){
        print("즐겨찾기 누름")
        favorite.toggle()
        configureNavigationItem()
        
        UserDefaultsManager.favorite[data!.productId] = favorite
    }

}
