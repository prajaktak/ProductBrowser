//
//  WebServiceManager.swift
//  ProductBrowser
//
//  Created by Prajakta Kulkarni on 01/07/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import Foundation

class WebserviceManager: NSObject, URLSessionDelegate {
    enum Result<Value> {
        case success(Value)
        case failure(Error)
    }
    func getData(form path: String, completion: ((Result<[[String: AnyObject]]>) -> Void)?) {
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: request) { (responseData, _, responseError) in
            DispatchQueue.main.async {
                if let error = responseError {
                    completion?(.failure(error))
                } else if let jsonData = responseData {
                    do {
                        // swiftlint:disable line_length
                        if let productsArray = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: AnyObject]] {
                        // swiftlint:enable line_length
                            print(productsArray)
                            completion?(.success(productsArray))
                        }
                    } catch {
                        completion?(.failure(error))
                    }
                } else {
                    let error = NSError(domain: "", code: 0,
                                        userInfo: [NSLocalizedDescriptionKey: "Data was not retrived"]) as Error
                    completion?(.failure(error))
                }
            }
        }
        task.resume()
    }
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let serverTrust = challenge.protectionSpace.serverTrust
        let certificate =  SecTrustGetCertificateAtIndex(serverTrust!, 0)
        //set ssl polocies for domain name check
        let policies = NSMutableArray()
        policies.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))
        SecTrustSetPolicies(serverTrust!, policies)
        //evaluate server certifiacte
        var result: SecTrustResultType =  SecTrustResultType(rawValue: 0)!
        SecTrustEvaluate(serverTrust!, &result)
        let isServerTRusted: Bool =  (result == SecTrustResultType.unspecified || result == SecTrustResultType.proceed)
        //get Local and Remote certificate Data
        let remoteCertificateData: NSData =  SecCertificateCopyData(certificate!)
        let pathToCertificate = Bundle.main.path(forResource: "githubusercontent.com", ofType: "cer")
        let localCertificateData: NSData = NSData(contentsOfFile: pathToCertificate!)!
        //Compare certificates
        if isServerTRusted && remoteCertificateData.isEqual(to: localCertificateData as Data) {
            let credential: URLCredential =  URLCredential(trust: serverTrust!)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
