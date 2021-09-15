//
//  Photo.swift
//  PhotoViewer
//
//  Created by Aleksandr Seminov on 11.09.2021.
//

import Foundation

struct Photo: Decodable {
    var id: String
    var author: String
    var download_url: String
}
