//
//  ImageCache.swift
//  iTunesSearch
//
//  Created by 한상진 on 2021/04/17.
//

import Foundation
import UIKit.UIImage

/// Memory Cache 구현
protocol ImageCacheType: class {
    // url에 대한 image 반환
    func image(for url: URL) -> UIImage?
    
    // cache에 추가, 삭제
    func insertImage(_ image: UIImage?, for url: URL)
    func removeImage(for url: URL)
    func removeAllImages()
    
    // read, write를 위해 subscript 구현
    subscript(_ url: URL) -> UIImage? { get set }
}

final class ImageCahce: ImageCacheType {
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()
    
    private lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = config.memoryLimit
        return cache
    }()

    private let lock = NSLock() // Cache는 lock이 필요없다던데 왜 해주는거지?
    private let config: Config
    
    struct Config {
        let countLimit: Int
        let memoryLimit: Int
        
        static let defaultConfig = Config(
            countLimit: 100,
            memoryLimit: 1024 * 1024 * 100 // 100MB
        )
    }
    
    init(config: Config = Config.defaultConfig) {
        self.config = config
    }
    
    func image(for url: URL) -> UIImage? {
        if let decodedImage = decodedImageCache.object(forKey: url as AnyObject) as? UIImage {
            return decodedImage
        }
        
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            let decodedImage = image.decodedImage()
            decodedImageCache.setObject(
                image as AnyObject,
                forKey: url as AnyObject, 
                cost: decodedImage.diskSize
            )
            
            return decodedImage
        }
        
        return nil
    }
    
    func insertImage(_ image: UIImage?, for url: URL) {
        guard let image = image else { return removeImage(for: url) }
        
        let decompressedImage = image.decodedImage()
        
        imageCache.setObject(
            decompressedImage, 
            forKey: url as AnyObject, 
            cost: decompressedImage.diskSize
        )
        decodedImageCache.setObject(
            image as AnyObject,
            forKey: url as AnyObject, 
            cost: decompressedImage.diskSize
        )
    }
    
    func removeImage(for url: URL) {
        imageCache.removeObject(forKey: url as AnyObject)
        decodedImageCache.removeObject(forKey: url as AnyObject)
    }
    
    func removeAllImages() {
        imageCache.removeAllObjects()
        decodedImageCache.removeAllObjects()
    }
    
    subscript(url: URL) -> UIImage? {
        get {
            return image(for: url)
        }
        set {
            return insertImage(newValue, for: url)
        }
    }
}
