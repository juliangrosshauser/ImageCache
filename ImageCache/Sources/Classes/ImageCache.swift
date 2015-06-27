//
//  ImageCache.swift
//  ImageCache
//
//  Created by Julian Grosshauser on 27/06/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

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
}
