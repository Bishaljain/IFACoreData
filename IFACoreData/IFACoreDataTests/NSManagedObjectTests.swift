//
//  NSManagedObjectTests.swift
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 4/3/17.
//  Copyright © 2017 InfoAccent Pty Ltd. All rights reserved.
//

import Foundation
import XCTest
import IFACoreData

class NSManagedObjectTests: IFACoreDataTestCase {

    override func setUp() {
        super.setUp()
        self.createInMemoryTestDatabase()
    }

    func testDuplicateToTarget() {

        // Given
        let relatedManagedObject1 = TestCoreDataEntity5.ifa_instantiate()
        relatedManagedObject1.attribute1 = "test-related-object-1"
        relatedManagedObject1.attribute2 = true;
        let relatedManagedObject2 = TestCoreDataEntity5.ifa_instantiate()
        relatedManagedObject2.attribute1 = "test-related-object-2"
        relatedManagedObject2.attribute2 = true;
        let relatedManagedObject3 = TestCoreDataEntity5.ifa_instantiate()
        relatedManagedObject3.attribute1 = "test-related-object-3"
        relatedManagedObject3.attribute2 = true;

        let childManagedObject1 = TestCoreDataEntity4Child.ifa_instantiate()
        childManagedObject1.attribute1 = "test-child-object-1"
        childManagedObject1.attribute2 = true;
        let childManagedObject2 = TestCoreDataEntity4Child.ifa_instantiate()
        childManagedObject2.attribute1 = "test-child-object-2"
        childManagedObject2.attribute2 = true;
        let childManagedObject3 = TestCoreDataEntity4Child.ifa_instantiate()
        childManagedObject3.attribute1 = "test-child-object-3"
        childManagedObject3.attribute2 = true;

        let managedObject = TestCoreDataEntity4.ifa_instantiate()
        managedObject.name = "Test Name"
        managedObject.attribute1 = "test-attribute1"
        managedObject.attribute2 = 1
        managedObject.entity5ToOne = relatedManagedObject1
        managedObject.addEntity5(toManyObject: relatedManagedObject2)
        managedObject.addEntity5(toManyObject: relatedManagedObject3)
        managedObject.addChildrenObject(childManagedObject1)
        managedObject.addChildrenObject(childManagedObject2)
        managedObject.child = childManagedObject3
        XCTAssertTrue(IFAPersistenceManager.sharedInstance().save())
        
        // When
        let duplicate = TestCoreDataEntity4.ifa_instantiate()
        managedObject.ifa_duplicate(toTarget: duplicate, ignoringKeys: Set(["attribute1"]))
        XCTAssertTrue(IFAPersistenceManager.sharedInstance().save())
        
        // Then
        let allObjects = TestCoreDataEntity4.ifa_findAll()
        XCTAssertEqual(allObjects.count, 2)
        let managedObject1 = allObjects[0] as! TestCoreDataEntity4
        let managedObject2 = allObjects[1] as! TestCoreDataEntity4
        XCTAssertEqual(managedObject1.name, managedObject2.name)
        XCTAssertEqual(managedObject1.attribute2, managedObject2.attribute2)
        XCTAssertEqual(managedObject1.entity5ToOne, managedObject2.entity5ToOne)
        XCTAssertEqual(managedObject1.entity5ToMany, managedObject2.entity5ToMany)
        XCTAssertEqual(managedObject1.children!.count, managedObject2.children!.count)
        XCTAssertEqual(managedObject1.children!.count, 2)
        XCTAssertNotEqual(managedObject1.children!, managedObject2.children!)
        XCTAssertEqual(managedObject2.child, childManagedObject3)
        for managedObject1Child in managedObject1.children! {
            let managedObject2Child = managedObject2.children!.filter({ (managedObject2Child: TestCoreDataEntity4Child) -> Bool in
                XCTAssertEqual(managedObject2Child.childrenParent, managedObject2)
                return managedObject2Child.attribute1 == managedObject1Child.attribute1
            }).first!
            XCTAssertEqual(managedObject1Child.attribute1, managedObject2Child.attribute1)
            XCTAssertEqual(managedObject1Child.attribute2, managedObject2Child.attribute2)
            XCTAssertEqual(managedObject1Child.childrenParent, managedObject1)
        }
        XCTAssertNil(duplicate.attribute1)

    }

}
