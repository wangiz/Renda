//
//  RatedItemsTable.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.5
//

import Foundation
import UIKit
import AWSDynamoDB
import AWSMobileHubHelper

class RatedItemsTable: NSObject, Table {
    
    var tableName: String
    var partitionKeyName: String
    var partitionKeyType: String
    var sortKeyName: String?
    var sortKeyType: String?
    var model: AWSDynamoDBObjectModel
    var indexes: [Index]
    var orderedAttributeKeys: [String] {
        return produceOrderedAttributeKeys(model)
    }
    var tableDisplayName: String {

        return "RatedItems"
    }
    
    override init() {

        model = RatedItems()
        
        tableName = model.classForCoder.dynamoDBTableName()
        partitionKeyName = model.classForCoder.hashKeyAttribute()
        partitionKeyType = "String"
        indexes = [

            RatedItemsPrimaryIndex(),

            RatedItemsRatings(),
        ]
        if (model.classForCoder.respondsToSelector("rangeKeyAttribute")) {
            sortKeyName = model.classForCoder.rangeKeyAttribute!()
            sortKeyType = "String"
        }
        super.init()
    }
    
    /**
     * Converts the attribute name from data object format to table format.
     *
     * - parameter dataObjectAttributeName: data object attribute name
     * - returns: table attribute name
     */

    func tableAttributeName(dataObjectAttributeName: String) -> String {
        return RatedItems.JSONKeyPathsByPropertyKey()[dataObjectAttributeName] as! String
    }
    
    func getItemDescription() -> String {
        return "Find Item with userId = \(AWSIdentityManager.defaultIdentityManager().identityId!) and itemId = \("demo-itemId-500000")."
    }
    
