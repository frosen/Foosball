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

    private var curLoc: Location? = nil

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(rootVC: RootViewController, l: Location? = nil) {
        curLoc = l
        super.init(rootVC: rootVC)
    }

    override func viewDidLoad() {
        navTabType = .HideTab
        initDataOnViewAppear = true
        super.viewDidLoad()
        print("挑战页面")

        //标题
        title = "地图"

        navigationItem.hidesBackButton = true
        let item = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(MapController.onConfirm))
        item.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = item
    }

    func onConfirm() {
        let _ = navigationController?.popViewController(animated: true)
    }

    override func initData() {
        map = MAMapView(frame: baseView.bounds)
        baseView.addSubview(map)
        map.delegate = self

        map.isShowsUserLocation = true
        map.userTrackingMode = .follow

        map.setZoomLevel(16, animated: false)

        if let loc2d = curLoc?.loc?.coordinate {
            map.setCenter(loc2d, animated: false)
        }

        let mapFlag = UIImageView(image: UIImage(named: "map_flag"))
        baseView.addSubview(mapFlag)
        mapFlag.center = map.center
    }

    // MAMapViewDelegate ---------------------------------------------
    
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        print(mapView.centerCoordinate)
    }
}
