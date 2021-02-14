//
//  RestaurantDetailMapCell.swift
//  GoodEats
//
//  Created by William Yeung on 2/10/21.
//

import UIKit
import MapKit

class RestaurantDetailMapCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "RestaurantDetailMapCell"
    
    var restaurant: Restaurant? {
        didSet {
            guard let restaurant = restaurant else { return }
            addAnnotationTo(location: restaurant.location ?? "")
        }
    }
    
    // MARK: - Views
    private let mapView: MKMapView = {
        let mv = MKMapView()
        return mv
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func layoutViews() {
        addSubview(mapView)
        mapView.anchor(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor)
        mapView.setDimension(hConst: 215)
    }
    
    // MARK: - Helpers
    func addAnnotationTo(location: String) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                let annotation = MKPointAnnotation()
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                    self.mapView.setRegion(region, animated: false)
                }
            }
        }
    }
}
