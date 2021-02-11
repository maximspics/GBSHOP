//
//  BasketCell.swift
//  GBShop
//
//  Created by Maxim Safronov on 28.12.2020.
//

import UIKit

class BasketCell: UITableViewCell {
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    override func prepareForReuse() {
        lblTotalPrice.text = nil
        lblQuantity.text = nil
        lblPrice.text = nil
        lblProductName.text = nil
    }
    
    func configureWith(_ product: BasketItems) {
        lblProductName.text = product.productName
        lblPrice.text = String(product.productPrice) + " руб."
        lblQuantity.text = String(product.quantity) + " шт."
        lblTotalPrice.text = "Итого: " + String(product.productPrice * product.quantity) + " руб."
    }

}
