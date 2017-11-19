//
//  IFACoreUI - IFAPersistentEntityChangeObserverTests.m
//  Copyright 2015 InfoAccent Pty Ltd. All rights reserved.
//
//  Created by: Marcelo Schroeder
//

@import IFACoreData;
#import "IFACoreDataTestCase.h"
#import "TestCoreDataEntity1+CoreDataClass.h"
#import "TestCoreDataEntity1+CoreDataProperties.h"
#import "TestCoreDataEntity2+CoreDataClass.h"
#import "TestCoreDataEntity2+CoreDataProperties.h"
#import "TestCoreDataEntity3+CoreDataClass.h"
#import "TestCoreDataEntity3+CoreDataProperties.h"
@import IFATestingSupport;

@interface IFAPersistentEntityChangeObserverTests : IFACoreDataTestCase <IFAPersistentEntityChangeObserverDelegate>
@property (nonatomic, strong) NSMutableDictionary *delegateCallbacksByClass;
@property(nonatomic, strong) TestCoreDataEntity1 *obj11;
@property(nonatomic, strong) TestCoreDataEntity1 *obj12;
@property(nonatomic, strong) TestCoreDataEntity2 *obj21;
@property(nonatomic, strong) TestCoreDataEntity2 *obj22;
@property(nonatomic, strong) TestCoreDataEntity3 *obj31;
@property(nonatomic, strong) TestCoreDataEntity3 *obj32;
@property(nonatomic, strong) NSArray *classesToObserve;
@property(nonatomic, strong) IFAPersistentEntityChangeObserver *observer;
@property(nonatomic, strong) TestCoreDataEntity1 *obj13;
@end
@interface IFAPersistentEntityChangeObserverDelegateCallbackParameters : NSObject

@property(nonatomic, strong) IFAPersistentEntityChangeObserver *observer;
@property(nonatomic, strong) Class observedClass;
@property(nonatomic, strong) NSSet *insertedObjects;
@property(nonatomic, strong) NSSet *deletedObjects;
@property(nonatomic, strong) NSSet *updatedObjects;
@property(nonatomic, strong) NSDictionary *originalProperties;
@property(nonatomic, strong) NSDictionary *updatedProperties;

@end

@interface IFAPersistentEntityChangeObserverDelegateCallbacks : NSObject

@property(nonatomic, strong) IFAPersistentEntityChangeObserverDelegateCallbackParameters *insertionParameters;
@property(nonatomic, strong) IFAPersistentEntityChangeObserverDelegateCallbackParameters *deletionParameters;
@property(nonatomic, strong) IFAPersistentEntityChangeObserverDelegateCallbackParameters *updateParameters;
@property(nonatomic, strong) IFAPersistentEntityChangeObserverDelegateCallbackParameters *changeParameters;

@end


@implementation IFAPersistentEntityChangeObserverTests{
}

- (void)testInsertionWithMultipleObjectsAndClasses {

    // test objects have been instantiated and saved in setUp

    // given
    NSDictionary *expectedInsertedObjectsByClass = @{
            [[TestCoreDataEntity1 class] description] : @[self.obj12, self.obj11],
            [[TestCoreDataEntity3 class] description] : @[self.obj31, self.obj32],
    };

    // then
    for (Class observedClass in self.classesToObserve) {
        IFAPersistentEntityChangeObserverDelegateCallbacks *delegateCallbacks = [self delegateCallbacksForClass:observedClass];
        [self assertInsertionCallbackParameters:delegateCallbacks.insertionParameters
                               forObservedClass:observedClass
             withExpectedInsertedObjectsByClass:expectedInsertedObjectsByClass];
        assertThat(delegateCallbacks.deletionParameters.observer, is(equalTo(nil)));
        assertThat(delegateCallbacks.updateParameters.observer, is(equalTo(nil)));
        [self assertInsertionCallbackParameters:delegateCallbacks.changeParameters
                               forObservedClass:observedClass
             withExpectedInsertedObjectsByClass:expectedInsertedObjectsByClass];
    }

}

