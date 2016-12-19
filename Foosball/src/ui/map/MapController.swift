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
        navigationItem.leftBarButtonItem = UITools.createBarBtnItem(self, action: #selector(ScanViewController.onBack), image: "go_back")
    }

    func onBack() {
        let _ = navigationController?.popViewController(animated: true)
    }

    override func initData() {
        map = MAMapView(frame: baseView.bounds)
        baseView.addSubview(map)
        map.delegate = self

        map.isShowsUserLocation = true
        map.userTrackingMode = .follow

        map.setZoomLevel(16, animated: false)
        map.setCenter(curLoc!.loc!.coordinate, animated: false)

        let mapFlag = UIImageView(image: UIImage(named: "map_flag"))
        baseView.addSubview(mapFlag)
        mapFlag.center = map.center
    }

    // MAMapViewDelegate ---------------------------------------------
    
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        print(mapView.centerCoordinate)
    }
}
