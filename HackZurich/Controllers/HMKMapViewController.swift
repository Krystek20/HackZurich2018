import UIKit
import MapKit
import Alamofire
import UberRides
import SnapKit

class HMKMapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapInfoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    var uberButton: UIButton!
    var annotation: MKAnnotation?

    
    let locationManager = CLLocationManager()
    var items = [HMKMapItemResponseModel]()
    var me: MKPointAnnotation!
    
    var locValue: CLLocationCoordinate2D!
    var shouldBeFetch = true
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapInfoView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mapInfoView.layer.shadowRadius = 10
        mapInfoView.layer.shadowOpacity = 0.1
    
        mapView.delegate = self
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.locValue = locValue
        
        if shouldBeFetch {
            shouldBeFetch = false
            fetchData()
        }
    }
    
    private func fetchData() {
        Alamofire.request("https://2be030bd.ngrok.io/pharmacies?lat=\(self.locValue.latitude)&long=\(self.locValue.longitude)", method: .get, parameters: nil, encoding: Alamofire.JSONEncoding.default, headers: nil).responseJSON { response in
            
            if let json = response.result.value as? [[String : Any]] {
                self.items = HMKMapItemsResponseBuilder(array: json).build()?.results ?? []
                self.prepareMap()
            }
        }
    }
    
    private func prepareMap() {
        me = MKPointAnnotation()
        me.title = "Me"
        me.coordinate = self.locValue
        mapView.addAnnotation(me)
        
        for mapItem in items {
            let pharmancy = HMKPharmacy(title: mapItem.name, locationName: "", coordinate: CLLocationCoordinate2D(latitude: mapItem.lat, longitude: mapItem.lng))
            mapView.addAnnotation(pharmancy)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    @IBAction func closeModal(_ sender: Any) {
        bottomConstraint.constant = self.mapInfoView.bounds.height
        view.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
        
        self.mapView.removeOverlays(self.mapView.overlays)
        self.mapView.deselectAnnotation(annotation, animated: true)
    }
    
    @IBAction func exitAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension HMKMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation as? MKPointAnnotation != nil {
            return
        }
        
        annotation = view.annotation
        
        if bottomConstraint.constant != 0 {
            bottomConstraint.constant = 0
            view.setNeedsUpdateConstraints()
            
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        self.titleLabel.text = view.annotation?.title ?? ""
        self.mapView.removeOverlays(self.mapView.overlays)
        
        mapView.showAnnotations([me, view.annotation!], animated: true)

        let sourceMapItem = MKMapItem(placemark: MKPlacemark(coordinate: locValue))
        let destinationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: view.annotation!.coordinate))

        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking
        let directions = MKDirections(request: directionRequest)
        directions.calculate { response, error in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }

            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
        }
        
        let builder = RideParametersBuilder()
        let pickupLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        let dropoffLocation = CLLocation(latitude: view.annotation!.coordinate.latitude, longitude: view.annotation!.coordinate.longitude)
        builder.pickupLocation = pickupLocation
        builder.dropoffLocation = dropoffLocation
        let rideParameters = builder.build()
        
        if uberButton != nil {
            uberButton.removeFromSuperview()
            uberButton = nil
        }
        
        uberButton = RideRequestButton(rideParameters: rideParameters)
        mapInfoView.addSubview(uberButton)
        uberButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(mapInfoView.snp.left).offset(10)
            make.right.equalTo(mapInfoView.snp.right).offset(-10)
        }
        mapInfoView.addSubview(uberButton)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.regular
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
}
