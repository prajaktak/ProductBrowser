//
//  ViewController.swift
//  ProductBrowser
//
//  Created by Prajakta Kulkarni on 27/06/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import UIKit

class ProductListingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var numberOfProductsLabel: UILabel!
    var updateTime: NSDate = NSDate()
    var productsArray: [Product] = [Product]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initiateProductArray()
        updateLocalData()
    }
    func updateLocalData() {
         // swiftlint:disable line_length
        WebserviceManager().getData(form: "https://gist.githubusercontent.com/anonymous/a3b3e50413fff111505a/raw/0522419f508e7ea506a8856586dce11a5664e9df/products.json") { (result) in
            switch result {
            case .success(let jsonObject):
                CoreDataManager.sharedInstance.clearData()
                CoreDataManager.sharedInstance.saveInCoreDataWith(array: jsonObject)
                self.updateTime =  NSDate()
                self.initiateProductArray()
                self.productsTableView.reloadData()
                Timer.scheduledTimer(withTimeInterval: 300, repeats: false, block: { (_) in
                    self.updateLocalData()
                })
                print("Success")
            case .failure:
                print("Failure")
            }
        }
    }
    func initiateProductArray() {
        do {
            self.productsArray = try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(Product.fetchRequest()) as [Product]
        } catch {
            print("can not fetch data for product")
        }
        numberOfProductsLabel.text =  "Number of Products:\(productsArray.count)"
        lastUpdatedLabel.text = "Last updated at: \(updateTime.description)"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - TableView delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast line_length
        let productCell: ProductListTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductListTableViewCell
        // swiftlint:enable force_cast line_length
        productCell.setProductCell(product: productsArray[indexPath.row])
        return productCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: Bundle.main)
        // swiftlint:disable line_length
        let productInfoVC = storyboard.instantiateViewController(withIdentifier: "productInfoVC") as? ProductInformationViewController
        // swiftlint:enable line_length
        productInfoVC?.product = productsArray[indexPath.row]
        // swiftlint:disable force_cast
        let currentCell: ProductListTableViewCell = tableView.cellForRow(at: indexPath) as! ProductListTableViewCell
        // swiftlint:enable force_cast
        let currentCellFrame: CGRect = currentCell.frame
        let cellImgViewFrame: CGRect = currentCell.productImageView.frame
        let cellLabelFrame: CGRect = currentCell.productTitleLabel.frame
        productInfoVC?.cellImageFrame = CGRect(x: cellImgViewFrame.origin.x,
                                               y: currentCellFrame.origin.y + cellLabelFrame.origin.y ,
                                               width: cellImgViewFrame.width,
                                               height: cellImgViewFrame.height)
        productInfoVC?.cellLabelFrame = CGRect(x: cellLabelFrame.origin.x,
                                               y: currentCellFrame.origin.y + cellLabelFrame.origin.y,
                                               width: cellLabelFrame.width,
                                               height: cellLabelFrame.height)
        self.navigationController?.pushViewController(productInfoVC!, animated: true)
    }

}
