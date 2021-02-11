//
//  ProductViewController.swift
//  GBShop
//
//  Created by Maxim Safronov on 27.12.2020.
//

import UIKit
import Kingfisher

protocol ReviewCellDelegate : class {
    func didPressButton(_ cell: ProductReviewCell)
}

class ProductViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var tblReviewsList: UITableView! {
        didSet {
            tblReviewsList.delegate = self
            tblReviewsList.dataSource = self
        }
    }
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnAddToBasket: UIButton!
    
    // MARK: Properties
    var reviewList: ReviewListResult = []
    var product: ProductResult?
    let catalogFabric = RequestFactory().makeGoodsRequestFactory()
    let reviewFabric = RequestFactory().makeReviewsRequestFactory()
    let basketFabric = RequestFactory().makeBasketRequestFactory()
    var isAddReviewClicked: Bool = false
    var isAddToCartClicked: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    // MARK: - Methods
    func loadData() {
        if let productId = productId {
            catalogFabric.getProductBy(productId: productId) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case let .success(product):
                    DispatchQueue.main.async {
                        self.productPageInitWith(product: product)
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func loadAddReviewScreen() {
        guard let addReviewVC = AppService.shared.getScreenPage(identifier: "addReviewPage") as? AddReviewController else { return }
        addReviewVC.needLoginDelegate = self
        addReviewVC.modalPresentationStyle = .overFullScreen
        present(addReviewVC, animated: true)
    }
    
    func productPageInitWith(product: ProductResult) {
        self.product = product
        lblDescription.text = product.description
        lblProductName.text = product.name
        lblPrice.text = String(product.price) + " RUB"
        
        let imageSource = product.image
        if imageSource != "",
           let image = URL(string: imageSource) {
            
            imgProduct.kf.setImage(with: image)
        }
        
        productLoadReview()
    }
    
    func productLoadReview() {
        if let pID = productId {
            reviewFabric.getReviewsForProductBy(productId: pID) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case let .success(reviews):
                    DispatchQueue.main.async {
                        self.reviewList = reviews
                        self.tblReviewsList.reloadData()
                    }
                    
                case .failure(_):
                    break
                }
            }
        }
    }
    
    private func removeReview(indexPath: IndexPath) {
        if !isNeedLogin {
            guard userEmail == reviewList[indexPath.section].userEmail else {
                return showErrorMessage(message: "Нельзя удалить чужой отзыв.")
            }
            guard let reviewId = reviewList[indexPath.section].id else { return }
            reviewFabric.removeReviewBy(reviewId: reviewId) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                
                case .success(_):
                    self.productLoadReview()
                case .failure(_):
                    self.showErrorMessage(message: "Не удалось удалить отзыв!")
                }
            }
        } else {
            login(delegate: self)
        }
    }
    
    // MARK: - Actions
    @IBAction func addReviewClicked() {
        if !isNeedLogin {
            isAddReviewClicked = true
            loadAddReviewScreen()
        } else {
            login(delegate: self)
        }
    }
    
    @IBAction func btnAddToBasketClicked(_ sender: Any) {
        if isNeedLogin {
            login(delegate: self)
        } else {
            isAddToCartClicked = true
        }
        if let productId = productId,
           let userId = appService.session.userInfo?.id {
            basketFabric.addProductToBasketBy(productId: productId, userId: userId, quantity: 1) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.btnAddToBasket.setTitle("В корзине", for: .normal)
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.showErrorMessage(message: "Не получилось добавить товар в корзину")
                    }
                }
            }
        }
    }
}

extension ProductViewController: NeedLoginDelegate {
    func willDisappear(bool: Bool) {
        isAddReviewClicked = false
        isAddToCartClicked = false
    }
    
    func willReloadData() {
        loadData()
        if isAddReviewClicked {
            let addReview = appService.getScreenPage(identifier: "addReviewPage")
            present(addReview, animated: true)
        }
        
        if isAddToCartClicked {
            if let pID = productId,
               let uID = appService.session.userInfo?.id {
                basketFabric.addProductToBasketBy(productId: pID, userId: uID, quantity: 1) { [weak self] response in
                    guard let self = self else { return }
                    
                    switch response.result {
                    case .success(_):
                        DispatchQueue.main.async {
                            self.btnAddToBasket.setTitle("В корзине", for: .normal)
                        }
                    case .failure(_):
                        DispatchQueue.main.async {
                            self.showErrorMessage(message: "Не получилось добавить товар в корзину")
                        }
                    }
                }
            }
        }
    }
}

extension ProductViewController: UITableViewDelegate, UITableViewDataSource, ReviewCellDelegate {
    func didPressButton(_ cell: ProductReviewCell) {
        guard let indexPath = self.tblReviewsList.indexPath(for: cell) else { return }
        removeReview(indexPath: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        reviewList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblReviewsList.dequeueReusableCell(withIdentifier: "productReviewCell") as? ProductReviewCell else {
            assertionFailure("Can't dequeue cell withIndentifier: productViewCell")
            return UITableViewCell()
        }
        cell.cellDelegate = self
        cell.configureWith(review: reviewList[indexPath.section])
        return cell
    }
}
