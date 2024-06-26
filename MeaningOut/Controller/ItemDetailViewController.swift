//
//  ItemDetailViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/15/24.
//

import UIKit
import WebKit

final class ItemDetailViewController: BaseViewController {

    private let webView = WKWebView()
    var data:Item?{
        didSet{
            favorite = UserDefaultsManager.favorite[data!.productId] ?? false
            configureWebView()
            if data == nil{
                self.showToast(message: "네트워크 통신이 실패하였습니다.\n 잠시 후 다시 시도해주세요.")
            }
        }
    }

    var favorite:Bool = false
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        navigationItem.title = data?.titleBoldTag
    }
    
    override func configureHierarchy(){
        view.addSubview(webView)
    }
    override func configureLayout(){
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureNavigationItem(){
        if favorite{
            let fav = UIBarButtonItem(image: UIImage(named: IconName.bagFill), style: .plain, target: self, action: #selector(favButtonTapped))
            navigationItem.rightBarButtonItem = fav
        }else{
            let fav = UIBarButtonItem(image: UIImage(named: IconName.bag), style: .plain, target: self, action: #selector(favButtonTapped))
            navigationItem.rightBarButtonItem = fav
        }
            
    }
    
    private func configureWebView(){
        guard let data else { return }
        guard let url = URL(string: data.link) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    //즐겨찾기 버튼 액션
    @objc private func favButtonTapped(){
        favorite.toggle()
        configureNavigationItem()
        guard let data else { return }
        UserDefaultsManager.favorite[data.productId] = favorite
    }

}
