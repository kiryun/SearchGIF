//
//  Search.swift
//  SearchGIF
//
//  Created by Wimes on 2021/12/15.
//

import Foundation


struct SearchResult{
    var search: [String]
    var newSearch: Bool
}

// MARK: - Welcome
struct Search: Codable {
    let meta: Meta
    let pagination: Pagination
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let isSticker: Int
    let slug, source, title: String
    let url: String
    let analyticsResponsePayload: String
    let images: Images
    let bitlyGIFURL: String
    let trendingDatetime, sourceTLD, type: String
    let analytics: Analytics
    let id: String
    let user: User?
    let contentURL: String
    let bitlyURL: String
    let sourcePostURL, importDatetime: String
    let embedURL: String
    let rating, username: String

    enum CodingKeys: String, CodingKey {
        case isSticker = "is_sticker"
        case slug, source, title, url
        case analyticsResponsePayload = "analytics_response_payload"
        case images
        case bitlyGIFURL = "bitly_gif_url"
        case trendingDatetime = "trending_datetime"
        case sourceTLD = "source_tld"
        case type, analytics, id, user
        case contentURL = "content_url"
        case bitlyURL = "bitly_url"
        case sourcePostURL = "source_post_url"
        case importDatetime = "import_datetime"
        case embedURL = "embed_url"
        case rating, username
    }
}

// MARK: - Analytics
struct Analytics: Codable {
    let onclick, onload, onsent: Onclick
}

// MARK: - Onclick
struct Onclick: Codable {
    let url: String
}

// MARK: - Images
struct Images: Codable {
    let fixedHeight, fixedWidthSmall: FixedHeight
    let preview: DownsizedSmall
    let hd: DownsizedSmall?
    let the480WStill: The480_WStill
    let downsizedSmall: DownsizedSmall
    let original: FixedHeight
    let previewGIF, downsized, downsizedLarge: The480_WStill
    let fixedHeightDownsampled, fixedHeightSmall: FixedHeight
    let previewWebp: The480_WStill?
    let originalMp4: DownsizedSmall
    let fixedWidth: FixedHeight
    let fixedWidthStill: The480_WStill
    let fixedWidthDownsampled: FixedHeight
    let downsizedMedium, fixedHeightSmallStill, originalStill: The480_WStill
    let looping: Looping
    let fixedHeightStill, fixedWidthSmallStill, downsizedStill: The480_WStill

    enum CodingKeys: String, CodingKey {
        case fixedHeight = "fixed_height"
        case fixedWidthSmall = "fixed_width_small"
        case preview, hd
        case the480WStill = "480w_still"
        case downsizedSmall = "downsized_small"
        case original
        case previewGIF = "preview_gif"
        case downsized
        case downsizedLarge = "downsized_large"
        case fixedHeightDownsampled = "fixed_height_downsampled"
        case fixedHeightSmall = "fixed_height_small"
        case previewWebp = "preview_webp"
        case originalMp4 = "original_mp4"
        case fixedWidth = "fixed_width"
        case fixedWidthStill = "fixed_width_still"
        case fixedWidthDownsampled = "fixed_width_downsampled"
        case downsizedMedium = "downsized_medium"
        case fixedHeightSmallStill = "fixed_height_small_still"
        case originalStill = "original_still"
        case looping
        case fixedHeightStill = "fixed_height_still"
        case fixedWidthSmallStill = "fixed_width_small_still"
        case downsizedStill = "downsized_still"
    }
}

// MARK: - The480_WStill
struct The480_WStill: Codable {
    let size, height, width: String?
    let url: String?
}

// MARK: - DownsizedSmall
struct DownsizedSmall: Codable {
    let mp4: String?
    let height, width, mp4Size: String?

    enum CodingKeys: String, CodingKey {
        case mp4, height, width
        case mp4Size = "mp4_size"
    }
}

// MARK: - FixedHeight
struct FixedHeight: Codable {
    let height, mp4Size, width, size: String?
    let mp4: String?
    let webpSize: String?
    let webp: String?
    let url: String?
    let frames, hash: String?

    enum CodingKeys: String, CodingKey {
        case height
        case mp4Size = "mp4_size"
        case width, size, mp4
        case webpSize = "webp_size"
        case webp, url, frames, hash
    }
}

// MARK: - Looping
struct Looping: Codable {
    let mp4: String?
    let mp4Size: String?

    enum CodingKeys: String, CodingKey {
        case mp4
        case mp4Size = "mp4_size"
    }
}

// MARK: - User
struct User: Codable {
    let userDescription: String
    let instagramURL: String
    let isVerified: Bool
    let profileURL: String
    let websiteURL: String
    let username, displayName: String
    let bannerImage: String
    let avatarURL: String
    let bannerURL: String

    enum CodingKeys: String, CodingKey {
        case userDescription = "description"
        case instagramURL = "instagram_url"
        case isVerified = "is_verified"
        case profileURL = "profile_url"
        case websiteURL = "website_url"
        case username
        case displayName = "display_name"
        case bannerImage = "banner_image"
        case avatarURL = "avatar_url"
        case bannerURL = "banner_url"
    }
}

// MARK: - Meta
struct Meta: Codable {
    let status: Int
    let msg, responseID: String

    enum CodingKeys: String, CodingKey {
        case status, msg
        case responseID = "response_id"
    }
}

// MARK: - Pagination
struct Pagination: Codable {
    let totalCount, count, offset: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count, offset
    }
}
