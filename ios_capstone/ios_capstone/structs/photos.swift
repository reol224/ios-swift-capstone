//
//  photos.swift
//  ios_capstone
//
//  Created by Jack on 2022/8/5.
//
import Foundation

// most of these content created by quicktype website
// minor changes for compatitive

// MARK: - Welcome
struct Photos: Codable {
    let currentPage: Int
    let links: Links
    let count, numPages, perPage: Int
    let results: [Photo]

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case links, count
        case numPages = "num_pages"
        case perPage = "per_page"
        case results
    }
}

// MARK: - Links
struct Links: Codable {
    let next: String?
    let previous: String?
    
    enum CodingKeys: String, CodingKey {
        case next = "next"
        case previous = "previous"
    }
}

// MARK: - Result
struct Photo: Codable {
    let id: Int
    let title, resultDescription, keywords: String
    let url: String
    let thumbURL: String?
    let position: Position

    enum CodingKeys: String, CodingKey {
        case id, title
        case resultDescription = "description"
        case keywords, url
        case thumbURL = "thumb_url"
        case position
    }
}

// MARK: - Position
struct Position: Codable {
    let latitude, longitude: Double
}

