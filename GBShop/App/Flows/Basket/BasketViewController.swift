//
//  BasketViewController.swift
//  GBShop
//
//  Created by Maxim Safronov on 28.12.2020.
//

import UIKit

class BasketViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet weak var tblBasket: UITableView! {
        didSet {
            tblBasket.delegate = self
            tblBasket.dataSource = self
        }
    }
    @IBOutlet weak var lblGoodsCount: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblBasketIsEmpty: UILabel!
    @IBOutlet weak var lblGoodsCountTitle: UILabel!
    @IBOutlet weak var lblTotalPriceTitle: UILabel!
    
    // MARK: - Properties
    var basket: GetBasketResult?
    var items: [BasketItems] = []
    let basketFabric = RequestFactory().makeBasketRequestFactory()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isNeedLogin {
            willDisappear(bool: false)
        } else {
            willDisappear(bool: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        if !isNeedLogin {
            loadBasket()
        } else {
            login(delegate: self)
            lblBasketIsEmpty.text = "Необходима авторизация"
            btnLogin.setTitle("Войти", for: .normal)
        }
    }
    
    // MARK: - Methods
    func toggleBasketInterface(hide: Bool = true) {
        tblBasket.isHidden = hide
        lblTotalPrice.isHidden = hide
        lblTotalPriceTitle.isHidden = hide
        lblGoodsCount.isHidden = hide
        lblGoodsCountTitle.isHidden = hide
        btnPay.isHidden = hide
        btnClear.isHidden = hide
        lblBasketIsEmpty.isHidden = !hide
        if items.count > 0 {
            btnLogin.isHidden = !hide
        } else if !isNeedLogin {
            btnLogin.isHidden = hide
        } else {
            btnLogin.isHidden = !hide
        }
    }
    
    // MARK: - Private methods
    private func loadBasket() {
        if let uID = userId {
            basketFabric.getBasketBy(userId: uID) { response in
                switch response.result {
                case let .success(basketResult):
                    DispatchQueue.main.async {
                        self.basket = basketResult
                        self.items = basketResult.basketItems
                        
                        self.tblBasket.reloadData()
                        
                        if basketResult.itemsCount > 0 {
                            self.willDisappear(bool: false)
                            self.lblTotalPrice.text = String(self.basket?.amount ?? 0)
                            self.lblGoodsCount.text = String(self.basket?.itemsCount ?? 0)
                        } else {
                            self.willDisappear(bool: true)
                            self.lblBasketIsEmpty.text = "Корзина пуста"
                        }
                    }
                    
                case .failure(_):
                    DispatchQueue.main.async {
                        self.willDisappear(bool: true)
                        self.lblBasketIsEmpty.text = "Невозможно загрузить данные"
                        self.showErrorMessage(message: "Невозможно загрузить данные")
                    }
                }
            }
        } else {
            willDisappear(bool: true)
            lblBasketIsEmpty.text = "Невозможно загрузить данные"
        }
    }
    
    private func cleanBasket() {
        if let uID = userId {
            basketFabric.clearBasketFrom(userId: uID) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(_):
                    self.loadBasket()
                case .failure(_):
                    DispatchQueue.main.async {
                        self.showErrorMessage(message: "Не удалось очистить корзину")
                    }
                }
            }
        }
    }
    
    private func removeProductFromBasket(indexPath: IndexPath) {
        if let uID = userId {
            
            let productId = items[indexPath.row].productId
            
            basketFabric.removeProductFromBasketBy(productId: productId, userId: uID) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(_):
                    self.loadBasket()
                case .failure(_):
                    DispatchQueue.main.async {
                        self.showErrorMessage(message: "Не удалось удалить товар из корзины")
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func btnPayClicked(_ sender: Any) {
        if let uID = userId,
           let amount = basket?.amount {
            
            basketFabric.payOrderBy(userId: uID, paySumm: amount) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case let .success(payResult):
                    DispatchQueue.main.async {
                        self.showErrorMessage(message: payResult.userMessage ?? "Заказ оплачен", title: "Успех")
                    }
                    self.cleanBasket()
                case .failure(_):
                    DispatchQueue.main.async {
                        self.showErrorMessage(message: "Ошибка оплаты заказа")
                    }
                }
            }
        }
    }
    
    @IBAction func btnClean(_ sender: Any) {
        cleanBasket()
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        login(delegate: self)
    }
    
}

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblBasket.dequeueReusableCell(withIdentifier: "basketCell") as? BasketCell else {
            assertionFailure("Can't dequeue reusable cell withIdentifier: basketCell")
            return UITableViewCell()
        }
        
        cell.configureWith(items[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let actionProvider: UIContextMenuActionProvider = { _ in
            return UIMenu(children: [
                UIAction(title: "Удалить", image: UIImage(systemName: "trash")) { _ in
                    self.removeProductFromBasket(indexPath: indexPath)
                }
            ])
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteButton = UIContextualAction(style: .destructive, title: "Удалить") { _,_,_   in
            self.removeProductFromBasket(indexPath: indexPath)
        }
        
        deleteButton.backgroundColor = .blue
        let configuration = UISwipeActionsConfiguration(actions: [deleteButton])
        configuration.performsFirstActionWithFullSwipe = true
        configuration.accessibilityActivate()
        
        return configuration
    }
}

extension BasketViewController: NeedLoginDelegate {
    func willReloadData() {
        self.loadBasket()
    }
    
    func willDisappear(bool: Bool) {
        toggleBasketInterface(hide: bool)
        lblBasketIsEmpty.isHidden = !bool
    }
    
}
