//
//  MapVC.swift
//  GoodEats
//
//  Created by William Yeung on 2/10/21.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    // MARK: - Properties
    var restaurant: Restaurant?
    
    // MARK: - Views
    private lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.delegate = self
        mv.showsTraffic = true
        mv.showsScale = true
        mv.showsCompass = true
        return mv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
        addAnnotation()
    }
    
    // MARK: - UI
    func layoutViews() {
        view.addSubview(mapView)
        mapView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
    }
    
    // MARK: - Helper
    func addAnnotation() {
        guard let restaurant = restaurant else { return }
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(restaurant.location) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                
                let annotation = MKPointAnnotation()
                annotation.title = restaurant.name
                annotation.subtitle = restaurant.type
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
}

// MARK: - MapView Delegate
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation .isKind(of: MKUserLocation.self) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MyMarker") as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        }
        
        annotationView?.glyphText = "😋"
        annotationView?.markerTintColor = UIColor.orange
        
        return annotationView
    }
}
