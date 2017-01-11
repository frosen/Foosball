//
//  MapController.swift
//  Foosball
//
//  Created by luleyan on 2016/12/16.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class MapController: BaseController, MAMapViewDelegate {

    private var map: MAMapView! = nil

    private var curLoc: Location
    private var callback: ((Location) -> Bool)? = nil // 获取当前中心位置的回调

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(rootVC: RootViewController, l: Location, call: ((Location) -> Bool)? = nil) {
        curLoc = l
        callback = call
        super.init(rootVC: rootVC)
    }

    override func viewDidLoad() {
        navTabType = .HideTab
        initDataOnViewAppear = true
        super.viewDidLoad()
        print("挑战页面")

        //标题
        title = "地图"

        navigationItem.leftBarButtonItem = UITools.createBarBtnItem(self, action: #selector(MapController.onBack), image: #imageLiteral(resourceName: "go_back"))
        if callback != nil {
            let item = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(MapController.onConfirm))
            item.tintColor = UIColor.white
            navigationItem.rightBarButtonItem = item
        }
    }

    func onBack() {
        let _ = navigationController?.popViewController(animated: true)
    }

    func onConfirm() {
        if callback!(curLoc) == true {
            let _ = navigationController?.popViewController(animated: true)
        }
    }

    override func initData() {
        map = MAMapView(frame: baseView.bounds)
        baseView.addSubview(map)
        map.delegate = self

        map.isShowsUserLocation = true
        map.userTrackingMode = .follow

        map.setZoomLevel(16, animated: false)

        if curLoc.isLocValid() {
            map.setCenter(curLoc.loc.coordinate, animated: false)
        } else {
            let userLoc = map.userLocation.coordinate
            curLoc.loc = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)
        }

        let mapFlag = UIImageView(image: #imageLiteral(resourceName: "map_flag"))
        baseView.addSubview(mapFlag)
        mapFlag.center = map.center
    }

    // MAMapViewDelegate ---------------------------------------------
    
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        let loc = mapView.centerCoordinate
        print("mapView move", loc)
        curLoc.loc = CLLocation(latitude: loc.latitude, longitude: loc.longitude)
    }
}
