//
//  HomeTabViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/23.
//

import MapKit
import RxSwift
import RxCocoa

enum FriendType: Int {
    case all = 2
    case man = 1
    case woman = 0
}

final class HomeViewController: BaseViewController {
    
    let homeView = HomeView()
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.delegate = self
        return manager
    }()
    
    var friends: [FromQueueDB] = []
    var surroundType = FriendType.all
    
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 초기위치
        homeView.mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationAuth() ? setInitialPosition("current") : setInitialPosition("campus")
        centerLocation(type: surroundType)
        
        setConfigure()
        bind()
        monitorNetwork()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        centerLocation(type: self.surroundType)
        homeView.mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
        monitorNetwork()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    override func setConfigure() {
        
        homeView.mapView.mapType = .standard
        homeView.mapView.register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: AnnotationView.identifier)
        homeView.gpsButton.addTarget(self, action: #selector(findMyLocation), for: .touchUpInside)
    }
    
    override func bind() {
        
        homeView.allButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe({ _ in
                self.centerLocation(type: .all)
                self.surroundType = .all
            })
            .disposed(by: disposeBag)
        
        homeView.manButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe({ _ in
                self.centerLocation(type: .man)
                self.surroundType = .man
            })
            .disposed(by: disposeBag)
        
        homeView.womanButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe({ _ in
                self.centerLocation(type: .woman)
                self.surroundType = .woman
            })
            .disposed(by: disposeBag)
    }
    
    private func setInitialPosition(_ positon: String) {
        print(#function)
        switch positon {
        case "campus":
            campusStart()
        case "current":
            homeView.mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            currentStart()
        default :
            campusStart()
        }
    }
    
    private func locationAuth() -> Bool {
        print(#function)
        switch locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            locationManager.requestWhenInUseAuthorization()
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            return true
            // 맨처음
        @unknown default:
            locationManager.requestWhenInUseAuthorization()
            return false
        }
    }
    
    private func campusStart() {
        let coordinate = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
        let region = MKCoordinateRegion(center: coordinate,
                                        latitudinalMeters: 700,
                                        longitudinalMeters: 700)
        homeView.mapView.setRegion(region, animated: true)
    }
    
    private func currentStart() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location,
                                                 latitudinalMeters: 700,
                                                 longitudinalMeters: 700)
            homeView.mapView.setRegion(region, animated: true)
        }
    }
    
    private func centerLocation(type: FriendType = .all) {
        let lat = homeView.mapView.centerCoordinate.latitude
        let long = homeView.mapView.centerCoordinate.longitude
        let region = computedRegion(lat: lat, long: long)
        
        // 0.8초
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.questSurround(region: region, lat: lat, long: long, by: type)
        }
    }
    
    private func questSurround(region: Int, lat: Double, long: Double, by: FriendType = .all) {
        
        viewModel.questSurround(region: region, lat: lat, long: long) { friends, _, error in
            guard error == nil else {
                self.showToast(message: error!, yPosition: 150)
                return
            }
            
            guard let friends = friends else {
                self.showToast(message: "친구들의 위치 정보를 가지고 오는데 실패했어요.", yPosition: 150)
                return
            }
            
            self.friends = friends.fromQueueDB
            print(self.friends)
            let annotations = self.homeView.mapView.annotations
            self.homeView.mapView.removeAnnotations(annotations)
            
            for friend in self.friends {
                let friendCoordinate = CLLocationCoordinate2D(latitude: friend.lat, longitude: friend.long)
                let friendsAnnotation = MKPointAnnotation()
                
                if friend.gender == by.rawValue && by != .all {
                    friendsAnnotation.coordinate = friendCoordinate
                    self.homeView.mapView.addAnnotation(friendsAnnotation)
                } else if by == .all {
                    friendsAnnotation.coordinate = friendCoordinate
                    self.homeView.mapView.addAnnotation(friendsAnnotation)
                }
            }
        }
    }
    
    private func computedRegion(lat: Double, long: Double) -> Int {
        
        var forward: String = String(90 + lat)
        var backward: String = String(180 + long)
        
        forward = forward.replacingOccurrences(of: ".", with: "")
        backward = backward.replacingOccurrences(of: ".", with: "")
        
        let endIdxForward: String.Index = forward.index(forward.startIndex, offsetBy: 4)
        let endIdxBackward: String.Index = forward.index(backward.startIndex, offsetBy: 4)
        
        forward = String(forward[...endIdxForward])
        backward = String(backward[...endIdxBackward])
        
        return Int(forward + backward)!
    }
    
    @objc
    private func findMyLocation() {

        if CLLocationManager.locationServicesEnabled() && locationAuth() {
            if let location = locationManager.location?.coordinate {
                homeView.mapView.setRegion(.init(center: location, latitudinalMeters: 700, longitudinalMeters: 700), animated: true)
            }
        } else {
            let alertView = self.generateAlertView(inform: "위치 권한 설정", subInform: "위치권한이 설정되어있지 않아요.\n설정으로 이동하시겠습니까?")
            
            alertView.cancelButton.rx.tap
                .observe(on: MainScheduler.instance)
                .subscribe({ _ in
                    alertView.dismiss(animated: true, completion: nil)
                })
                .disposed(by: disposeBag)
            alertView.okButton.rx.tap
                .observe(on: MainScheduler.instance)
                .subscribe({ _ in
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                    alertView.dismiss(animated: true, completion: nil)
                })
                .disposed(by: disposeBag)
            self.transViewController(nextType: .present, controller: alertView)
        }
    }
}
extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .authorizedAlways, .authorizedWhenInUse:
            homeView.mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .restricted, .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            locationManager.requestWhenInUseAuthorization()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension HomeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = homeView.mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationView.identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: AnnotationView.identifier)
            annotationView?.canShowCallout = false
            annotationView?.contentMode = .scaleAspectFit
        } else {
            annotationView?.annotation = annotation
        }
        //이미지 분기처리 고민..
        //호출 때마다 변경
        annotationView?.image = R.image.sesac_face_1()!
        
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        centerLocation(type: self.surroundType)
    }
}
