//
//  ItemDetailViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/15/24.
//

import UIKit
import WebKit

protocol FavoriteDelegate:AnyObject{
    func resetFavButton(_ id:String)
}

final class ItemDetailViewController: BaseViewController {

    private let webView = WKWebView()
    private var favorite:Bool = false
    weak var delegate:FavoriteDelegate?
    
    var data:Item?{
        didSet{
            guard let data else { return }
            favorite = UserDefaultsManager.favorite[data.productId] ?? false
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureNavigationItem()
        configureWebView()
        navigationItem.title = data?.titleBoldTag
    }
    
    func configureHierarchy(){
        view.addSubview(webView)
    }
    func configureLayout(){
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
        guard let data else {
            self.showToast(message: "네트워크 통신이 실패하였습니다.\n 잠시 후 다시 시도해주세요.")
            return
        }
        guard let url = URL(string: data.link) else {
            self.showToast(message: "해당 상품의 경로가 더 이상 유효하지 않습니다.")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    //즐겨찾기 버튼 액션
    @objc private func favButtonTapped(){
        favorite.toggle()
        configureNavigationItem()
        guard let data else { return }
        UserDefaultsManager.favorite[data.productId] = favorite
        delegate?.resetFavButton(data.productId)
    }

}
