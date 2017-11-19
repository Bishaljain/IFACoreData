//
//  IFACoreUI - IFAPersistenceManagerTests.m
//  Copyright 2015 InfoAccent Pty Ltd. All rights reserved.
//
//  Created by: Marcelo Schroeder
//

#import "IFACoreDataTestCase.h"
@import IFACoreData;
#import "TestCoreDataEntity1+CoreDataClass.h"
#import "TestCoreDataEntity1+CoreDataProperties.h"
#import "TestCoreDataEntity2+CoreDataClass.h"
#import "TestCoreDataEntity2+CoreDataProperties.h"
@import OCHamcrest;
@import OCMock;

@interface IFAPersistenceManagerTests : IFACoreDataTestCase
@property(nonatomic, strong) IFAPersistenceManager *persistenceManager;
@property(nonatomic, strong) id persistenceManagerPartialMock;
@property(nonatomic, strong) TestCoreDataEntity1 *managedObject1;
@end

@interface SyncSource : NSObject
@property (nonatomic) NSString *property1;  // sync id
@property (nonatomic) NSNumber *property2;
@end

@implementation IFAPersistenceManagerTests{
}

- (void)testCountEntity {
    // when
    NSUInteger count = [self.persistenceManager countEntity:[TestCoreDataEntity1 ifa_entityName]];
    // then
    assertThatUnsignedInteger(count, is(equalToUnsignedInteger(5)));
}

- (void)testCountEntityKeysAndValues {
    // when
    NSUInteger count = [self.persistenceManager countEntity:[TestCoreDataEntity1 ifa_entityName] keysAndValues:@{@"attribute1" : @"value2"}];
    // then
    assertThatUnsignedInteger(count, is(equalToUnsignedInteger(3)));
}

- (void)testCountEntityWithPredicate {
    // given
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"attribute1 = %@"
                                                argumentArray:@[@"value1"]];
    // when
    NSUInteger count = [self.persistenceManager countEntity:[TestCoreDataEntity1 ifa_entityName] withPredicate:predicate];
    // then
    assertThatUnsignedInteger(count, is(equalToUnsignedInteger(2)));
}

- (void)testThatUnsavedEditingChangesReturnsNoWhenThereAreNoUnsavedChanges {
    // when
    BOOL result = self.persistenceManager.unsavedEditingChanges;
    // then
    XCTAssertFalse(result);
}

- (void)testThatUnsavedEditingChangesReturnsYesWhenThereAreChangesInTheMainManagedObjectContext {
    // given
    [self.managedObject1 ifa_setValue:@"changed"
                          forProperty:@"attribute1"];
    // when
    BOOL result = self.persistenceManager.unsavedEditingChanges;
    // then
    XCTAssertTrue(result);
}

- (void)testThatUnsavedEditingChangesReturnsYesWhenThereAreChangesInAPushedChildManagedObjectContext1LevelDown {
    // given
    [self.persistenceManager pushChildManagedObjectContext];
    TestCoreDataEntity1 *managedObject = (TestCoreDataEntity1 *) [self.persistenceManager findById:self.managedObject1.objectID];
    [managedObject ifa_setValue:@"changed"
                    forProperty:@"attribute1"];
    // when
    BOOL result = self.persistenceManager.unsavedEditingChanges;
    // then
    XCTAssertTrue(result);
}

- (void)testThatUnsavedEditingChangesReturnsYesWhenThereAreChangesInAPushedChildManagedObjectContext2LevelsDown {
    // given
    [self.persistenceManager pushChildManagedObjectContext];
    [self.persistenceManager pushChildManagedObjectContext];
    TestCoreDataEntity1 *managedObject = (TestCoreDataEntity1 *) [self.persistenceManager findById:self.managedObject1.objectID];
    [managedObject ifa_setValue:@"changed"
                    forProperty:@"attribute1"];
    // when
    BOOL result = self.persistenceManager.unsavedEditingChanges;
    // then
    XCTAssertTrue(result);
}

