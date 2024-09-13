//
//  MapView.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/12/24.
//

import SwiftUI
import MapKit

// CustomAnnotation을 클래스로 정의
class CustomAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    var subtitle: String? // MKAnnotation 프로토콜의 요구사항
    
    init(coordinate: CLLocationCoordinate2D, title: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = nil
    }
}

class CustomAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue as? CustomAnnotation else { return }
            canShowCallout = true
            image = UIImage(named: "map")
            centerOffset = CGPoint(x: 0, y: -32)
        }
    }
}

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D
    var zoomLevel: Double = 0.4 // 지도의 확대 레벨 설정 (작을수록 더 확대됨)
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let customAnnotation = annotation as? CustomAnnotation {
                let view = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomAnnotation") as? CustomAnnotationView ?? CustomAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotation")
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
        
        // 초기화 시 주석 추가
        let annotation = CustomAnnotation(coordinate: coordinate, title: "위치")
        mapView.addAnnotation(annotation)
        
        // 줌 레벨 설정
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel)
        )
        mapView.setRegion(region, animated: true)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // 위치 업데이트는 Coordinator에서 처리
    }
}