- (void)testDeletionWithMultipleObjectsAndClasses {

    //given
    self.delegateCallbacksByClass = [NSMutableDictionary new];  // Clear delegate callback info from the save done in setUp
    IFAPersistenceManager *persistenceManager = [IFAPersistenceManager sharedInstance];
    [persistenceManager deleteObject:self.obj11
            validationAlertPresenter:nil];
    [persistenceManager deleteObject:self.obj12
            validationAlertPresenter:nil];
    [persistenceManager deleteObject:self.obj31
            validationAlertPresenter:nil];
    NSDictionary *expectedDeletedObjectsByClass = @{
            [[TestCoreDataEntity1 class] description] : @[self.obj11, self.obj12],
            [[TestCoreDataEntity3 class] description] : @[self.obj31],
    };

    // when
    [persistenceManager save];

    // then
    for (Class observedClass in self.classesToObserve) {
        IFAPersistentEntityChangeObserverDelegateCallbacks *delegateCallbacks = [self delegateCallbacksForClass:observedClass];
        assertThat(delegateCallbacks.insertionParameters.observer, is(equalTo(nil)));
        [self assertDeletionCallbackParameters:delegateCallbacks.deletionParameters
                              forObservedClass:observedClass
             withExpectedDeletedObjectsByClass:expectedDeletedObjectsByClass];
        assertThat(delegateCallbacks.updateParameters.observer, is(equalTo(nil)));
        [self assertDeletionCallbackParameters:delegateCallbacks.changeParameters
                              forObservedClass:observedClass
             withExpectedDeletedObjectsByClass:expectedDeletedObjectsByClass];
    }

}

- (void)testUpdateWithMultipleObjectsAndClasses {

    // given
    self.delegateCallbacksByClass = [NSMutableDictionary new];  // Clear delegate callback info from the save done in setUp
    IFAPersistenceManager *persistenceManager = [IFAPersistenceManager sharedInstance];
    self.obj11.attribute2 = @(1111);
    self.obj12.attribute2 = @(1212);
    self.obj31.attribute2 = @(3131);
    NSDictionary *expectedUpdatedObjectsByClass = @{
            [[TestCoreDataEntity1 class] description] : @[self.obj11, self.obj12],
            [[TestCoreDataEntity3 class] description] : @[self.obj31],
    };

    // when
    [persistenceManager save];

    // then
    for (Class observedClass in self.classesToObserve) {
        IFAPersistentEntityChangeObserverDelegateCallbacks *delegateCallbacks = [self delegateCallbacksForClass:observedClass];
        assertThat(delegateCallbacks.insertionParameters.observer, is(equalTo(nil)));
        assertThat(delegateCallbacks.deletionParameters.observer, is(equalTo(nil)));
        [self assertUpdateCallbackParameters:delegateCallbacks.updateParameters
                            forObservedClass:observedClass
           withExpectedUpdatedObjectsByClass:expectedUpdatedObjectsByClass];
        [self assertUpdateCallbackParameters:delegateCallbacks.changeParameters
                            forObservedClass:observedClass
           withExpectedUpdatedObjectsByClass:expectedUpdatedObjectsByClass];
    }

}

