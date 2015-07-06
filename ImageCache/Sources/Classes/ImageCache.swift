//
//  ImageCache.swift
//  ImageCache
//
//  Created by Julian Grosshauser on 27/06/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import DiskCache

/**
Caches images in memory and on disk
*/
public class ImageCache {

    //MARK: Properties

    private let memoryCache = NSCache()
    private let diskCache: DiskCache

    /**
    Images will be cached at this path, e.g. `Library/Caches/com.domain.App.ImageCache`
    */
    public let diskCachePath: String

    //MARK: Initialization

    public init(identifier: String) {
        diskCache = DiskCache(identifier: identifier)
        diskCachePath = diskCache.path

        memoryCache.name = identifier
    }

    public convenience init() {
        self.init(identifier: "ImageCache")
    }

    //MARK: Cache Image

    /**
    Cache image asynchronously
    
    - Parameter image: Image to cache
    - Parameter forKey: Key for image
    - Parameter onDisk: Whether to cache image on disk
    - Parameter completionHandler: Called on main thread after image is cached
    
    - Warning: Doesn't throw when error happens asynchronously. Check `.Success` or `.Failure` in `Result` parameter of `completionHandler` instead.
    */
    public func cacheImage(image: UIImage, forKey key: String, onDisk: Bool, completionHandler: (Result<Void> -> Void)?) throws {
        guard let imageData = UIImagePNGRepresentation(image) else {
            throw ImageCacheError.ImageDataError
        }

        if key.isEmpty {
            throw ImageCacheError.EmptyKey
        }

        memoryCache.setObject(image, forKey: key, cost: imageData.length)

        if onDisk {
            do {
                try diskCache.cacheData(imageData, forKey: key, completionHandler: completionHandler)
            } catch {
                throw error
            }
        } else {
            completionHandler?(.Success())
        }
    }
}