- (void)testSyncEntityNamed {

    // Given
    NSString *entityName = @"TestCoreDataEntity2";
    TestCoreDataEntity2 *managedObject1 = (TestCoreDataEntity2 *) [self.persistenceManager instantiate:[TestCoreDataEntity2 ifa_entityName]];
    managedObject1.attribute1 = @"key1";
    managedObject1.attribute2 = @(1);
    TestCoreDataEntity2 *managedObject2 = (TestCoreDataEntity2 *) [self.persistenceManager instantiate:[TestCoreDataEntity2 ifa_entityName]];
    managedObject2.attribute1 = @"key2";
    managedObject2.attribute2 = @(2);
    TestCoreDataEntity2 *managedObject3 = (TestCoreDataEntity2 *) [self.persistenceManager instantiate:[TestCoreDataEntity2 ifa_entityName]];
    managedObject3.attribute1 = @"key3";
    managedObject3.attribute2 = @(3);
    TestCoreDataEntity2 *managedObject4 = (TestCoreDataEntity2 *) [self.persistenceManager instantiate:[TestCoreDataEntity2 ifa_entityName]];
    managedObject4.attribute1 = @"key4";
    managedObject4.attribute2 = @(4);
    TestCoreDataEntity2 *managedObject5 = (TestCoreDataEntity2 *) [self.persistenceManager instantiate:[TestCoreDataEntity2 ifa_entityName]];
    managedObject5.attribute1 = @"key5";
    managedObject5.attribute2 = @(5);
    [self.persistenceManager save];

    SyncSource *syncSource1 = [SyncSource new];
    syncSource1.property1 = @"key2";
    syncSource1.property2 = @(22);

    SyncSource *syncSource2 = [SyncSource new];
    syncSource2.property1 = @"key6";
    syncSource2.property2 = @(66);

    SyncSource *syncSource3 = [SyncSource new];
    syncSource3.property1 = @"key4";
    syncSource3.property2 = @(44);

    // When
    NSArray <TestCoreDataEntity2 *> *result = (NSArray <TestCoreDataEntity2 *> *) [self.persistenceManager syncEntityNamed:entityName
                                                                                                         withSourceObjects:@[syncSource1, syncSource2, syncSource3]
                                                                                                            keyPathMapping:@{@"property1" : @"attribute1", @"property2" : @"attribute2"}
                                                                                                           sourceIdKeyPath:@"property1"
                                                                                                           targetIdKeyPath:@"attribute1"
                                                                                                              mappingBlock:nil];

    // Then
    [self.persistenceManager save];
    TestCoreDataEntity2 *resultManagedObject1 = (TestCoreDataEntity2 *) [self.persistenceManager findSingleByKeysAndValues:@{@"attribute1" : @"key2"}
                                                                                                                    entity:entityName];
    TestCoreDataEntity2 *resultManagedObject2 = (TestCoreDataEntity2 *) [self.persistenceManager findSingleByKeysAndValues:@{@"attribute1" : @"key6"}
                                                                                                                    entity:entityName];
    TestCoreDataEntity2 *resultManagedObject3 = (TestCoreDataEntity2 *) [self.persistenceManager findSingleByKeysAndValues:@{@"attribute1" : @"key4"}
                                                                                                                    entity:entityName];
    XCTAssertEqual([self.persistenceManager countEntity:entityName], 3);
    XCTAssertEqualObjects(resultManagedObject1.attribute2, @(22));
    XCTAssertEqualObjects(resultManagedObject2.attribute2, @(66));
    XCTAssertEqualObjects(resultManagedObject3.attribute2, @(44));
    XCTAssertEqual(result.count, 3);
    resultManagedObject1 = result[0];
    resultManagedObject2 = result[1];
    resultManagedObject3 = result[2];
    XCTAssertEqualObjects(resultManagedObject1.attribute2, @(22));
    XCTAssertEqualObjects(resultManagedObject2.attribute2, @(66));
    XCTAssertEqualObjects(resultManagedObject3.attribute2, @(44));
}

#pragma mark - Overrides

- (void)setUp {
    [super setUp];
    self.persistenceManager = [IFAPersistenceManager new];
    self.persistenceManagerPartialMock = OCMPartialMock(self.persistenceManager);
    OCMStub([self.persistenceManagerPartialMock sharedInstance]).andReturn(self.persistenceManagerPartialMock);
    [self createInMemoryTestDatabaseWithPersistenceManager:self.persistenceManager];
    [self createTestObjects];
}

#pragma mark - Private

- (void)createTestObjects {
    self.managedObject1 = (TestCoreDataEntity1 *) [self.persistenceManager instantiate:[TestCoreDataEntity1 ifa_entityName]];
    self.managedObject1.attribute1 = @"value1";
    TestCoreDataEntity1 *managedObject2 = (TestCoreDataEntity1 *) [self.persistenceManager instantiate:[TestCoreDataEntity1 ifa_entityName]];
    managedObject2.attribute1 = @"value1";
    TestCoreDataEntity1 *managedObject3 = (TestCoreDataEntity1 *) [self.persistenceManager instantiate:[TestCoreDataEntity1 ifa_entityName]];
    managedObject3.attribute1 = @"value2";
    TestCoreDataEntity1 *managedObject4 = (TestCoreDataEntity1 *) [self.persistenceManager instantiate:[TestCoreDataEntity1 ifa_entityName]];
    managedObject4.attribute1 = @"value2";
    TestCoreDataEntity1 *managedObject5 = (TestCoreDataEntity1 *) [self.persistenceManager instantiate:[TestCoreDataEntity1 ifa_entityName]];
    managedObject5.attribute1 = @"value2";
    [self.persistenceManager save];
}

@end

@implementation SyncSource
@end