- (void)testInsertionDeletionAndUpdateSimultaneouslyForTheSameClass {

    // given
    self.delegateCallbacksByClass = [NSMutableDictionary new];  // Clear delegate callback info from the save done in setUp
    IFAPersistenceManager *persistenceManager = [IFAPersistenceManager sharedInstance];
    self.obj13 = [TestCoreDataEntity1 ifa_instantiate];
    self.obj13.attribute1 = @"obj13";
    self.obj13.attribute2 = @(13);
    [persistenceManager deleteObject:self.obj11
            validationAlertPresenter:nil];
    self.obj12.attribute2 = @(1212);
    NSDictionary *expectedInsertedObjectsByClass = @{
            [[TestCoreDataEntity1 class] description] : @[self.obj13],
    };
    NSDictionary *expectedDeletedObjectsByClass = @{
            [[TestCoreDataEntity1 class] description] : @[self.obj11],
    };
    NSDictionary *expectedUpdatedObjectsByClass = @{
            [[TestCoreDataEntity1 class] description] : @[self.obj12],
    };
    Class observedClass = [TestCoreDataEntity1 class];

    // when
    [persistenceManager save];

    // then
    IFAPersistentEntityChangeObserverDelegateCallbacks *delegateCallbacks = [self delegateCallbacksForClass:observedClass];
    [self assertInsertionCallbackParameters:delegateCallbacks.insertionParameters
                           forObservedClass:observedClass
         withExpectedInsertedObjectsByClass:expectedInsertedObjectsByClass];
    [self assertInsertionCallbackParameters:delegateCallbacks.changeParameters
                           forObservedClass:observedClass
         withExpectedInsertedObjectsByClass:expectedInsertedObjectsByClass];
    [self assertDeletionCallbackParameters:delegateCallbacks.deletionParameters
                          forObservedClass:observedClass
         withExpectedDeletedObjectsByClass:expectedDeletedObjectsByClass];
    [self assertDeletionCallbackParameters:delegateCallbacks.changeParameters
                          forObservedClass:observedClass
         withExpectedDeletedObjectsByClass:expectedDeletedObjectsByClass];
    [self assertUpdateCallbackParameters:delegateCallbacks.updateParameters
                        forObservedClass:observedClass
       withExpectedUpdatedObjectsByClass:expectedUpdatedObjectsByClass];
    [self assertUpdateCallbackParameters:delegateCallbacks.changeParameters
                        forObservedClass:observedClass
       withExpectedUpdatedObjectsByClass:expectedUpdatedObjectsByClass];

}

#pragma mark - Overrides

- (void)setUp {
    [super setUp];
    [self createInMemoryTestDatabase];

    self.delegateCallbacksByClass = [NSMutableDictionary new];

    self.classesToObserve = @[[TestCoreDataEntity1 class], [TestCoreDataEntity3 class]];
    self.observer = [[IFAPersistentEntityChangeObserver alloc] initWithClassesToObserve:self.classesToObserve];
    self.observer.delegate = self;
    [self instantiateTestObjects];
    [[IFAPersistenceManager sharedInstance] save];
}

#pragma mark - IFAPersistentEntityChangeObserverDelegate

- (void)persistentEntityChangeObserver:(IFAPersistentEntityChangeObserver *)persistentEntityChangeObserver
           didObserveInsertionForClass:(Class)observedClass
                   withInsertedObjects:(NSSet *)insertedObjects {
    IFAPersistentEntityChangeObserverDelegateCallbacks *delegateCallbacks = [self delegateCallbacksForClass:observedClass];
    IFAPersistentEntityChangeObserverDelegateCallbackParameters *callbackParameters = delegateCallbacks.insertionParameters;
    callbackParameters.observer = persistentEntityChangeObserver;
    callbackParameters.observedClass = observedClass;
    callbackParameters.insertedObjects = insertedObjects;
    
}

- (void)persistentEntityChangeObserver:(IFAPersistentEntityChangeObserver *)persistentEntityChangeObserver
            didObserveDeletionForClass:(Class)observedClass
                    withDeletedObjects:(NSSet *)deletedObjects
                    originalProperties:(NSDictionary *)originalProperties {
    IFAPersistentEntityChangeObserverDelegateCallbacks *delegateCallbacks = [self delegateCallbacksForClass:observedClass];
    IFAPersistentEntityChangeObserverDelegateCallbackParameters *callbackParameters = delegateCallbacks.deletionParameters;
    callbackParameters.observer = persistentEntityChangeObserver;
    callbackParameters.observedClass = observedClass;
    callbackParameters.deletedObjects = deletedObjects;
    callbackParameters.originalProperties = originalProperties;
}

