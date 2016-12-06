//
//  detailViewController.swift
//  WEEK3
//
//  Created by Yuchen Zhou on 9/20/16.
//  Copyright © 2016 Duke University. All rights reserved.
//
//  This is the controller of Detail View

import UIKit
import CoreBluetooth

class detailViewController: UIViewController, SecondViewControllerDelegate, jsySecondViewControllerDelegate, CBPeripheralManagerDelegate {
    var item: Item!
    var number: Int!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var netID: UILabel!
    @IBOutlet weak var personalInfo: UILabel!
    @IBOutlet weak var detailText: UITextView!
    
    @IBOutlet weak var advertisingSwitch: UISwitch!
    @IBOutlet weak var advertisingProgress: UIProgressView!
    
    var peripheralManager:CBPeripheralManager!
    var transferCharacteristic:CBMutableCharacteristic!
    var dataToSend:Data!
    var sentDataCount:Int = 0
    var sentEOM:Bool = false
    var progress: Float = 0.0
    
    var router = UserAPI()
    
    @IBOutlet weak var responseLabel: UILabel!
    @IBAction func deleteButton(_ sender: Any) {
        router.delete(dbName: router.database, collectionName: router.collection, operation: .equalTo, field: "netID", value: netID.text!, completion: { (data, response, error) in
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
                self.responseLabel.text = "Delete record successfully\n"
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetailInfo()
        personalInfo.textAlignment = NSTextAlignment(rawValue: 0)!
        personalInfo.lineBreakMode = NSLineBreakMode(rawValue: 0)!
        personalInfo.numberOfLines = 0
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.peripheralManager.stopAdvertising()
        super.viewWillDisappear(animated)
    }
    
    // load information from selected item passing from groupView
    func loadDetailInfo() {
        
        imageView.image = item.image
        name.text = item.name
        netID.text = item.netID
        personalInfo.text = "This is \(item.name) from team \(item.team)."
        detailText.text = "Greetings!\n"
        let gender = item.gender ? "male" : "female"
        detailText.text.append("My name is \(item.name), a \(gender) student from \(item.city). ")
        detailText.text.append("I'm \(item.height) tall. ")
        switch item.status {
        case .bs:
            detailText.text.append("I'm currently an undergraduate student. ")
        case .ms:
            detailText.text.append("I'm currently a graduate student, pursuing M.S Degree. ")
        case .meng:
            detailText.text.append("I'm currently a graduate student, pursuing Meng Degree. ")
        case .phD:
            detailText.text.append("I'm currently a PhD student. ")
        default:
            break
        }
        detailText.text.append("I program with \(item.languages[0]), \(item.languages[1]) and \(item.languages[2]). ")
        detailText.text.append("I like to \(item.hobbies[0]) and \(item.hobbies[1]).")
    }
    
    // Prepare for edit current person's info
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditInfo" {
            let dest:addViewController = segue.destination as! addViewController
            dest.item = item
            dest.number = number
        }
    }
    
    // Present Animation of SecondViewController
    @IBAction func doPresent(_ sender:AnyObject?) {
        switch item.netID {
        case "yz333":
            let svc = SecondViewController(nibName: "SecondViewController", bundle: nil)
            //svc.data = "flip from detail page to animation" as AnyObject?
            svc.delegate = self
            
            let which = 4
            switch which {
                //case 1: break // showing that .CoverVertical is the default
                //case 2: svc.modalTransitionStyle = .CoverVertical
                //case 3: svc.modalTransitionStyle = .CrossDissolve
                case 4: svc.modalTransitionStyle = .partialCurl
                    self.view.window!.backgroundColor = UIColor.white
                //case 5: svc.modalTransitionStyle = .FlipHorizontal
            //self.view.window!.backgroundColor = UIColor.greenColor()
            default: break
            }
            
            self.present(svc, animated:true, completion:nil)
        case "jz173":
            let svc = AnimationViewController(nibName: "AnimationViewController", bundle: nil)
            //svc.data = "flip from detail page to animation" as AnyObject?
            //svc.delegate = self
            
            let which = 4
            switch which {
                //case 1: break // showing that .CoverVertical is the default
                //case 2: svc.modalTransitionStyle = .CoverVertical
            //case 3: svc.modalTransitionStyle = .CrossDissolve
            case 4: svc.modalTransitionStyle = .partialCurl
            self.view.window!.backgroundColor = UIColor.white
                //case 5: svc.modalTransitionStyle = .FlipHorizontal
            //self.view.window!.backgroundColor = UIColor.greenColor()
            default: break
            }
            
            let which2 = 1
            switch which2 {
            case 1: break // showing that .FullScreen is the default
                //case 2: svc.modalPresentationStyle = .FullScreen
                //case 3: svc.modalPresentationStyle = .PageSheet
                //case 4: svc.modalPresentationStyle = .FormSheet
                //case 5: svc.modalPresentationStyle = .OverFullScreen
            //svc.view.alpha = 0.5 // just to prove that it's working
            default: break
            }
            
            self.present(svc, animated:true, completion:nil)
            
        case "jy175":
            let svc = jsySecondViewController(nibName: "jsySecondView", bundle: nil)
            svc.delegate = self
            
            svc.modalTransitionStyle = .partialCurl
            self.view.window!.backgroundColor = UIColor.white
            
            self.present(svc, animated:true, completion:nil)

        default:
            break
        }
    }
    
