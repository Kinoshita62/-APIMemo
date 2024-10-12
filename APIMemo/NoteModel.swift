//
//  Note.swift
//  APIMemo
//
//  Created by USER on 2024/10/12.
//

import Foundation
struct Note: Codable, Identifiable {
    let id: Int
    let title: String
    let content: String
}
