//
//  GoodsViewController.swift
//  GBShop
//
//  Created by Maxim Safronov on 27.12.2020.
//

import UIKit

class CatalogViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var catalogFactory = RequestFactory().makeGoodsRequestFactory()
    var productList: [ProductResult] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Каталог"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProductViewCell", bundle: nil), forCellReuseIdentifier: "productViewCell")
        
        catalogFactory.getCatalog { response in
            switch response.result {
            case .success(let catalogResult):
                DispatchQueue.main.async {
                    self.productList = catalogResult
                    self.tableView.reloadData()
                }
                
            case .failure(_):
                DispatchQueue.main.async {
                    self.showErrorMessage(message: "Ошибка отображения каталога")
                }
            }
        }
    }
}

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let productVC = AppService.shared.getScreenPage(identifier: "productDetailScreen") as? ProductViewController {
            self.appService.session.setProductInfo(productList[indexPath.row])
            navigationController?.pushViewController(productVC, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productViewCell", for: indexPath) as? ProductViewCell else {
            assertionFailure("Can't dequeue reusable cell withIdentifier: productViewCell")
            return UITableViewCell()
        }
        
        cell.configureWith(product: productList[indexPath.row])
        
        return cell
    }
    
}

