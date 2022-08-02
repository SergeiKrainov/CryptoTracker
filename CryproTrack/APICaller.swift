//
//  APICaller.swift
//  CryproTrack
//
//  Created by Sergey on 02.08.2022.
//

import Foundation


final class APICaller {
    
    static let shared = APICaller()
    
    private struct Constanse {
        static let apiKey = "71ED753D-D560-49CC-8571-8D25825CAE19"
        static let assetsEndpoint = "https://rest.coinapi.io/v1/assets"
    }
    
    private init() {}
    
    public var icons: [Icon] = []
    
    private var whenReadyBlock: ((Result<[Crypto], Error>) -> Void)?
    
    // MARK: - Public
    
    public func getAllCryptoData(
        completion: @escaping (Result<[Crypto], Error>) -> Void
    ) {
        guard !icons.isEmpty else {
            whenReadyBlock = completion
            return
        }
        
        guard let url = URL(string: Constanse.assetsEndpoint + "?apikey=" + Constanse.apiKey) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                // Decode response
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                
                completion(.success(cryptos.sorted { first, second in
                    return first.price_usd ?? 0 > second.price_usd ?? 0
                }))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func getAllIcons() {
        guard let url = URL(string: "https://rest.coinapi.io/v1/assets/icons/55/?apikey=71ED753D-D560-49CC-8571-8D25825CAE19") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                self?.icons = try JSONDecoder().decode([Icon].self, from: data)
                if let completion = self?.whenReadyBlock {
                    self?.getAllCryptoData(completion: completion)
                }
            }
            catch {
              print(error)
            }
        }
        task.resume()
    }
}
