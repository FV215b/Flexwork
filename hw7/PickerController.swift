//
//  PickerController.swift
//  Veggie_Info
//
//  Created by Jiasheng Yang on 10/16/16.
//  Copyright © 2016 Yuchen Zhou. All rights reserved.
//
//  PickerController for degree selection in edit view

import Foundation
import UIKit

class StatusPickerController: UIViewController,
UIPickerViewDelegate, UIPickerViewDataSource {
    
    let all_status = ["Other", "B.S", "M.S", "Meng", "PhD"]
    var status = Status.other
    
    func numberOfComponents(
        in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // how many rows
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return all_status.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int, forComponent component: Int) -> String? {
        return all_status[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            status = .other
        }
        else if row == 1 {
            status = .bs
        }
        else if row == 2 {
            status = .ms
        }
        else if row == 3{
            status = .meng
        }
        else {
            status = .phD
        }
    }
    
    func getValue() -> Status {
        return status
    }
    
    func setValue(_ status: Status) {
        self.status = status
    }
}
