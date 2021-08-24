//
//  NetworkServiceProvider.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 23.08.2021.
//

import Foundation
import RxCocoa
import RxSwift

class NetworkServiceProvider<N: NetworkService> {

    private var urlSession: URLSession

    private var decoder: JSONDecoder

    init(urlSession: URLSession =  URLSession.shared,
         decoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.decoder = decoder
    }
}

extension NetworkServiceProvider {

    func request<D: Decodable>(endpoint: N) -> Observable<Result<D, Error>> {
        return Observable.create { [weak self] (observer) -> Disposable in
            
            guard let self = self else {
                observer.onNext(.failure(AppError.unknown))
                return Disposables.create()
            }

            #if DEBUG
            print("NetworkServiceProvider: \n \(endpoint.description)")
            #endif

            self.urlSession.dataTask(with: endpoint.urlRequest) { (data, response: URLResponse?, error) in
                if let error = error {
                    observer.onNext(.failure(error))
                } else if let data = data, let response = response, let httpResponse = response as? HTTPURLResponse {

                    #if DEBUG
                    print("NetworkServiceProvider: Response \n \(httpResponse.statusCode) \(httpResponse.url?.description ?? "")")
                    print("NetworkServiceProvider: Response Body \n \(String(data: data, encoding: .utf8) ?? "")")

                    #endif

                    switch httpResponse.statusCode {
                    case 200..<300:
                        do {
                            let object = try self.decoder.decode(D.self, from: data)
                            observer.onNext(.success(object))
                        } catch {
                            observer.onNext(.failure(AppError.unableToDecode))
                        }

                    default:
                        observer.onNext(.failure(ApiError.unknown))
                    }
                } else {
                    observer.onNext(.failure(ApiError.unknown))
                }
            }.resume()
            return Disposables.create()
        }
    }
}
