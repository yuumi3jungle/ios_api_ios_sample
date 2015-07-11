//
//  ToDo.swift
//  Todo
//
//  Created by Yuumi Yoshida on 2015/07/10.
//  Copyright (c) 2015年 Yuumi Yoshida. All rights reserved.
//

import UIKit

private let SERVER_URL = "http://localhost:3000/todos"

class Todo: NSObject {
    private let dateFormatter = NSDateFormatter()
    var task: String
    var due: NSDate
    var id: Int
    
    override init() {
        task = ""
        due = NSDate()
        id = 0
    }

    init(json: AnyObject) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.due = dateFormatter.dateFromString(json["due"] as! String) ?? NSDate()
        self.task = json["task"] as! String
        self.id = json["id"] as! Int
    }

    func dueMMDD() -> String {
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.stringFromDate(self.due)
    }

    func dueToString() -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.stringFromDate(self.due)
    }

    override var description : String {
        get {
            return "*Todo* \(id) \(dueMMDD()) : \(task)";
        }
    }
    
    
    class func getAllServerData(completion: ([Todo]) -> Void) {
        let request = NSURLRequest(URL: NSURL(string: SERVER_URL + ".json")!)

        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {response, data, error in
                let jsonArray =  NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments,
                    error: nil) as! NSArray
                println("--- got json \(jsonArray)")
                
                var todos = (jsonArray as [AnyObject]).map {jsonTodo -> Todo in Todo(json: jsonTodo)}
                println(todos)
                completion(todos)
        })
    }
    
    func updateServerData(completion: () -> Void) {
        let dict = ["id": self.id, "due": dueToString(), "task": self.task]
        
        let request = NSMutableURLRequest(URL: NSURL(string: self.id == 0 ?
            SERVER_URL + ".json" : SERVER_URL + "/" + String(self.id) + ".json")!)
        request.HTTPMethod = self.id == 0 ? "POST" : "PUT"
        request.setValue(" application/json", forHTTPHeaderField: "Content-type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(dict as NSDictionary, options: nil, error: nil)
        println("--- send json \(dataToString(request.HTTPBody!))")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {response, data, error in
                println(self.dataToString(data))
                completion()
        })
    }
    
    func deleteServerData(completion: () -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: SERVER_URL + "/" + String(self.id) + ".json")!)
        request.HTTPMethod = "DELETE"

        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {response, data, error in
                println(self.dataToString(data))
                completion()
        })
    }
    
    private func dataToString(data: NSData) -> String {
        return (NSString(data: data, encoding:NSUTF8StringEncoding) ?? "") as String
    }
}