    // show data passed back
    func acceptData(_ data:AnyObject!) {
        //print(data)
    }
    
    @IBAction func switchChanged(_ sender: AnyObject) {
        if (self.advertisingSwitch.isOn) {
            let dataToBeAdvertised: [String:Any]? = [
                CBAdvertisementDataServiceUUIDsKey : serviceUUIDs]
            self.peripheralManager.startAdvertising(dataToBeAdvertised)
            //    self.peripheralManager.startAdvertising(<#T##advertisementData: [String : Any]?##[String : Any]?#>)
        }
        else {
            self.peripheralManager.stopAdvertising()
        }
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if (peripheral.state != CBManagerState.poweredOn) {
            return
        }
        else {
            print("Powered on and ready to go")
            // This is an example of a Notify Characteristic for a Readable value
            transferCharacteristic = CBMutableCharacteristic(type:
                characteristicUUID, properties: CBCharacteristicProperties.notify, value: nil, permissions: CBAttributePermissions.readable)
            // This sets up the Service we will use, loads the Characteristic and then adds the Service to the Manager so we can start advertising
            let transferService = CBMutableService(type: serviceUUID, primary: true)
            transferService.characteristics = [self.transferCharacteristic]
            self.peripheralManager.add(transferService)
            
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Data request connection coming in")
        // A subscriber was found, so send them the data
        // self.dataToSend = self.textView.text.data(using: String.Encoding.utf8, allowLossyConversion: false)
        // need to serialize the dictionary.
        var imageStr = ""
        
        let imageData = UIImageJPEGRepresentation(item.image, 0.0)
        imageStr = imageData!.base64EncodedString()//imageData!.base64EncodedString(options: .lineLength64Characters)
        
        let dic = ["name": item.name, "team": item.team, "from": item.city, "sex": item.gender, "degree": item.status.description(), "hobbies": item.hobbies, "languages": item.languages, "pic": imageStr] as [String : Any]
        do {
            self.dataToSend = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        } catch {
            print(error.localizedDescription)
        }
        self.sentDataCount = 0
        self.sendData()
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("Unsubscribed")
    }
    
    func sendData() {
        if (sentEOM) {                // sending the end of message indicator
            advertisingProgress.setProgress(1.0, animated: true)
            let didSend:Bool = self.peripheralManager.updateValue(endOfMessage!, for: self.transferCharacteristic, onSubscribedCentrals: nil)
            
            if (didSend) {
                sentEOM = false
                print("Sent: EOM, Outer loop")
            }
            else {
                return
            }
        }
        else {                          // sending the payload
            if (progress == 1.0) {
                progress = 0.0
            } else {
                progress += 0.001
            }
            advertisingProgress.setProgress(progress, animated: true)
            
            if (self.sentDataCount >= self.dataToSend.count) {
                return
            }
            else {
                var didSend:Bool = true
                while (didSend) {
                    var amountToSend = self.dataToSend.count - self.sentDataCount
                    if (amountToSend > MTU) {
                        amountToSend = MTU
                    }
                    
                    let range = Range(uncheckedBounds: (lower: self.sentDataCount, upper: self.sentDataCount+amountToSend))
                    var buffer = [UInt8](repeating: 0, count: amountToSend)
                    
                    self.dataToSend.copyBytes(to: &buffer, from: range)
                    let sendBuffer = Data(bytes: &buffer, count: amountToSend)
                    
                    didSend = self.peripheralManager.updateValue(sendBuffer, for: self.transferCharacteristic, onSubscribedCentrals: nil)
                    if (!didSend) {
                        return
                    }
                    if let printOutput = NSString(data: sendBuffer, encoding: String.Encoding.utf8.rawValue) {
                        print("Sent: \(printOutput)")
                    }
                    self.sentDataCount += amountToSend
                    if (self.sentDataCount >= self.dataToSend.count) {
                        sentEOM = true
                        let eomSent:Bool = self.peripheralManager.updateValue(endOfMessage!, for: self.transferCharacteristic, onSubscribedCentrals: nil)
                        if (eomSent) {
                            sentEOM = false
                            print("Sent: EOM, Inner loop")
                        }
                        return
                    }
                }
            }
        }
    }
    
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        self.sendData()
    }
 }
