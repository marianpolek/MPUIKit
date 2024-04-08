//
//  PaginationHelpers.swift
//  MPUIKit_example
//
//  Created by Marian Polek on 08/04/2024.
//

import Foundation
import MPUIKit

public struct ResponseItem: CodableWithId {

    public var id: String
    public var title: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
    }

    public init(id: String, title: String) {
        self.id = id
        self.title = title
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
    }
}

public class NetworkingService {
    
    public func getResponsItems(page: Int = 1,
                                pageSize: Int = 14,
                                completion: @escaping ((CompletionResult<any PagingItemListResponse, AppError>) -> ())) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            completion(.value(
                    ResponseItemList<ResponseItem>(items: Self.listOfResponse.partOfArrayBy(from: (page-1)*pageSize, to: page*pageSize),
                                                   page: page,
                                                   pageSize: pageSize,
                                                   totalCount: Self.listOfResponse.count
                                                   
                )))
        })
    }
    
    static var listOfResponse: [ResponseItem] = NetworkingService.defaultItems()
    
    static func defaultItems() -> [ResponseItem] {
        
        var fA: [ResponseItem] = []
        for i in 0..<63 {
            fA.append(ResponseItem(id: String.random(length: 10), title: "\(i) - \(String.random(length: 10))"))
        }
        return fA
    }
}
                   

public struct ResponseItemList<T: CodableWithId>: PagingItemListResponse {

    public var totalCount: Int
    public var page: Int
    public var pageSize: Int
    public var items: [T]
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
        case page = "page"
        case pageSize = "pageSize"
        case totalCount = "totalCount"
    }

    public init(items: [T], page: Int, pageSize: Int, totalCount: Int) {
        self.items = items
        self.page = page
        self.pageSize = pageSize
        self.totalCount = totalCount
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        items = try container.decode([T].self, forKey: .items)
        page = try container.decode(Int.self, forKey: .page)
        pageSize = try container.decode(Int.self, forKey: .pageSize)
        totalCount = try container.decode(Int.self, forKey: .totalCount)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(items, forKey: .items)
        try container.encode(page, forKey: .page)
        try container.encode(pageSize, forKey: .pageSize)
        try container.encode(totalCount, forKey: .totalCount)
    }
}

public enum AppError: Error, Equatable, Comparable {
    
    
}
