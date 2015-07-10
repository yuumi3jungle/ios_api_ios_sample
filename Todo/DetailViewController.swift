//
//  DetailViewController.swift
//  Todo
//
//  Created by Yuumi Yoshida on 2015/07/10.
//  Copyright (c) 2015年 Yuumi Yoshida. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var taskText: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!

    var todo: Todo?
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let t = self.todo {
            taskText!.text = t.task
            dueDatePicker!.date = t.due
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.todo?.task = taskText!.text
        self.todo?.due  = dueDatePicker!.date
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

