//
//  ImageCacheTests.swift
//  ImageCacheTests
//
//  Created by Julian Grosshauser on 26/06/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import XCTest
import ImageCache

class ImageCacheTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    func testDiskCachePathGetsCorrectlySet() {
        let identifier = "TestImageCache"
        let imageCache = ImageCache(identifier: identifier)

        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        let cachePath = paths.first!
        let diskCachePath: String

        if let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier {
            diskCachePath = cachePath.stringByAppendingPathComponent("\(bundleIdentifier).\(identifier)")
        } else {
            diskCachePath = cachePath.stringByAppendingPathComponent("DiskCache.\(identifier)")
        }

        XCTAssertEqual(diskCachePath, imageCache.diskCachePath, "diskCachePath wasn't correctly set")
    }
}
