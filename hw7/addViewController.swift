//
//  addViewController.swift
//  WEEK3
//
//  Created by Yuchen Zhou on 9/20/16.
//  Copyright © 2016 Duke University. All rights reserved.
//
//  This is the controller of Edit View

import UIKit
import CoreBluetooth

class addViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CBCentralManagerDelegate, CBPeripheralDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var teamField: UITextField!
    @IBOutlet weak var netIDField: UITextField!
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var heightSlide: UISlider!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var languagesField_1: UITextField!
    @IBOutlet weak var languagesField_2: UITextField!
    @IBOutlet weak var languagesField_3: UITextField!
    @IBOutlet weak var hobbiesField_1: UITextField!
    @IBOutlet weak var hobbiesField_2: UITextField!
    @IBOutlet weak var bluetoothSwitch: UISwitch!
    
    @IBOutlet weak var connectingBLEButton: UIButton!
    @IBOutlet weak var receivingProgressBar: UIProgressView!
    var centralManager:CBCentralManager!
    var connectingPeripheral:CBPeripheral!
    var data:String = ""
    var progress: Float = 0.0
    
    var statusPicker: UIPickerView!
    let statusViewController = StatusPickerController()
    
    var item: Item!
    var number: Int?  // Optional number decides which person's info is being edited or it's a new adding(nil)
    var y: CGFloat = 0 // How many pixels the view should move up when keyboard pops up
    
    var router = UserAPI()
    @IBOutlet weak var responseLabel: UILabel!
    @IBAction func addButton(_ sender: Any) {
        if let name = nameField.text, let netID = netIDField.text, let team = teamField.text, let city = cityField.text, let lang1 = languagesField_1.text, let lang2 = languagesField_2.text, let lang3 = languagesField_3.text, let hobb1 = hobbiesField_1.text, let hobb2 = hobbiesField_2.text, name != "", netID != "", team != "", city != "", lang1 != "", lang2 != "", lang3 != "", hobb1 != "", hobb2 != "" {
            var item = [String:Any]()
            item["name"] = name
            item["netID"] = netID
            item["team"] = team
            item["city"] = city
            item["gender"] = (genderLabel.text == "Male") ? true : false
            item["height"] = heightLabel.text!
            item["languages"] = [lang1, lang2, lang3]
            item["hobbies"] = [hobb1, hobb2]
            item["degree"] = statusViewController.getValue().description()
            router.post(dbName: router.database, collectionName: router.collection, item: item, completion: { (data, response, error) in
                guard error == nil else {
                    DispatchQueue.main.async {
                        self.responseLabel.text = error!.localizedDescription
                    }
                    return
                }
                guard let _ = data else {
                    DispatchQueue.main.async {
                        self.responseLabel.text = "Error: did not receive data\n"
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.responseLabel.text = "Add record successfully\n"
                }
            })
        }
        else {
            DispatchQueue.main.async {
                self.responseLabel.text = "Missing some information\n"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add event handlers for view rising-up or falling-down when keyboard pops up
        cityField.addTarget(self, action: #selector(addViewController.viewRaiseUp(_:)), for: .editingDidBegin)
        cityField.addTarget(self, action: #selector(addViewController.viewFallDown(_:)), for: .editingDidEnd)
        languagesField_1.addTarget(self, action: #selector(addViewController.viewRaiseUp(_:)), for: .editingDidBegin)
        languagesField_1.addTarget(self, action: #selector(addViewController.viewFallDown(_:)), for: .editingDidEnd)
        languagesField_2.addTarget(self, action: #selector(addViewController.viewRaiseUp(_:)), for: .editingDidBegin)
        languagesField_2.addTarget(self, action: #selector(addViewController.viewFallDown(_:)), for: .editingDidEnd)
        languagesField_3.addTarget(self, action: #selector(addViewController.viewRaiseUp(_:)), for: .editingDidBegin)
        languagesField_3.addTarget(self, action: #selector(addViewController.viewFallDown(_:)), for: .editingDidEnd)
        hobbiesField_1.addTarget(self, action: #selector(addViewController.viewRaiseUp(_:)), for: .editingDidBegin)
        hobbiesField_1.addTarget(self, action: #selector(addViewController.viewFallDown(_:)), for: .editingDidEnd)
        hobbiesField_2.addTarget(self, action: #selector(addViewController.viewRaiseUp(_:)), for: .editingDidBegin)
        hobbiesField_2.addTarget(self, action: #selector(addViewController.viewFallDown(_:)), for: .editingDidEnd)
        genderSwitch.addTarget(self, action: #selector(addViewController.switched(_:)), for: .touchUpInside)
        heightSlide.addTarget(self, action: #selector(addViewController.slided(_:)), for: .valueChanged)
        
        // Set degree picker
        statusPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 70, height: 80))
        statusPicker.center = CGPoint(x: 105, y: 325)
        statusPicker.delegate = statusViewController
        statusPicker.dataSource = statusViewController
        self.addChildViewController(statusViewController)
        self.view.addSubview(statusPicker)
        
        // IF number is not nil, load info from passing-in item
        if let _:Int = number {
            loadDetailInfo()
        }
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.centralManager.stopScan()
        print("scanning stopped")
        super.viewWillDisappear(animated)
    }
    
    func loadDetailInfo() {
        imageView.image = item.image
        nameField.text = item.name
        teamField.text = item.team
        netIDField.text = item.netID
        if item.gender == true {
            genderSwitch.isOn = true
            genderLabel.text = "Male"
        }
        else {
            genderSwitch.isOn = false
            genderLabel.text = "Female"
        }
        heightLabel.text = item.height
        cityField.text = item.city
        let count_1 = item.languages.count
        if count_1 >= 1 {
            languagesField_1.text = item.languages[0]
            if count_1 >= 2 {
                languagesField_2.text = item.languages[1]
                if count_1 >= 3 {
                    languagesField_3.text = item.languages[2]
                }
            }
        }
        let count_2 = item.languages.count
        if count_2 >= 1 {
            hobbiesField_1.text = item.hobbies[0]
            if count_2 >= 2 {
                hobbiesField_2.text = item.hobbies[1]
            }
        }
        let status = item.status
        if status == .bs {
            statusPicker.selectRow(1, inComponent: 0, animated: true)
        }
        else if status == .ms {
            statusPicker.selectRow(2, inComponent: 0, animated: true)
        }
        else if status == .meng  {
            statusPicker.selectRow(3, inComponent: 0, animated: true)
        }
        else if status == .phD {
            statusPicker.selectRow(4, inComponent: 0, animated: true)
        }
        else {
            statusPicker.selectRow(0, inComponent: 0, animated: true)
        }
        statusViewController.setValue(item.status)
    }
    
    // For view rising up
    func viewRaiseUp(_ sender: UITextField!) {
        if y == 0 {
            y = 130
            self.view.bounds.origin.y += y
            self.view.layoutIfNeeded()
        }
    }
    
    // For view dropping down
    func viewFallDown(_ sender: UITextField!) {
        if y == 130 {
            self.view.bounds.origin.y -= y
            self.view.layoutIfNeeded()
            y = 0
        }
    }
    
    // Switch handler
    func switched(_ sender: UISwitch!) {
        if sender.isOn {
            genderLabel.text = "Male"
        }
        else {
            genderLabel.text = "Female"
        }
    }
    
    // Slider handler
    func slided(_ sender: UISlider) {
        heightLabel.text = "\((Int)((sender.value * 150 + 100)/30.48))"
        heightLabel.text?.append("\'")
        heightLabel.text?.append("\((Int)(((sender.value * 150 + 100).truncatingRemainder(dividingBy: 30.48))/2.54))")
        heightLabel.text?.append("\"")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let name = nameField.text, let netID = netIDField.text, let team = teamField.text, let city = cityField.text, let lang1 = languagesField_1.text, let lang2 = languagesField_2.text, let lang3 = languagesField_3.text, let hobb1 = hobbiesField_1.text, let hobb2 = hobbiesField_2.text {
            if name != "" && netID != "" && team != "" && city != "" && lang1 != "" && lang2 != "" && lang3 != "" && hobb1 != "" && hobb2 != "" {
                let gender = (genderLabel.text == "Male") ? true : false
                item = Item(image: imageView.image!, name: name, netID: netID, gender: gender, team: team, height: heightLabel.text!, city: city, status: statusViewController.getValue(), languages: [lang1, lang2, lang3], hobbies: [hobb1, hobb2])
            }
                // Pop up an 2s' alert
            else {
                let alert = UIAlertController(title: "Warning", message: "Missing some information", preferredStyle: .alert)
                present(alert, animated: true, completion: {(action) -> Void in sleep(2)})
            }
        }
        else {
            let alert = UIAlertController(title: "Warning", message: "Missing some information", preferredStyle: .alert)
            present(alert, animated: true, completion: {(action) -> Void in sleep(2)})
        }
    }
    
    // Finish picking images
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    // Pop up image-resource selector, initialize camera or album
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        let title: String = "Edit Photo"
        let message: String = ""
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancel)
        let take = UIAlertAction(title: "Take Photo", style: .default, handler: {(action) -> Void in imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            self.present(imagePicker, animated: true, completion: nil)})
        ac.addAction(take)
        let choose = UIAlertAction(title: "Choose from Album", style: .default, handler:{(action) -> Void in
            imagePicker.sourceType = .savedPhotosAlbum
            self.present(imagePicker, animated: true, completion: nil)})
        ac.addAction(choose)
        present(ac, animated: true, completion: nil)
    }
    
    // Resign first responder by tapping background
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func receiveDataFromBluetooth(_ sender: AnyObject) {
        print("checking state")
        switch(centralManager.state) {
        case .poweredOff:
            print("CB BLE hw is powered off")
            
        case .poweredOn:
            print("CB BLE hw is powered on")
            self.scan()
            
        default:
            return
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }
    
    func scan() {
        self.centralManager.scanForPeripherals(withServices: serviceUUIDs,options: nil)
        print("scanning started\n\n\n")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if RSSI.intValue > -15 {
            return
        }
        print("discovered \(peripheral.name) at \(RSSI)")
        if connectingPeripheral != peripheral {
            connectingPeripheral = peripheral
            connectingPeripheral.delegate = self
            print("connecting to peripheral \(peripheral)")
            centralManager.connect(connectingPeripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("failed to connect to \(peripheral) due to error \(error)")
        self.cleanup()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("\n\nperipheral connected\n\n")
        centralManager.stopScan()
        peripheral.delegate = self as CBPeripheralDelegate
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            print("error discovering services \(error)")
            self.cleanup()
        }
        else {
            for service in peripheral.services! as [CBService] {
                print("service UUID  \(service.uuid)\n")
                if (service.uuid == serviceUUID) {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil {
            print("error - \(error)")
            print(error!)
            self.cleanup()
        }
        else {
            for characteristic in service.characteristics! as [CBCharacteristic] {
                print("characteristic is \(characteristic)\n")
                if (characteristic.uuid == characteristicUUID) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("error")
        }
        else {
            let dataString = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue)
            
            if dataString == "EOM" {
                receivingProgressBar.setProgress(1.0, animated: true)
                print(self.data)
                //textView.text = self.data
                // display the received data in the corresponding field
                peripheral.setNotifyValue(false, for: characteristic)
                centralManager.cancelPeripheralConnection(peripheral)
                if let dict = convertStringToDictionary(text: self.data) {
                    print("\(dict["name"] as! String)")
                    print("\(dict["team"] as! String)")
                    print("\(dict["from"] as! String)")
                    print("\(dict["sex"] as! Bool)")
                    print("\(dict["degree"] as! String)")
                    print("\(dict["hobbies"] as! [String])")
                    print("\(dict["languages"] as! [String])")
                    
                    nameField.text = dict["name"] as? String
                    teamField.text = dict["team"] as? String
                    cityField.text = dict["from"] as? String
                    //genderSwitch.isOn = gender
                    if let _ = (dict["sex"] as? Bool) {
                        genderSwitch.isOn = true
                        genderLabel.text = "Male"
                    }
                    else {
                        genderSwitch.isOn = false
                        genderLabel.text = "Female"
                    }
                    if let degree = (dict["degree"] as? String) {
                        if degree == "B.S" {
                            statusPicker.selectRow(1, inComponent: 0, animated: true)
                        }
                        else if degree == "M.S" {
                            statusPicker.selectRow(2, inComponent: 0, animated: true)
                        }
                        else if degree == "Meng"  {
                            statusPicker.selectRow(3, inComponent: 0, animated: true)
                        }
                        else if degree == "PhD" {
                            statusPicker.selectRow(4, inComponent: 0, animated: true)
                        }
                        else {
                            statusPicker.selectRow(0, inComponent: 0, animated: true)
                        }
                    }
                    if let languagesArr = (dict["languages"] as? [String]) {
                        let count_3 = languagesArr.count
                        if count_3 >= 1 {
                            languagesField_1.text = languagesArr[0]
                            if count_3 >= 2 {
                                languagesField_2.text = languagesArr[1]
                                if count_3 >= 3 {
                                    languagesField_3.text = languagesArr[2]
                                }
                            }
                        }
                    }
                    if let hobbiesArr = (dict["hobbies"] as? [String]) {
                        let count_4 = hobbiesArr.count
                        if count_4 >= 1 {
                            hobbiesField_1.text = hobbiesArr[0]
                            if count_4 >= 2 {
                                hobbiesField_2.text = hobbiesArr[1]
                            }
                        }
                    }
                    if let decodedImageData = NSData(base64Encoded: dict["pic"] as! String) {
                        let decodedImage = UIImage(data: decodedImageData as Data)
                        imageView.image = decodedImage! as UIImage
                    }
                }
            }
            else {
                if progress == 1.0 {
                    progress = 0.0
                } else {
                    progress += 0.001
                }
                receivingProgressBar.setProgress(progress, animated: true)
                let strng:String = dataString as! String
                self.data += strng
                print("received \(dataString)")
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("error changing notification state \(error)")
        }
        if (characteristic.uuid != serviceUUID) {
            return
        }
        if (characteristic.isNotifying) {
            print("notification began on \(characteristic)")
        }
        else {
            print("notification stopped on \(characteristic). Disconnecting")
            self.centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnect error is \(error)")
    }
    
    func cleanup() {
        
        switch connectingPeripheral.state {
        case .disconnected:
            print("cleanup called, .Disconnected")
            return
        case .connected:
            if (connectingPeripheral.services != nil) {
                print("found")
                //add any additional cleanup code here
            }
        default:
            return
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}