    func getItemWithCompletionHandler(completionHandler: (response: AWSDynamoDBObjectModel?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        objectMapper.load(RatedItems.self, hashKey: AWSIdentityManager.defaultIdentityManager().identityId!, rangeKey: "demo-itemId-500000", completionHandler: {(response: AWSDynamoDBObjectModel?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func scanDescription() -> String {
        return "Show all items in the table."
    }
    
    func scanWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 5

        objectMapper.scan(RatedItems.self, expression: scanExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func scanWithFilterDescription() -> String {
        return "Find all items with details < \("demo-details-500000")."
    }
    
    func scanWithFilterWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let scanExpression = AWSDynamoDBScanExpression()
        
        scanExpression.filterExpression = "#details < :details"
        scanExpression.expressionAttributeNames = ["#details": "details" ,]
        scanExpression.expressionAttributeValues = [":details": "demo-details-500000" ,]

        objectMapper.scan(RatedItems.self, expression: scanExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func insertSampleDataWithCompletionHandler(completionHandler: (errors: [NSError]?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        var errors: [NSError] = []
        let group: dispatch_group_t = dispatch_group_create()
        let numberOfObjects = 20
        

        let itemForGet = RatedItems()
        
        itemForGet._userId = AWSIdentityManager.defaultIdentityManager().identityId!
        itemForGet._itemId = "demo-itemId-500000"
        itemForGet._category = NoSQLSampleDataGenerator.randomPartitionSampleStringWithAttributeName("category")
        itemForGet._details = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("details")
        itemForGet._name = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("name")
        itemForGet._ratingCount = NoSQLSampleDataGenerator.randomSampleNumber()
        itemForGet._ratingValue = NoSQLSampleDataGenerator.randomSampleNumber()
        
        
        dispatch_group_enter(group)
        

        objectMapper.save(itemForGet, completionHandler: {(error: NSError?) -> Void in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    errors.append(error!)
                })
            }
            dispatch_group_leave(group)
        })
        
        for _ in 1..<numberOfObjects {

            let item: RatedItems = RatedItems()
            item._userId = AWSIdentityManager.defaultIdentityManager().identityId!
            item._itemId = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("itemId")
            item._category = NoSQLSampleDataGenerator.randomPartitionSampleStringWithAttributeName("category")
            item._details = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("details")
            item._name = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("name")
            item._ratingCount = NoSQLSampleDataGenerator.randomSampleNumber()
            item._ratingValue = NoSQLSampleDataGenerator.randomSampleNumber()
            
            dispatch_group_enter(group)
            
            objectMapper.save(item, completionHandler: {(error: NSError?) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        errors.append(error!)
                    })
                }
                dispatch_group_leave(group)
            })
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), {
            if errors.count > 0 {
                completionHandler(errors: errors)
            }
            else {
                completionHandler(errors: nil)
            }
        })
    }
    
    func removeSampleDataWithCompletionHandler(completionHandler: (errors: [NSError]?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = ["#userId": "userId"]
        queryExpression.expressionAttributeValues = [":userId": AWSIdentityManager.defaultIdentityManager().identityId!,]

        objectMapper.query(RatedItems.self, expression: queryExpression) { (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            if let error = error {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(errors: [error]);
                    })
            } else {
                var errors: [NSError] = []
                let group: dispatch_group_t = dispatch_group_create()
                for item in response!.items {
                    dispatch_group_enter(group)
                    objectMapper.remove(item, completionHandler: {(error: NSError?) -> Void in
                        if error != nil {
                            dispatch_async(dispatch_get_main_queue(), {
                                errors.append(error!)
                            })
                        }
                        dispatch_group_leave(group)
                    })
                }
                dispatch_group_notify(group, dispatch_get_main_queue(), {
                    if errors.count > 0 {
                        completionHandler(errors: errors)
                    }
                    else {
                        completionHandler(errors: nil)
                    }
                })
            }
        }
    }
    
    func updateItem(item: AWSDynamoDBObjectModel, completionHandler: (error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        

        let itemToUpdate: RatedItems = item as! RatedItems
        
        itemToUpdate._category = NoSQLSampleDataGenerator.randomPartitionSampleStringWithAttributeName("category")
        itemToUpdate._details = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("details")
        itemToUpdate._name = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("name")
        itemToUpdate._ratingCount = NoSQLSampleDataGenerator.randomSampleNumber()
        itemToUpdate._ratingValue = NoSQLSampleDataGenerator.randomSampleNumber()
        
        objectMapper.save(itemToUpdate, completionHandler: {(error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(error: error)
            })
        })
    }
    
    func removeItem(item: AWSDynamoDBObjectModel, completionHandler: (error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        
        objectMapper.remove(item, completionHandler: {(error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(error: error)
            })
        })
    }
}

class RatedItemsPrimaryIndex: NSObject, Index {
    
    var indexName: String? {
        return nil
    }
    
    func supportedOperations() -> [String] {
        return [
            QueryWithPartitionKey,
            QueryWithPartitionKeyAndFilter,
            QueryWithPartitionKeyAndSortKey,
            QueryWithPartitionKeyAndSortKeyAndFilter,
        ]
    }
    
    func queryWithPartitionKeyDescription() -> String {
        return "Find all items with userId = \(AWSIdentityManager.defaultIdentityManager().identityId!)."
    }
    
    func queryWithPartitionKeyWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = ["#userId": "userId",]
        queryExpression.expressionAttributeValues = [":userId": AWSIdentityManager.defaultIdentityManager().identityId!,]

        objectMapper.query(RatedItems.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func queryWithPartitionKeyAndFilterDescription() -> String {
        return "Find all items with userId = \(AWSIdentityManager.defaultIdentityManager().identityId!) and details > \("demo-details-500000")."
    }
    
    func queryWithPartitionKeyAndFilterWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.filterExpression = "#details > :details"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#details": "details",
        ]
        queryExpression.expressionAttributeValues = [
            ":userId": AWSIdentityManager.defaultIdentityManager().identityId!,
            ":details": "demo-details-500000",
        ]
        

        objectMapper.query(RatedItems.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func queryWithPartitionKeyAndSortKeyDescription() -> String {
        return "Find all items with userId = \(AWSIdentityManager.defaultIdentityManager().identityId!) and itemId < \("demo-itemId-500000")."
    }
    
    func queryWithPartitionKeyAndSortKeyWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#userId = :userId AND #itemId < :itemId"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#itemId": "itemId",
        ]
        queryExpression.expressionAttributeValues = [
            ":userId": AWSIdentityManager.defaultIdentityManager().identityId!,
            ":itemId": "demo-itemId-500000",
        ]
        

