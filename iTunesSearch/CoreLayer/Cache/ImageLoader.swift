//
//  ImageLoader.swift
//  iTunesSearch
//
//  Created by 한상진 on 2021/04/17.
//

import Foundation
import UIKit.UIImage
import RxSwift

enum CacheError: Error {
    case noCachcedImage
    case cacheNetworkError
    case cacheNetworkRespondeDataError
}

enum CacheType {
    case none
    case memory
    case disk
    
    var cached: Bool {
        switch self {
        case .disk, .memory: return true
        case .none: return false
        }
    }
}

final class ImageLoader {
    private let cache: ImageCacheType
    
    static let shared = ImageLoader()
    private init(cache: ImageCacheType = ImageCahce()) {
        self.cache = cache
    }
    
    func loadImage(
        from urlStr: String,
        cacheType: CacheType = .memory
    ) -> Single<UIImage> {
        Single.create { [weak self] single -> Disposable in
            guard let self = self else { return Disposables.create() }
            guard let url = URL(string: urlStr) else { return Disposables.create() }
            
            switch cacheType {
            case .memory:
                if let image = self.cache[url] {
                    single(.success(image))
                    
                    return Disposables.create()
                }
                
                break
            case .disk, .none:
                break
            }
            
            let session: URLSession = URLSession(configuration: .ephemeral)
            
            let task: URLSessionTask = session.dataTask(with: url) { [weak self] data, response, error in
                guard error.isNone else { 
                    single(.failure(CacheError.cacheNetworkError)) 
                    return
                }
                
                guard let responseData = data,
                      let image = UIImage(data: responseData)
                else { 
                    single(.failure(CacheError.cacheNetworkRespondeDataError))
                    return
                }
                
                self?.cache[url] = image
                
                single(.success(image))
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
                session.invalidateAndCancel()
            }
        }
        
    }
}