- (void)persistentEntityChangeObserver:(IFAPersistentEntityChangeObserver *)persistentEntityChangeObserver
              didObserveUpdateForClass:(Class)observedClass
                    withUpdatedObjects:(NSSet *)updatedObjects
                    originalProperties:(NSDictionary *)originalProperties
                     updatedProperties:(NSDictionary *)updatedProperties {
    IFAPersistentEntityChangeObserverDelegateCallbacks *delegateCallbacks = [self delegateCallbacksForClass:observedClass];
    IFAPersistentEntityChangeObserverDelegateCallbackParameters *callbackParameters = delegateCallbacks.updateParameters;
    callbackParameters.observer = persistentEntityChangeObserver;
    callbackParameters.observedClass = observedClass;
    callbackParameters.updatedObjects = updatedObjects;
    callbackParameters.originalProperties = originalProperties;
    callbackParameters.updatedProperties = updatedProperties;
}

- (void)persistentEntityChangeObserver:(IFAPersistentEntityChangeObserver *)persistentEntityChangeObserver
              didObserveChangeForClass:(Class)observedClass
                   withInsertedObjects:(NSSet *)insertedObjects
                        deletedObjects:(NSSet *)deletedObjects
                        updatedObjects:(NSSet *)updatedObjects
                    originalProperties:(NSDictionary *)originalProperties
                     updatedProperties:(NSDictionary *)updatedProperties {
    IFAPersistentEntityChangeObserverDelegateCallbacks *delegateCallbacks = [self delegateCallbacksForClass:observedClass];
    IFAPersistentEntityChangeObserverDelegateCallbackParameters *callbackParameters = delegateCallbacks.changeParameters;
    callbackParameters.observer = persistentEntityChangeObserver;
    callbackParameters.observedClass = observedClass;
    callbackParameters.insertedObjects = insertedObjects;
    callbackParameters.deletedObjects = deletedObjects;
    callbackParameters.updatedObjects = updatedObjects;
    callbackParameters.originalProperties = originalProperties;
    callbackParameters.updatedProperties = updatedProperties;
}

#pragma mark - Private

- (IFAPersistentEntityChangeObserverDelegateCallbacks *)delegateCallbacksForClass:(Class)delegateCallbackClass {
    IFAPersistentEntityChangeObserverDelegateCallbacks *delegateCallbacks = self.delegateCallbacksByClass[[delegateCallbackClass description]];
    if (!delegateCallbacks) {
        delegateCallbacks = [IFAPersistentEntityChangeObserverDelegateCallbacks new];
        self.delegateCallbacksByClass[[delegateCallbackClass description]] = delegateCallbacks;
    } 
    return delegateCallbacks;
}

- (void)instantiateTestObjects {
    self.obj11 = [TestCoreDataEntity1 ifa_instantiate];
    self.obj11.attribute1 = @"obj11";
    self.obj11.attribute2 = @(11);
    self.obj12 = [TestCoreDataEntity1 ifa_instantiate];
    self.obj12.attribute1 = @"obj12";
    self.obj12.attribute2 = @(12);
    self.obj21 = [TestCoreDataEntity2 ifa_instantiate];
    self.obj21.attribute1 = @"obj21";
    self.obj21.attribute2 = @(21);
    self.obj22 = [TestCoreDataEntity2 ifa_instantiate];
    self.obj22.attribute1 = @"obj22";
    self.obj22.attribute2 = @(22);
    self.obj31 = [TestCoreDataEntity3 ifa_instantiate];
    self.obj31.attribute1 = @"obj31";
    self.obj31.attribute2 = @(31);
    self.obj32 = [TestCoreDataEntity3 ifa_instantiate];
    self.obj32.attribute1 = @"obj32";
    self.obj32.attribute2 = @(32);
}

