//
//  ViewController.swift
//  TenByTen
//
//  Created by Fahim Farook on 10/10/15.
//  Copyright © 2015 RookSoft Ltd. All rights reserved.
//

import UIKit

class ViewController:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
	@IBOutlet private weak var collection:UICollectionView!
	private var data = [String]()
	private let fmt = NSDateFormatter()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	// MARK:- Private Methods
	private func loadData() {
		// Get current date & time in correct format. URL: http://tenbyten.org/Data/global/2004/11/05/09/
		fmt.dateFormat = "YYYY/MM/dd/HH/"
		fmt.timeZone = NSTimeZone(name:"EST")
//		let baseURL = "http://tenbyten.org/Data/global/" + fmt.stringFromDate(NSDate())
		let baseURL = "https://tenbyten.org/Data/global/Now/"
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			// Code
			let path = baseURL + "words.txt"
			if let url = NSURL(string:path) {
				let req = NSURLRequest(URL:url)
				let sess = NSURLSession.sharedSession()
				let task = sess.dataTaskWithRequest(req, completionHandler: {(buf, resp, err) in
					if let txt = NSString(data:buf!, encoding:NSUTF8StringEncoding) {
						let data = txt.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
						if data.count > 0 {
							// Get images
						}
					}
				})
				task.resume()
			}
		}
	}
	
	// MARK:- UICollectionView Delegates
	func collectionView(cv:UICollectionView, numberOfItemsInSection section:Int) -> Int {
		return data.count
	}
	
	func collectionView(cv:UICollectionView, cellForItemAtIndexPath indexPath:NSIndexPath) -> UICollectionViewCell {
		let cell = cv.dequeueReusableCellWithReuseIdentifier("ImageView", forIndexPath:indexPath)
		
		return cell
	}
}

