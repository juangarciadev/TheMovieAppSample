//
//  SearchAPI.swift
//  TheMovieAppSample
//
//  Created by Juan Garcia on 1/6/19.
//  Copyright © 2019 Juan Garcia. All rights reserved.
//

import Foundation
import RxSwift

struct SearchAPI {
    
    static let shared = SearchAPI()
    let disposeBag = DisposeBag()
    
    // Use singleton instance
    private init(){}
    
    /*
     Search for movies.
     
     - Parameters:
     - language: Pass a ISO 639-1 value to display translated data for the fields that support it. Default: en-US
     - page: Specify which page to query. Default: 1
     - include_adult: Choose whether to inlcude adult (pornography) content in the results.
     - region: Specify a ISO 3166-1 code to filter release dates. Must be uppercase.
     - year: Optional
     - primary_release_year: Optional
     */
    public func getMovies(for query: String,
                          language: String? = nil,
                          page: Int? = nil,
                          includeAdult: Bool? = nil,
                          region: String? = nil,
                          year: Int? = nil,
                          primaryReleaseYear: Int? = nil) -> Observable<MovieResponse> {
        
        return Observable.create { observer -> Disposable in
            // Set up the URL request
            let endpointString = GlobalConfiguration.SearchMovieURLString
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
                GlobalConfiguration.TextQueryParameter: query
            ]
            if let language = language {
                parameters[GlobalConfiguration.LanguageQueryParameter] = language
            }
            if let page = page {
                parameters[GlobalConfiguration.PageQueryParameter] = page
            }
            if let includeAdult = includeAdult {
                parameters[GlobalConfiguration.IncludeAdultQueryParameter] = includeAdult
            }
            if let region = region {
                parameters[GlobalConfiguration.RegionQueryParameter] = region
            }
            if let year = year {
                parameters[GlobalConfiguration.YearQueryParameter] = year
            }
            if let primaryReleaseYear = primaryReleaseYear {
                parameters[GlobalConfiguration.PrimaryReleaseYear] = primaryReleaseYear
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
    
}