        objectMapper.query(RatedItems.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func queryWithPartitionKeyAndSortKeyAndFilterDescription() -> String {
        return "Find all items with userId = \(AWSIdentityManager.defaultIdentityManager().identityId!), itemId < \("demo-itemId-500000"), and details > \("demo-details-500000")."
    }
    
    func queryWithPartitionKeyAndSortKeyAndFilterWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#userId = :userId AND #itemId < :itemId"
        queryExpression.filterExpression = "#details > :details"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#itemId": "itemId",
            "#details": "details",
        ]
        queryExpression.expressionAttributeValues = [
            ":userId": AWSIdentityManager.defaultIdentityManager().identityId!,
            ":itemId": "demo-itemId-500000",
            ":details": "demo-details-500000",
        ]
        

        objectMapper.query(RatedItems.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
}

class RatedItemsRatings: NSObject, Index {
    
    var indexName: String? {

        return "Ratings"
    }
    
    func supportedOperations() -> [String] {
        return [
            QueryWithPartitionKey,
            QueryWithPartitionKeyAndFilter,
            QueryWithPartitionKeyAndSortKey,
            QueryWithPartitionKeyAndSortKeyAndFilter,
        ]
    }
    
    func queryWithPartitionKeyDescription() -> String {
        return "Find all items with category = \("demo-category-3")."
    }
    
    func queryWithPartitionKeyWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        

        queryExpression.indexName = "Ratings"
        queryExpression.keyConditionExpression = "#category = :category"
        queryExpression.expressionAttributeNames = ["#category": "category",]
        queryExpression.expressionAttributeValues = [":category": "demo-category-3",]

        objectMapper.query(RatedItems.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func queryWithPartitionKeyAndFilterDescription() -> String {
        return "Find all items with category = \("demo-category-3") and itemId > \("demo-itemId-500000")."
    }
    
    func queryWithPartitionKeyAndFilterWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        

        queryExpression.indexName = "Ratings"
        queryExpression.keyConditionExpression = "#category = :category"
        queryExpression.filterExpression = "#itemId > :itemId"
        queryExpression.expressionAttributeNames = [
            "#category": "category",
            "#itemId": "itemId",
        ]
        queryExpression.expressionAttributeValues = [
            ":category": "demo-category-3",
            ":itemId": "demo-itemId-500000",
        ]
        

        objectMapper.query(RatedItems.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func queryWithPartitionKeyAndSortKeyDescription() -> String {
        return "Find all items with category = \("demo-category-3") and ratingValue < \(1111500000)."
    }
    
    func queryWithPartitionKeyAndSortKeyWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        

        queryExpression.indexName = "Ratings"
        queryExpression.keyConditionExpression = "#category = :category AND #ratingValue < :ratingValue"
        queryExpression.expressionAttributeNames = [
            "#category": "category",
            "#ratingValue": "ratingValue",
        ]
        queryExpression.expressionAttributeValues = [
            ":category": "demo-category-3",
            ":ratingValue": 1111500000,
        ]
        

        objectMapper.query(RatedItems.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func queryWithPartitionKeyAndSortKeyAndFilterDescription() -> String {
        return "Find all items with category = \("demo-category-3"), ratingValue < \(1111500000), and itemId > \("demo-itemId-500000")."
    }
    
    func queryWithPartitionKeyAndSortKeyAndFilterWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        

        queryExpression.indexName = "Ratings"
        queryExpression.keyConditionExpression = "#category = :category AND #ratingValue < :ratingValue"
        queryExpression.filterExpression = "#itemId > :itemId"
        queryExpression.expressionAttributeNames = [
            "#category": "category",
            "#ratingValue": "ratingValue",
            "#itemId": "itemId",
        ]
        queryExpression.expressionAttributeValues = [
            ":category": "demo-category-3",
            ":ratingValue": 1111500000,
            ":itemId": "demo-itemId-500000",
        ]
        

        objectMapper.query(RatedItems.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
}
