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
            try diskCache.cacheData(imageData, forKey: key, completionHandler: completionHandler)
        } else {
            completionHandler?(.Success())
        }
    }

    //MARK: Retrieve image

    /**
    Retrieve image asynchronously

    - Parameter key: Key for image
    - Parameter completionHandler: Called on main thread with retrieved image or error as parameter
    
    - Note: Retrieves image with scale of device's screen.

    - Warning: Doesn't throw when error happens asynchronously. Check `.Success` or `.Failure` in `Result` parameter of `completionHandler` instead.
    */
    public func retrieveImageForKey(key: String, completionHandler: Result<UIImage> -> Void) throws {
        if key.isEmpty {
            throw ImageCacheError.EmptyKey
        }

        // try to retrieve image from memory cache first
        if let imageData = memoryCache.objectForKey(key) as? NSData, let image = UIImage(data: imageData, scale: UIScreen.mainScreen().scale) {
            completionHandler(.Success(image))
        } else {
            // if image couldn't be retrieved from memory cache, try to retrieve it from disk cache
            let dataCompletionHandler: Result<NSData> -> Void = { result in
                switch result {
                case .Success(let imageData):
                    if let image = UIImage(data: imageData, scale: UIScreen.mainScreen().scale) {
                        completionHandler(.Success(image))
                    } else {
                        completionHandler(.Failure(ImageCacheError.ImageDataError))
                    }

                case .Failure(let error):
                    completionHandler(.Failure(error))
                }
            }

            try diskCache.retrieveDataForKey(key, completionHandler: dataCompletionHandler)
        }
    }

    //MARK: Remove Image

    /**
    Remove all cached images asynchronously

    - Parameter fromDisk: If true, all cached images will not only be removed from the memory cache, but also from the disk cache
    - Parameter completionHandler: Called on main thread after all cached images got removed

    - Note: `Result` parameter of `completionHandler` contains `.Success` or `.Failure`.
    */
    public func removeAllImagesFromDisk(fromDisk: Bool, completionHandler: (Result<Void> -> Void)?) {
        memoryCache.removeAllObjects()

        if fromDisk {
            diskCache.removeAllData(completionHandler: completionHandler)
        } else {
            completionHandler?(.Success())
        }
    }

    /**
    Remove cached image for key asynchronously

    - Parameter key: Key for image
    - Parameter fromDisk: If true, cached image will not only be removed from the memory cache, but also from the disk cache
    - Parameter completionHandler: Called on main thread after cached image got removed

    - Warning: Doesn't throw when error happens asynchronously. Check `.Success` or `.Failure` in `Result` parameter of `completionHandler` instead.
    */
    public func removeImageForKey(key: String, fromDisk: Bool, completionHandler: (Result<Void> -> Void)?) throws {
        if key.isEmpty {
            throw ImageCacheError.EmptyKey
        }

        memoryCache.removeObjectForKey(key)

        if fromDisk {
            try diskCache.removeDataForKey(key, completionHandler: completionHandler)
        } else {
            completionHandler?(.Success())
        }
    }
}
