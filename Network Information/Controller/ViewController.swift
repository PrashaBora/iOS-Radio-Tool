//
//  ViewController.swift
//  Radio Tool
//
//  Created by Prasha Bora on 6/25/18.
//  Copyright © 2018 Prasha Bora. All rights reserved.
//

import UIKit
import CoreTelephony
import CoreBluetooth
import CoreLocation


class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let networkFactory = CTNetworkInfoFactory()
    var networkInfo: NetworkInfo?
    var statusBarInfo: StatusBarInfo?

    enum Section: Int {
        case NetworkInfo = 0
        case StatusBarInfo = 1
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: UIControlEvents.valueChanged)
         refreshControl.tintColor = .red
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.networkInfo = networkInfo?.locationManager as? NetworkInfo
        self.tableView.refreshControl = refreshControl
        self.networkInfo = networkFactory.fetchNetworkInfo() //calls the fetchNetworkInfo() from the CTNetworkInfoFactory model
        self.networkInfo?.locationUpdateDelegate = self
        self.statusBarInfo = networkFactory.fetchStatusBarInfo()
       
    }
    
    @objc func handleRefresh() {
        print("Refreshing")
        // TODO: actual code to refresh content
       
        self.networkInfo = networkFactory.fetchNetworkInfo() //calls the fetchNetworkInfo() from the CTNetworkInfoFactory model
        self.statusBarInfo = networkFactory.fetchStatusBarInfo()
         self.networkInfo?.locationUpdateDelegate = self
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
}

extension ViewController: LocationUpdateDelegate {
    
    func didUpdateLocation(_ lat: String, _ long: String) {
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        var rowCount: Int = 0
        if section == Section.NetworkInfo.rawValue {
             rowCount = NetworkInfo.Property.list.count
        } else if section == Section.StatusBarInfo.rawValue {
            rowCount = StatusBarInfo.Property.list.count
        }
        return rowCount
    }
    
    //mathod for title
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionName: String
        switch section {
        case 0:
            sectionName = "Network Info"
        case 1:
            sectionName = "General Status Bar Information"
        default:
            sectionName = ""
        }
        return sectionName
    }
    
    
      public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "networkInfoCell", for: indexPath)
        let section = indexPath.section
        switch section {
        case 0:
            if let netwrokInfo = networkInfo {
                
                //  tableView(tableView: "NetworkInformation", numberOfRowsInSection: Section.NetworkInfo.rawValue)
                let propertyName = NetworkInfo.Property.list[indexPath.row]
                let propertyValue = netwrokInfo.value(forKey: propertyName) as? String
                cell.textLabel?.text = propertyName
                cell.detailTextLabel?.text = propertyValue
                //  }
            }
        case 1:
            
            if let statusBarInfo = statusBarInfo {
                let propertyName = StatusBarInfo.Property.list[indexPath.row]
                let propertyValue = statusBarInfo.value(forKey: propertyName) as? String
                cell.textLabel?.text = propertyName
                cell.detailTextLabel?.text = propertyValue
            }
        default :
            break
        }
        
        return cell
        
    }
    
    
}
