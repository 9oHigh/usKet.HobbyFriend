//
//  HomeTabViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/23.
//

import UIKit
import MapKit

final class HomeViewController: BaseViewController {
    
    let homeView = HomeView()

    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.delegate = self
        return manager
    }()
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLocation(UserDefaults.standard.string(forKey: "startLocation") ?? "")
        setConfigure()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    override func setConfigure() {
        
        // mapView
        homeView.mapView.mapType = .standard
        homeView.mapView.showsUserLocation = true
        homeView.mapView.setUserTrackingMode(.follow, animated: true)
        
    }
    
    override func bind() {
        
    }
    
    private func isAllowedLocation() -> Bool {
        
        switch locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            Helper.shared.registerUserData(userDataType: .locationAuth, variable: "notAllowed")
            
            return false
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            Helper.shared.registerUserData(userDataType: .locationAuth, variable: "allowed")
            return true
        @unknown default:
            return false
        }
    }
    
    private func setLocation(_ positon: String) {
        
        switch positon {
        case "campus":
            campusStart()
        case "current":
            self.homeView.mapView.showsUserLocation = true
            currentStart()
        default :
            campusStart()
        }
    }
    
    // 임시
    private func campusStart() {
        self.homeView.mapView.setRegion(MKCoordinateRegion(center: .init(latitude: 37.517819364682694, longitude: 126.88647317074734), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
    }
    
    // 임시
    private func currentStart() {
        self.homeView.mapView.setRegion(MKCoordinateRegion(center: self.locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
    }
    
    // 위치권한이 설정되어있지 않다면 영등포 캠퍼스로 위치 초기화
    // 자신의 위치찾기 클릭시 권한 설정이 되어있지 않다면 ALert를 띄우고
    // 설정창의 url 생성한 뒤 설정화면으로 이동시키기
    
    // guard let url = URL(string: UIApplication.openSettingURLString) else { return }
    // 열 수 있는 url 이라면, 이동
    // if UIApplication.shared.canOpenURL(url) {
    //      UIApplication.shared.opne(url)
    // }
    
}
extension HomeViewController: CLLocationManagerDelegate {
 
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .authorizedAlways, .authorizedWhenInUse:
            Helper.shared.registerUserData(userDataType: .locationAuth, variable: "allowed")
            Helper.shared.registerUserData(userDataType: .startLocation, variable: "current")
        case .restricted, .notDetermined:
            Helper.shared.registerUserData(userDataType: .locationAuth, variable: "notAllowed")
            Helper.shared.registerUserData(userDataType: .startLocation, variable: "campus")
            DispatchQueue.main.async {
                self.locationManager.requestWhenInUseAuthorization()
            }
        case .denied:
            Helper.shared.registerUserData(userDataType: .locationAuth, variable: "notAllowed")
            Helper.shared.registerUserData(userDataType: .startLocation, variable: "campus")
            DispatchQueue.main.async {
                self.locationManager.requestWhenInUseAuthorization()
            }
        default:
            break
        }
    }
}

// extension HomeViewController: MKMapViewDelegate {
//    // 어노테이션을 찍는 함수
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard !annotation.isKind(of: MKUserLocation.self) else { //
//            return nil
//        }
//        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Custom")
//
//        if annotationView == nil { // 없으면 하나 만들어 주시고
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Custom")
//            annotationView?.canShowCallout = true
//            // callOutView를 통해서 추가적인 액션을 더해줄수도 있겠죠! 와 무지 간편합니다!
//            let miniButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//            miniButton.setImage(UIImage(systemName: "person"), for: .normal)
//            miniButton.tintColor = .blue
//            annotationView?.rightCalloutAccessoryView = miniButton
//
//        } else { // 있으면 등록된 걸 쓰시면 됩니다.
//                annotationView?.annotation = annotation
//
//        }
//        annotationView?.image = UIImage(named: "Circle") // 상황에 따라 다른 annotationView를 리턴하게 하면 여러가지 모양을 쓸 수도 있겠죠?
//        return annotationView
//
//    }
// }
