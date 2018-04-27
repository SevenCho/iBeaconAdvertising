//
//  ViewController.swift
//  iBeaconAdvertisingDemo
//
//  Created by 曹雪松 on 2018/4/26.
//  Copyright © 2018 曹雪松. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class ViewController: UIViewController
{
    @IBOutlet weak var stateLbl: UILabel!
    
    let beaconUUID = "B0702880-A295-A8AB-F734-031A98A512DE"
    private var beaconMajorValue: CLBeaconMajorValue?
    private var beaconMinorValue: CLBeaconMinorValue?
    let beaconIdentity = "kitty"
    
    private var peripheraManager: CBPeripheralManager?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // defult value
        beaconMajorValue = UInt16(2)
        beaconMinorValue = UInt16(7)
        
        peripheraManager = CBPeripheralManager(delegate: self, queue: .main)
    }
}

extension ViewController: CBPeripheralManagerDelegate
{
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {

        switch peripheral.state {
        case .unknown:
            print("蓝牙未知的")
        case .resetting:
            print("蓝牙重置中")
        case .unsupported:
            print("蓝牙不支持")
        case .unauthorized:
            print("蓝牙未验证")
        case .poweredOff:
            print("蓝牙未启动")
        case .poweredOn:
            print("蓝牙可用")
            beaconAdvertising()
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("正在模拟Beacon广播数据: \(peripheral.isAdvertising) --- 错误信息: \(String(error?.localizedDescription ?? "无"))")
        stateLbl.text = "正在模拟Beacon广播数据: \n\(peripheral.isAdvertising) \n错误信息: \n\(String(error?.localizedDescription ?? "无"))"
        stateLbl.textAlignment = .center
    }
    
    func beaconAdvertising() {
        
        guard let uuid = UUID(uuidString: beaconUUID) else {
            return
        }
        let region = CLBeaconRegion(proximityUUID: uuid, major: beaconMajorValue!, minor: beaconMinorValue!, identifier: beaconIdentity)
        let regionData = region.peripheralData(withMeasuredPower: nil)
        let regionAdvertising = regionData as? [String : Any]
        peripheraManager?.startAdvertising(regionAdvertising)
        print("开始模拟Beacon广播数据\(regionData)")
    }
}

