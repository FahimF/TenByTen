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
	private let fmt = NSDateFormatter()
	private var urls = [String]()
	private var images = [Int:UIImage]()
	private var index = 0
	private lazy var queue:NSOperationQueue = {
		let q = NSOperationQueue()
		q.name = "Download queue"
		q.maxConcurrentOperationCount = 4
		return q
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	// MARK:- Private Methods
	private func loadData() {
		// Images URL format: http://tenbyten.org/Data/global/2015/10/09/23/refugee.jpg
		let baseURL = "http://tenbyten.org/Data/global/2015/09/22/22/"
		let path = baseURL + "words.txt"
		if let url = NSURL(string:path) {
			let req = NSURLRequest(URL:url)
			let sess = NSURLSession.sharedSession()
			let task = sess.dataTaskWithRequest(req, completionHandler: {(buf, resp, err) in
				if let txt = NSString(data:buf!, encoding:NSUTF8StringEncoding) {
					self.urls = txt.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
					for fl in self.urls {
						let ipath = baseURL + fl + ".jpg"
						if let iurl = NSURL(string:ipath) {
							let op = ImageDownloader()
							op.request = NSURLRequest(URL:iurl)
							op.completed = {(img) in
								self.images[self.index] = img
								let ndx = NSIndexPath(forRow:self.index, inSection:0)
								if let cell = self.collection.cellForItemAtIndexPath(ndx) as? ImageViewCell {
									cell.imgThumb.image = img
								}
								self.index++
							}
							self.queue.addOperation(op)
						}
					}
					dispatch_async(dispatch_get_main_queue()) {
						self.collection.reloadData()
					}
				}
			})
			task.resume()
		}
	}
	
	// MARK:- UICollectionView Delegates
	func collectionView(cv:UICollectionView, numberOfItemsInSection section:Int) -> Int {
		return urls.count
	}
	
	func collectionView(cv:UICollectionView, cellForItemAtIndexPath indexPath:NSIndexPath) -> UICollectionViewCell {
		let cell = cv.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath:indexPath) as! ImageViewCell
		cell.lblTitle.text = urls[indexPath.row]
		if let img = images[indexPath.row] {
			cell.imgThumb.image = img
		}
		return cell
	}
}

