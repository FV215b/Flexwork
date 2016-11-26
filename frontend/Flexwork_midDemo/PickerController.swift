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
    
    let all_status = ["=", "<", "<=", ">", ">=", "!="]
    var status = Comparison.equalTo
    
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
            status = .equalTo
        }
        else if row == 1 {
            status = .lessThan
        }
        else if row == 2 {
            status = .lessThanOrEqualTo
        }
        else if row == 3{
            status = .greaterThan
        }
        else if row == 4 {
            status = .greaterThanOrEqualTo
        }
        else {
            status = .notEqualTo
        }
    }
    
    func getValue() -> Comparison {
        return status
    }
    
    func setValue(_ status: Comparison) {
        self.status = status
    }
}
