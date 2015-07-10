//
//  MasterViewController.swift
//  Todo
//
//  Created by Yuumi Yoshida on 2015/07/10.
//  Copyright (c) 2015年 Yuumi Yoshida. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var todos = [Todo]()
    var lastUpdateIndexPath: NSIndexPath? = nil


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewTodo:")
        self.navigationItem.rightBarButtonItem = addButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewTodo(sender: AnyObject) {
        todos.insert(Todo(), atIndex: todos.count)

        let indexPath = NSIndexPath(forRow: todos.count - 1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
        performSegueWithIdentifier("showDetail", sender: nil)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                lastUpdateIndexPath = indexPath
                (segue.destinationViewController as! DetailViewController).todo = todos[indexPath.row]
            }
        }
    }
    
    @IBAction func updateTodos(segue: UIStoryboardSegue) {
        let controller = segue.sourceViewController as! DetailViewController
        if let index = lastUpdateIndexPath, todo = controller.todo {
            todos[index.row] = todo
            tableView.reloadRowsAtIndexPaths([index], withRowAnimation: .None)
        }
    }


    // MARK: - Table View

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let todo = todos[indexPath.row]
        cell.textLabel!.text = todo.dueMMDD()
        cell.detailTextLabel!.text = todo.task
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            todos.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }


}

