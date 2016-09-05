//
//  MapViewController.swift
//  productMenu
//
//  Created by 徐常璿 on 2016/8/25.
//  Copyright © 2016年 Eric Hsu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController , MKMapViewDelegate {

    @IBOutlet var mapView:MKMapView!
    
    var items:Menu?
    
    var itemLocation:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = true
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(items!.location) { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            if let placemarks = placemarks{
                let placemark = placemarks[0]
                
                let annotaion = MKPointAnnotation()
                annotaion.title = self.items?.store
                annotaion.subtitle = self.items?.location
                
                if let location = placemark.location {
                    annotaion.coordinate = location.coordinate
                    
                    self.mapView.showAnnotations([annotaion], animated: true)
//                    self.mapView.selectedAnnotations(annotaion)
                }
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKindOfClass(MKUserLocation){
            return nil
        }
        
        
        var annotaionView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        
        if annotaionView == nil {
            annotaionView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotaionView?.canShowCallout = true
        }
        
    
    
    let leftIconView = UIImageView(frame: CGRectMake(0, 0, 53, 53))
//        leftIconView.image = UIImage(named: "pasta1")
        let imgURL = NSURL(string:(items?.itemImage)!)
        if let imageData = NSData(contentsOfURL: imgURL!) {
            leftIconView.image = UIImage(data: imageData)
        }

        annotaionView?.leftCalloutAccessoryView = leftIconView
        
        return annotaionView
    
    }
}