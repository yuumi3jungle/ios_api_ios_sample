//
//  ToDo.swift
//  Todo
//
//  Created by Yuumi Yoshida on 2015/07/10.
//  Copyright (c) 2015年 Yuumi Yoshida. All rights reserved.
//

import UIKit

class Todo: NSObject {
    var task = ""
    var due = NSDate()
    
    func dueMMDD() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.stringFromDate(self.due)
    }
    
    override var description : String {
        get {
            return "*Todo* \(dueMMDD()) : \(task)";
        }
    }
}
