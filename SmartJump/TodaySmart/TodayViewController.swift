//
//  TodayViewController.swift
//  TodaySmart
//
//  Created by Boris Chirino on 07/10/2017.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var stations : Array<Station> = []
    
    
    //MARK: view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //enable show more - show less
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: widget behaviour
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        
        WebService.neareststations(params: ["latitude":23.4,"longitude":44]) { (response, error) in
            guard error == nil else {
                completionHandler(NCUpdateResult.failed)
                return
            }
            
            // parse response and fill array to display tableview cells
            response?.forEach({ (item) in
                if let i = item["info"] as? Dictionary<String, Any> {
                    let info = Info(name: "uno", address:i["address"] as! String)

                    let st = Station(la: Double(item["latitude"] as! Double),
                                     lo: Double(item["longitude"] as! Double),
                                      d: Double(item["distance"] as! Double),
                                      t: item["mean"] as! String,
                                      i: info)

                    self.stations.append(st)
                }
            })
            print("finished import")
            self.tableView.reloadData()
            completionHandler(NCUpdateResult.newData)
        }
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
    }
    
    
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        switch activeDisplayMode {
        case .compact:
            UIView.animate(withDuration: 0.25, animations: {
                self.preferredContentSize = CGSize(width: 320, height: 90)
            })
        case .expanded:
            UIView.animate(withDuration: 0.25, animations: {
                self.preferredContentSize = CGSize(width: 320, height: 200)
            })
        }
        
    }
    
    
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //NSKeyedArchiver.setClassName("Station", for: Station.self)
        let p = NSKeyedArchiver.archivedData(withRootObject: self.stations[indexPath.row])
        if let mysharedDefault = UserDefaults(suiteName: "group.com.bcf.DigitalOcean-Toolbox") {
            mysharedDefault.set(p, forKey: "station")
            print("Wrote object")
        }

    }
    
    //MARK:UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")
        
        //station
        let station = self.stations[indexPath.row]
        cell?.textLabel?.text = station.info.address
        cell?.detailTextLabel?.text = "Distancia : \(station.dis)"
        
        //put image according to station type
        switch station.type {
        case "bus":
            cell?.imageView?.image = #imageLiteral(resourceName: "bus")
        case "bike":
            cell?.imageView?.image = #imageLiteral(resourceName: "bike")
        default:()
        }
        
        return cell!
    }
    
}
