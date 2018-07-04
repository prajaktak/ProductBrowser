//
//  ViewController.swift
//  ProductBrowser
//
//  Created by Prajakta Kulkarni on 27/06/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import UIKit
import CoreData

class ProductListingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var productsTableView: UITableView!
    lazy var fetchedhResultController: NSFetchedResultsController<Product> = {
        let fetchRequest = NSFetchRequest<Product>(entityName: "Product")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        //fetchRequest.predicate = NSPredicate(format: "remainingItems >= 0")
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CoreDataManager.sharedInstance.managedObjectContext,
                                             sectionNameKeyPath: nil, cacheName: nil)
        // frc.delegate = self
        return frc
    }()
    func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map {CoreDataManager.sharedInstance.createPhotoEntityFrom(dictionary: $0)}
        do {
            try CoreDataManager.sharedInstance.managedObjectContext.save()
        } catch let error {
            print(error)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromWebservice()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func getDataFromWebservice() {
        // swiftlint:disable line_length
        WebserviceManager().getData(form: "https://gist.githubusercontent.com/anonymous/a3b3e50413fff111505a/raw/0522419f508e7ea506a8856586dce11a5664e9df/products.json") { (result) in
            switch result {
            case .success(let jsonObject):
                CoreDataManager.sharedInstance.clearData()
                self.saveInCoreDataWith(array: jsonObject)
                self.productsTableView.reloadData()
                print("Success")
            case .failure:
                print("Failure")
            }
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - TableView delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast line_length
        let productCell: ProductListTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductListTableViewCell
        // swiftlint:enable force_cast line_length
        productCell.imageView?.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        let product = fetchedhResultController.object(at: indexPath)
        productCell.productTitleLabel.text = product.name
        return productCell
    }

}
