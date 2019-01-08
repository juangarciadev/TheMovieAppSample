//
//  BaseAPI.swift
//  TheMovieAppSample
//
//  Created by Juan Garcia on 1/6/19.
//  Copyright © 2019 Juan Garcia. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

public enum FailureReason: Int, Error {
    case unAuthorized = 401
    case notFound = 404
}

public struct BaseAPI {
    
    static func request(_ url: URLConvertible,
                       method: HTTPMethod = .get,
                       parameters: Parameters? = nil,
                       encoding: ParameterEncoding = URLEncoding.default,
                       headers: HTTPHeaders? = nil) -> Observable<DataResponse<Any>> {
        return Observable.create { observer -> Disposable in
            Alamofire.request(url,
                              method: method,
                              parameters: parameters,
                              encoding: encoding,
                              headers: headers)
                .validate()
                .responseJSON { response in
                    observer.onNext(response)
            }
            
            return Disposables.create()
        }
    }
}
