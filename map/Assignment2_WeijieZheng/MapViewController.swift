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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, RouteViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var currLocation: CLLocation?
    
    var haveRoute: Bool = false
    var fromLocation: String = ""
    var toLocation: String = ""
    var routeList: [MKRoute] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.mapView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
        
        mapView.showsCompass = false
        let compassButton = MKCompassButton(mapView: mapView)
        compassButton.compassVisibility = .visible
        mapView.addSubview(compassButton)
        compassButton.translatesAutoresizingMaskIntoConstraints = false
        compassButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -12).isActive = true
        compassButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 12).isActive = true
        
        mapView.showsScale = false
        let scaleView = MKScaleView(mapView: mapView)
        scaleView.scaleVisibility = .visible
        mapView.addSubview(scaleView)
        
        let userTracker = MKUserTrackingButton(mapView: mapView)
        mapView.addSubview(userTracker)
        userTracker.translatesAutoresizingMaskIntoConstraints = false
        userTracker.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -10).isActive = true
        userTracker.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 48).isActive = true
        
    }
    
    func locationManager(_ manager:CLLocationManager,didUpdateLocations locations:[CLLocation])
    {
        //check if first time
        if let location = locations.last
        {
            if currLocation == nil
            {
                //first time，set region
                let center = location.coordinate
                let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
                self.mapView.setRegion(region, animated: true)
                
            }
            //constantly remember user location
            currLocation = location
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if haveRoute == false{
            if segue.identifier == "segueRoute"
            {
                if let vc = segue.destination as? RouteViewController
                {
                    vc.currLocation = self.currLocation
                    vc.delegate = self
                }
            }
        }else{
            if segue.identifier == "segueRoute"
            {
                if let vc = segue.destination as? RouteViewController
                {
                    if fromLocation == ""{
                        vc.currLocation = self.currLocation
                        vc.toLocationStr = self.toLocation
                        vc.routeList = self.routeList
                        vc.delegate = self
                    }else{
                        vc.currLocation = self.currLocation
                        vc.fromLocationStr = self.fromLocation
                        vc.toLocationStr = self.toLocation
                        vc.routeList = self.routeList
                        vc.delegate = self
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView:MKMapView, rendererFor overlay:MKOverlay) -> MKOverlayRenderer
    {
        // if overlay is polyline, return MKPolylineRenderer
        if let polyline = overlay as? MKPolyline
        {
            let renderer = MKPolylineRenderer(polyline:polyline)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer(overlay:overlay)
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
    
    func addAnnotation(address: String)
    {
        let annotation = MKPointAnnotation()
        
        forwardGeocoding(address: address, completion: {(location) in
            if let annotationLocation = location {
                
                annotation.coordinate = annotationLocation.coordinate
                
            }
        })
        
        annotation.title = address
        
        mapView.addAnnotation(annotation)
    }
    
    func routeViewDidFinish(sender: RouteViewController, data: MKRoute) {
        
        haveRoute = true
        fromLocation = sender.fromLocation.text ?? ""
        toLocation = sender.toLocation.text ?? ""
        routeList = sender.routeList
        
        self.mapView.removeAnnotations(mapView.annotations)
        addAnnotation(address: sender.toLocation.text ?? "")
        
        if sender.fromLocation.text != (""){
            addAnnotation(address: sender.fromLocation.text ?? "")
        }
        self.mapView.removeOverlays(mapView.overlays)
        self.mapView.addOverlay(data.polyline, level:MKOverlayLevel.aboveRoads)
        self.mapView.setVisibleMapRect(data.polyline.boundingMapRect, animated:true)
    }
    
    @IBAction func changeMapMode(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            break;
        }
    }
}
