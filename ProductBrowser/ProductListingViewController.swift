//
//  ViewController.swift
//  ProductBrowser
//
//  Created by Prajakta Kulkarni on 27/06/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import UIKit

class ProductListingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    @IBOutlet weak var productsTableView: UITableView!
    var productsArray:NSArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - TableView delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productsArray != nil {
            return productsArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productCell:ProductListTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductListTableViewCell
        productCell.imageView?.image = UIImage(named: "")
        productCell.productTitleLabel.text =  "productTitle"
        return productCell
    }



}