- (void)assertInsertionCallbackParameters:(IFAPersistentEntityChangeObserverDelegateCallbackParameters *)insertionCallbackParameters
                         forObservedClass:(Class)observedClass
       withExpectedInsertedObjectsByClass:(NSDictionary *)expectedInsertedObjectsByClass {
    assertThat(insertionCallbackParameters.observer, is(equalTo(self.observer)));
    assertThat(insertionCallbackParameters.observedClass, is(equalTo(observedClass)));

    NSArray *expectedInsertedObjects = expectedInsertedObjectsByClass[[observedClass description]];
    NSSet *expectedInsertedObjectsSet = [NSSet setWithArray:expectedInsertedObjects];
    XCTAssertEqualObjects(insertionCallbackParameters.insertedObjects, expectedInsertedObjectsSet);
}

- (void)assertDeletionCallbackParameters:(IFAPersistentEntityChangeObserverDelegateCallbackParameters *)deletionCallbackParameters
                        forObservedClass:(Class)observedClass
       withExpectedDeletedObjectsByClass:(NSDictionary *)expectedDeletedObjectsByClass {
    assertThat(deletionCallbackParameters.observer, is(equalTo(self.observer)));
    assertThat(deletionCallbackParameters.observedClass, is(equalTo(observedClass)));

    NSArray *expectedDeletedObjects = expectedDeletedObjectsByClass[[observedClass description]];
    NSSet *expectedDeletedObjectsSet = [NSSet setWithArray:expectedDeletedObjects];
    XCTAssertEqualObjects(deletionCallbackParameters.deletedObjects, expectedDeletedObjectsSet);

    assertThatBool(deletionCallbackParameters.originalProperties.count > 0, isTrue());
}

- (void)assertUpdateCallbackParameters:(IFAPersistentEntityChangeObserverDelegateCallbackParameters *)updateCallbackParameters
                      forObservedClass:(Class)observedClass
     withExpectedUpdatedObjectsByClass:(NSDictionary *)expectedUpdatedObjectsByClass {
    assertThat(updateCallbackParameters.observer, is(equalTo(self.observer)));
    assertThat(updateCallbackParameters.observedClass, is(equalTo(observedClass)));

    NSArray *expectedUpdatedObjects = expectedUpdatedObjectsByClass[[observedClass description]];
    NSSet *expectedUpdatedObjectsSet = [NSSet setWithArray:expectedUpdatedObjects];
    XCTAssertEqualObjects(updateCallbackParameters.updatedObjects, expectedUpdatedObjectsSet);

    assertThatBool(updateCallbackParameters.originalProperties.count > 0, isTrue());
    assertThatBool(updateCallbackParameters.updatedProperties.count > 0, isTrue());
    XCTAssertNotEqualObjects(updateCallbackParameters.originalProperties, updateCallbackParameters.updatedProperties);
}

@end

@implementation IFAPersistentEntityChangeObserverDelegateCallbackParameters
@end

@implementation IFAPersistentEntityChangeObserverDelegateCallbacks

- (IFAPersistentEntityChangeObserverDelegateCallbackParameters *)insertionParameters {
    if (!_insertionParameters) {
        _insertionParameters = [IFAPersistentEntityChangeObserverDelegateCallbackParameters new];
    }
    return _insertionParameters;
}

- (IFAPersistentEntityChangeObserverDelegateCallbackParameters *)deletionParameters {
    if (!_deletionParameters) {
        _deletionParameters = [IFAPersistentEntityChangeObserverDelegateCallbackParameters new];
    }
    return _deletionParameters;
}

- (IFAPersistentEntityChangeObserverDelegateCallbackParameters *)updateParameters {
    if (!_updateParameters) {
        _updateParameters = [IFAPersistentEntityChangeObserverDelegateCallbackParameters new];
    }
    return _updateParameters;
}

- (IFAPersistentEntityChangeObserverDelegateCallbackParameters *)changeParameters {
    if (!_changeParameters) {
        _changeParameters = [IFAPersistentEntityChangeObserverDelegateCallbackParameters new];
    }
    return _changeParameters;
}

@end
