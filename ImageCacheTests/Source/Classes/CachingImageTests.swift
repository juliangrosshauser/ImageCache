//
//  CachingImageTests.swift
//  ImageCacheTests
//
//  Created by Julian Grosshauser on 06/07/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import XCTest
import ImageCache
import DiskCache

class CachingImageTests: XCTestCase {

    override func setUp() {
        super.setUp()

        clearAllCachedImages()
    }

    func testCachingImageOnDiskCallsCompletionHandlerWithSuccess() {
        let key = "TestCachingData"
        let image = testImageWithName("Square", fileExtension: .PNG)

        let completionExpectation = expectationWithDescription("completionHandler called")

        let completionHandler: Result<Void> -> Void = { result in
            if case .Failure(let error) = result {
                XCTFail("Caching image failed: \(error)")
            }

            completionExpectation.fulfill()
        }

        do {
            try imageCache.cacheImage(image, forKey: key, onDisk: true, completionHandler: completionHandler)
        } catch {
            XCTFail("Caching image failed: \(error)")
        }

        waitForExpectationsWithTimeout(expectationTimeout, handler: nil)
    }
    
    func testCachingImageOnlyInMemoryCallsCompletionHandlerWithSuccess() {
        let key = "TestCachingData"
        let image = testImageWithName("Square", fileExtension: .PNG)
        
        let completionExpectation = expectationWithDescription("completionHandler called")
        
        let completionHandler: Result<Void> -> Void = { result in
            if case .Failure(let error) = result {
                XCTFail("Caching image failed: \(error)")
            }
            
            completionExpectation.fulfill()
        }
        
        do {
            try imageCache.cacheImage(image, forKey: key, onDisk: false, completionHandler: completionHandler)
        } catch {
            XCTFail("Caching image failed: \(error)")
        }
        
        waitForExpectationsWithTimeout(expectationTimeout, handler: nil)
    }
    
    func testCachingImageOnDiskCreatesFileInDiskCachePath() {
        let key = "TestCachingData"
        let image = testImageWithName("Square", fileExtension: .PNG)
        
        let completionExpectation = expectationWithDescription("completionHandler called")
        
        let completionHandler: Result<Void> -> Void = { result in
            if case .Failure(let error) = result {
                XCTFail("Caching image failed: \(error)")
            }
            
            guard cachedImageExistsOnDiskForKey(key) else {
                XCTFail("File wasn't created in disk cache path")
                
                // the following return statement will never be executed because of the above `XCTFail()`,
                // but the Swift compiler is only happy when the `guard` body isn't falling through
                return
            }
            
            completionExpectation.fulfill()
        }
        
        do {
            try imageCache.cacheImage(image, forKey: key, onDisk: true, completionHandler: completionHandler)
        } catch {
            XCTFail("Caching image failed: \(error)")
        }
        
        waitForExpectationsWithTimeout(expectationTimeout, handler: nil)
    }
}
