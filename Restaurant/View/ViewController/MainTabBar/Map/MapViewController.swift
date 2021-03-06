//
//  MapViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/06.
//

import UIKit
import NMapsMap
import RxSwift

class MapViewController: BaseViewController, Storyboard, ViewModelBindableType {
    static var mapNavigationBarAnimated = false
    var viewModel: MapViewModel!
    weak var coordinator: MapCoordinator?
    var mapView = NMFMapView()
    var locationManager = CLLocationManager()
    var markers: [NMFMarker] = []
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var searchCurrentLocationButton: UIButton!
    @IBOutlet weak var myLocationButton: UIButton!
    @IBOutlet weak var showListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("MapViewController viewDidLoad()")
    }
    
    deinit {
        print("MapViewController Deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: MapViewController.mapNavigationBarAnimated)
        if self.viewModel.isFirstEntry {
            setMapView()
            self.viewModel.isFirstEntry = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        MapViewController.mapNavigationBarAnimated = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        disposeBag = DisposeBag() 
    }
    
    func bindingView() {
        searchCurrentLocationButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.fetchCurrentNearbyRestaurants()
                self?.removeMarkers()
            })
            .disposed(by: disposeBag)

        myLocationButton.rx.tap
            .subscribe(onNext: { [weak self] in self?.moveToMyLocationOnMap() })
            .disposed(by: disposeBag)

        showListButton.rx.tap
            .subscribe(onNext: { [weak self] in self?.pushNearbyRestaurants() })
            .disposed(by: disposeBag)

        viewModel.myNearbyRestaurantsFlag
            .subscribe(onNext: { [weak self] in
                guard let nearbyRestaurants = self?.viewModel.nearbyRestaurants,
                      !nearbyRestaurants.isEmpty else {
                    self?.coordinator?.presentNoRestaurantNearby()
                    return
                }

                self?.setMarkers()
            })
            .disposed(by: disposeBag)

        viewModel.currentNearbyRestaurantsFlag
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }

                if self.viewModel.nearbyRestaurants.isEmpty {
                    ToastMessage.shared.show(str: "??? ???????????? ?????? ????????? ????????? ?????????!")
                } else {
                    self.setMarkers()
                }
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - ?????? ??? ??????
extension MapViewController {
    private func setMapView() {
        locationManager.delegate = self
        getLocationUsagePermission()

        let (fullWidth, fullHeight) = (UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let bottomBarSectionHeight = Common.tabBarHeight + (UIDevice.current.hasNotch ? Common.homeBarHeight : 0)
        let (viewWidth, viewHeight) = (fullWidth, fullHeight - bottomBarSectionHeight)
        let viewCGRect = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        mapView = NMFMapView(frame: viewCGRect)
        mapView.positionMode = .normal
        mapView.addCameraDelegate(delegate: self)
        
        self.mainView.addSubview(mapView)
        self.setMyLocationIcon()
        self.moveToMyLocationOnMap()

        if checkGPSPermission() {
            self.viewModel.fetchMyNearbyRestaurants()
        }
    }

    private func setMarkers() {
        for restaurant in self.viewModel.nearbyRestaurants {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: restaurant.latitude, lng: restaurant.longitude)
            marker.iconImage = NMFOverlayImage(name: "mapMarker")
            marker.width = 51
            marker.height = 56
            marker.mapView = mapView
            self.markers.append(marker)
            
            let handler = { [weak self] (overlay: NMFOverlay) -> Bool in
                self?.coordinator?.restaurantSummaryInformation(restaurant: restaurant)
                
                return true
            }
            marker.touchHandler = handler
        }
    }

    private func removeMarkers() {
        self.markers.forEach { $0.mapView = nil }
        self.markers.removeAll()
    }
    
    private func pushNearbyRestaurants() {
        coordinator?.pushNearbyRestaurants(nearbyRestaurants: viewModel.nearbyRestaurants)
    }

    func setMyLocationIcon() {
        guard let locationCoordinate = locationManager.location?.coordinate else { return }
        self.viewModel.myLatitude = locationCoordinate.latitude
        self.viewModel.myLongitude = locationCoordinate.longitude

        let locationOverlay = mapView.locationOverlay
        locationOverlay.hidden = false
        locationOverlay.location = NMGLatLng(lat: viewModel.myLatitude, lng: viewModel.myLongitude)
    }

    func moveToMyLocationOnMap() {
        guard let locationCoordinate = locationManager.location?.coordinate else { return }
        self.viewModel.myLatitude = locationCoordinate.latitude
        self.viewModel.myLongitude = locationCoordinate.longitude

        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: viewModel.myLatitude, lng: viewModel.myLongitude))
        cameraUpdate.animation = .easeOut
        cameraUpdate.animationDuration = 1
        mapView.moveCamera(cameraUpdate)
    }
}

//MARK: - ????????? ?????? ??????
extension MapViewController: NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        print(mapView.cameraPosition.target.lat)
        print(mapView.cameraPosition.target.lng)
        self.viewModel.latitudeInCenterOfMap = mapView.cameraPosition.target.lat
        self.viewModel.longitudeInCeterOfMap = mapView.cameraPosition.target.lng
    }
}

//MARK: - GPS ?????? ??????
extension MapViewController: CLLocationManagerDelegate {
    private func getLocationUsagePermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS ?????? ?????????")
//            UserDataManager.sharedInstance.isMapAuthorized = true
          
            //setMapView()??? ?????? ??? method??? ?????? ?????? ?????? ???????????? ?????? ???????????? ?????????????????? ?????? ?????? ???????????? ?????? ??? ??? ??????
            self.setMyLocationIcon()
            self.moveToMyLocationOnMap()
            self.viewModel.fetchMyNearbyRestaurants()
        case .restricted, .notDetermined:
            print("GPS ?????? ???????????? ??????")
            getLocationUsagePermission()
        case .denied:
            print("GPS ?????? ?????? ?????????")
            getLocationUsagePermission()
        default:
            print("GPS: Default")
        }
    }

    func checkGPSPermission() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS: ?????? ??????")
            return true
        case .restricted, .notDetermined:
            print("GPS: ?????? ???????????? ??????")
            return false
        case .denied:
            print("GPS: ?????? ??????")
            return false
        default:
            print("GPS: Default")
            return false
        }
    }
}
