//
//  MapView.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/12/24.
//

import SwiftUI
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = nil
    }
}

class CustomAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        didSet {
            guard let customAnnotation = annotation as? CustomAnnotation else { return }
            canShowCallout = true
            if let image = UIImage(named: "map") {
                self.image = image
            } else {
                self.image = nil
            }
            
            centerOffset = CGPoint(x: 0, y: -32)
        }
    }
}

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            // 사용자 정의 애너테이션을 확인합니다.
            if let customAnnotation = annotation as? CustomAnnotation {
                let view = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomAnnotation") as? CustomAnnotationView
                ?? CustomAnnotationView(annotation: customAnnotation, reuseIdentifier: "CustomAnnotation")
                view.annotation = customAnnotation
                return view
            }
            
            return nil
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CustomAnnotation")
        
        let annotation = CustomAnnotation(coordinate: coordinate, title: "위치")
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4))
        mapView.setRegion(region, animated: true)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
}
