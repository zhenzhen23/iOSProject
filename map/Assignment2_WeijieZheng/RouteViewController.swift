//
//  Description: Assignment 2, Write a simple navigation app that can be run on both iPhone and iPad devices using adaptive design.
//
//  Author: WeijieZheng
//  Email address: weijiezheng23@gmail.com
//  Date: 2019-10-24
//

import UIKit
import MapKit
import CoreLocation

class RouteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var currLocation: CLLocation?
    var routeList: [MKRoute] = []
    
    @IBOutlet weak var routesTable: UITableView!
    @IBOutlet weak var fromLocation: UITextField!
    @IBOutlet weak var toLocation: UITextField!
    
    var delegate:RouteViewDelegate? = nil
    var fromLocationStr: String = ""
    var toLocationStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if fromLocationStr != ""{
            fromLocation.text = fromLocationStr
        }
        
        if toLocationStr != ""{
            toLocation.text = toLocationStr
        }
    }
    
    func forwardGeocoding(address: String, completion: @escaping((CLLocation?) -> Void))
    {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if let error = error
            {
                print(error.localizedDescription)
                completion(nil) // passing null location
            }
            else
            {
                // pass the first location to the closure
                let placemark = placemarks?[0]
                completion(placemark?.location)
            }
        })
    }
    
    func showAlert(msg: String) -> Void{
        
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func searchRoute(_ sender: Any) {
        
        let toAddress = toLocation.text ?? ""
        if toAddress.isEmpty
        {
            showAlert(msg: "Destination is missing")
            return
        }
        
        let fromAddress = fromLocation.text ?? ""
        if fromAddress.isEmpty
        {
            self.forwardGeocoding(address:toAddress, completion: {(location) in
                if let locationTo = location {
                    // found destination, calculate routes
                    self.route(from: self.currLocation ?? CLLocation(latitude: 0, longitude: 0), to: locationTo)
                } else {
                    // not found destination, show alert
                    self.showAlert(msg: "Can not found destination")
                }
            })
        } else {
            forwardGeocoding(address:fromAddress, completion: {(location) in
                if let locationFrom = location
                {
                    // found source, try to find destination next
                    self.forwardGeocoding(address:toAddress, completion: {(location) in
                        if let locationTo = location {
                            // found destination, calculate routes
                            self.route(from: locationFrom, to: locationTo)
                            
                        } else {
                            //not found destination, show alert
                            self.showAlert(msg: "Can not found destination")
                        }
                    })
                } else {
                    // not found the source, show alert
                    self.showAlert(msg: "Can not found source")
                }
            })
        }
    }
    
    func route(from: CLLocation, to: CLLocation)
    {
        // request directions
        let request = MKDirections.Request()
        let fromPlacemark = MKPlacemark(coordinate: from.coordinate)
        let toPlacemark = MKPlacemark(coordinate: to.coordinate)
        
        request.source = MKMapItem(placemark: fromPlacemark)
        request.destination = MKMapItem(placemark: toPlacemark)
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        // calculate directions
        let directions = MKDirections(request: request)
        
        directions.calculate(completionHandler: {(response, error) in
            if let error = error {
                // show alert
                print("[ERROR] " + error.localizedDescription)
                return
            }
            
            self.routeList = response?.routes ?? []
            self.routesTable.reloadData()
            
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "routesCell", for: indexPath)
        let index = indexPath.row
        let timeInStr: String = routeList[index].expectedTravelTime.convertTime(time: Int(routeList[index].expectedTravelTime))
        let info = String(format: "via \(routeList[index].name): %.01fKm, \(timeInStr)", routeList[index].distance/1000)
        
        tableCell.textLabel?.text = info
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.routeViewDidFinish(sender: self, data: routeList[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}

extension TimeInterval {
    
    func convertTime(time: Int) -> String {
        let seconds: Int = time % 60
        let minutes: Int = (time / 60) % 60
        let hours: Int = time / 3600
        let timeInStr = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        
        return timeInStr
    }
}

protocol RouteViewDelegate: AnyObject
{
    func routeViewDidFinish(sender: RouteViewController, data: MKRoute)
}
