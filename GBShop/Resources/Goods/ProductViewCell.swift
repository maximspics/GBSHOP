//
//  ProductViewCell.swift
//  GBShop
//
//  Created by Maxim Safronov on 28.12.2020.
//

import UIKit
import Kingfisher

class ProductViewCell: UITableViewCell {
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductDescription: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var btnAddToCart: UIButton!
    
    override func prepareForReuse() {
        imgProduct.image = nil
        lblProductName.text = nil
        lblProductPrice.text = nil
        lblProductDescription.text = nil
    }
    
    func configureWith(product: ProductResult) {
        if !product.image.isEmpty,
            let imageUrl = URL(string: product.image) {
            imgProduct.kf.setImage(with: imageUrl)
        }
        
        lblProductName.text = product.name
        lblProductDescription.text = product.description
        lblProductPrice.text = String(product.price) + " RUB"
    }
    
    @IBAction func btnAddToCartClicked(_ sender: Any) {
        
    }
}
