//
//  DistanceFilterView + LocationManager.swift
//  GlobalHoneys
//
//  Created by inforex_imac on 2023/10/19.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//


import CoreLocation
import UIKit

// MARK: - Location (distance)
extension DistanceFilterView: CLLocationManagerDelegate {
    
    func searchDistance() {
        log.d("auth: \(locationManager.authorizationStatus)")
        
        switch locationManager.authorizationStatus {
        case .notDetermined, .denied, .restricted:
            showLocationRequestPopup()
            
        case .authorizedAlways, .authorizedWhenInUse:
            requestSearch()
        }
    }
    
    /// 위치정보를 아직 동의 안한 경우 Where Are you? popup Show
    func showLocationRequestPopup() {
        let action = {
            if self.locationManager.authorizationStatus == .denied {
                self.showSettingLocationPopup()
            } else {
                self.locationManager.requestWhenInUseAuthorization()
                
                DispatchQueue.global().async {
                    if CLLocationManager.locationServicesEnabled() {
                        self.locationManager.startUpdatingLocation()
                    } else {
                        log.d("위치값을 거부함")
                    }
                }
            }
        }
        
        let model = PopupInfoModel(type: .simple,
                                   buttonType: .two,
                                   titleText: "",
                                   contentsText: "",
                                   confirmBtnText: "Enable location".localized(),
                                   confirmAction: action
        )
        
        let popup = PopupView(frame: .zero, model: model)
        let locationEnableView = LocationEnableView()
        
        popup.addCustomView(customView: locationEnableView)
        
        App._CHANNEL_SERVICE._addAlert(popup: popup, on: .tabbarController)
    }
    
    /// 위치정보 거절한 경우 popup
    func showSettingLocationPopup() {
        let popup = PopupView(frame: .zero, model: PopupInfoModel_Authorization.location.model)
        App._CHANNEL_SERVICE._addAlert(popup: popup, on: .tabbarController)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            break
        default:
            log.e("위치 권한 없음")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log.e("error: \(error.localizedDescription)")
    }
}
