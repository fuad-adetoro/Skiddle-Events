//
//  URLSession+Rx.swift
//  SkiddleEvents
//
//  Created by Fuad Adetoro on 31/07/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

fileprivate var internalCache = [String: Data]()
fileprivate var eventsInternalCache = [String: Event]()

public enum RxURLSessionError: Error {
    case unknown
    case invalidResponse(response: URLResponse)
    case requestFailed(response: HTTPURLResponse, data: Data?)
    case deserializationFailed
}

extension Reactive where Base: URLSession {
    func response(request: URLRequest) -> Observable<(HTTPURLResponse, Data)> {
        return Observable.create { observer in
            let task = self.base.dataTask(with: request) { (data, response, error) in
                guard let response = response, let data = data else {
                    observer.onError(error ?? RxURLSessionError.unknown)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.onError(RxURLSessionError.invalidResponse(response: response))
                    return
                }
                
                observer.onNext((httpResponse, data))
                observer.on(.completed)
            }
            
            task.resume()
            
            return Disposables.create(with: task.cancel)
        }
    }
    
    func data(request: URLRequest) -> Observable<Data> {
        if let url = request.url?.absoluteString, let data = internalCache[url] {
            return Observable.just(data)
        }
        
        return response(request: request).cache().map { response, data -> Data in
            if 200 ..< 300 ~= response.statusCode {
                return data
            } else {
                throw RxURLSessionError.requestFailed(response: response, data: data)
            }
        }
    }
    
    func json(request: URLRequest) -> Observable<JSON> {
        return data(request: request).map { d in
            return try JSON(data: d)
        }
    }
    
    func event(request: URLRequest) -> Observable<[Event]> {
        return json(request: request).map { json in
            return json["results"]
        }.map(SkiddleAPI.shared.events)
    }
    
    func image(request: URLRequest) -> Observable<UIImage> {
        return data(request: request).map { d in
            return UIImage(data: d) ?? UIImage()
        }
    }
}

extension ObservableType where E == (HTTPURLResponse, Data) {
    func cache() -> Observable<E> {
        return self.do(onNext: { (response, data) in
            if let url = response.url?.absoluteString, 200 ..< 300 ~= response.statusCode {
                internalCache[url] = data
            }
        })
    }
}

extension ObservableType where E == ([Event]) {
    func cacheEvents() -> Observable<E> {
        return self.do(onNext: { (events) in
            print("internalCache: \(internalCache[events[0].id])")
            
            for event in events {
                print("Adding: \(event.id) to cache")
                eventsInternalCache[event.id] = event
            }
            
            print("Internal Cache: \(internalCache)")
        })
    }
}

/*extension ObservableType where E == (HTTPURLResponse, Event) {
    func cache() -> Observable<E> {
        return self.do(onNext: { (response, event) in
            internalCache[event.id] = event
            }
        })
    }
}*/
