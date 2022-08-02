//
//  Models.swift
//  CryproTrack
//
//  Created by Sergey on 02.08.2022.
//

import Foundation

struct Crypto: Codable {
    let asset_id: String
    let name: String?
    let price_usd: Float?
    let id_icon: String?
}

struct Icon: Codable {
    let asset_id: String
    let url: String
}


