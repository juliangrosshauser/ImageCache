//
//  ImageCacheTests.swift
//  ImageCacheTests
//
//  Created by Julian Grosshauser on 26/06/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import XCTest
import ImageCache

let imageCacheIdentifier = "TestImageCache"
let imageCache = ImageCache(identifier: imageCacheIdentifier)

class ImageCacheTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    func testDiskCachePathGetsCorrectlySet() {
        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        let cachePath = paths.first!
        let diskCachePath: String

        if let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier {
            diskCachePath = cachePath.stringByAppendingPathComponent("\(bundleIdentifier).\(imageCacheIdentifier)")
        } else {
            diskCachePath = cachePath.stringByAppendingPathComponent("DiskCache.\(imageCacheIdentifier)")
        }

        XCTAssertEqual(diskCachePath, imageCache.diskCachePath, "diskCachePath wasn't correctly set")
    }
}
