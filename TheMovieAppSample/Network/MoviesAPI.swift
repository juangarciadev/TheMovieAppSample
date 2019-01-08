//
//  MoviesAPI.swift
//  TheMovieAppSample
//
//  Created by Juan Garcia on 1/6/19.
//  Copyright © 2019 Juan Garcia. All rights reserved.
//

import Foundation
import RxSwift

struct MoviesAPI {
    
    static let shared = MoviesAPI()
    let disposeBag = DisposeBag()
    
    // Use singleton instance
    private init(){}
    
    /**
     Get a list of upcoming movies in theatres. This is a release type query that looks for all movies that have a release type of 2 or 3 within the specified date range.
     
     - Note: You can optionally specify a region prameter which will narrow the search to only look for theatrical release dates within the specified country.
     
     - Parameters:
        - language: Pass a ISO 639-1 value to display translated data for the fields that support it. Default: en-US
        - page: Specify which page to query. Default: 1
        - region: Specify a ISO 3166-1 code to filter release dates. Must be uppercase.
     */
    func getUpcoming(language: String? = nil, page: Int? = nil, region: String? = nil) -> Observable<MovieResponse> {
        
        return Observable.create { observer -> Disposable in
            // Set up the URL request
            let endpointString = GlobalConfiguration.MovieUpcomingURLString
            guard let url = URL(string: endpointString) else {
                assertionFailure("error: URL NOT valid")
                return Disposables.create()
            }
            
            guard let key = GlobalConfiguration.TMDbAPIKey else {
                assertionFailure("Error: could not extract API key")
                return Disposables.create()
            }
            var parameters: [String: Any] = [GlobalConfiguration.AppIdQueryParameter: key]
            if let language = language {
                parameters[GlobalConfiguration.LanguageQueryParameter] = language
            }
            if let page = page {
                parameters[GlobalConfiguration.PageQueryParameter] = page
            }
            if let region = region {
                parameters[GlobalConfiguration.RegionQueryParameter] = region
            }
            
            BaseAPI
                .request(url, parameters: parameters)
                .subscribe(onNext: { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            // if no error provided by alamofire return .notFound error instead.
                            observer.onError(response.error ?? FailureReason.notFound)
                            return
                        }
                        do {
                            let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                            observer.onNext(movieResponse)
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode,
                            let reason = FailureReason(rawValue: statusCode) {
                            observer.onError(reason)
                        }
                        observer.onError(error)
                    }
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    /**
     Get the primary information about a movie.
     
     - Parameters:
        - language: Pass a ISO 639-1 value to display translated data for the fields that support it. Default: en-US
        - append_to_response: Append requests within the same namespace to the response.
     */
    func getDetail(for movieId: Int, language: String? = nil, appendToResponse: String? = nil) -> Observable<Movie> {
        
        return Observable.create { observer -> Disposable in
            // Set up the URL request
            let endpointString = GlobalConfiguration.MovieURLString
            guard let url = URL(string: endpointString) else {
                assertionFailure("error: URL NOT valid")
                return Disposables.create()
            }
            
            guard let key = GlobalConfiguration.TMDbAPIKey else {
                assertionFailure("Error: could not extract API key")
                return Disposables.create()
            }
            
            var parameters: [String: Any] = [
                GlobalConfiguration.AppIdQueryParameter: key,
                GlobalConfiguration.MovieIdQueryParameter: movieId
            ]
            if let language = language {
                parameters[GlobalConfiguration.LanguageQueryParameter] = language
            }
            if let appendToResponse = appendToResponse {
                parameters[GlobalConfiguration.AppendToResponseQueryParameter] = appendToResponse
            }
            
            BaseAPI
                .request(url, parameters: parameters)
                .subscribe(onNext: { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            // if no error provided by alamofire return .notFound error instead.
                            observer.onError(response.error ?? FailureReason.notFound)
                            return
                        }
                        do {
                            let movie = try JSONDecoder().decode(Movie.self, from: data)
                            observer.onNext(movie)
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode,
                            let reason = FailureReason(rawValue: statusCode) {
                            observer.onError(reason)
                        }
                        observer.onError(error)
                    }
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
