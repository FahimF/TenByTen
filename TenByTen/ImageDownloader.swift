//
//  ImageDownloader.swift
//  TenByTen
//
//  Created by Fahim Farook on 10/10/15.
//  Copyright © 2015 RookSoft Ltd. All rights reserved.
//

import UIKit

class ImageDownloader:NSOperation {
	var request:NSURLRequest!
	var completed:((image:UIImage?)->Void)?
	
	override func main() {
		if self.cancelled || request == nil {
			return
		}
		let sess = NSURLSession.sharedSession()
		let task = sess.dataTaskWithRequest(request, completionHandler: {(data, resp, err) in
			let img = UIImage(data:data!)
			self.done(img)
		})
		task.resume()
	}
	
	private func done(image:UIImage?) {
		if self.completed != nil {
			self.completed!(image:image)
		}
	}
}
