//
// Created by Marcelo Schroeder on 5/06/15.
// Copyright (c) 2015 InfoAccent Pty Ltd. All rights reserved.
//

#import "IFAPersistentEntityChangeObserver.h"
#import "IFACoreDataConstants.h"
#import "IFAPersistenceManager.h"

@implementation IFAPersistentEntityChangeObserver {

}

#pragma mark - Public

- (instancetype)initWithClassesToObserve:(NSArray *)classesToObserve {
    self = [super init];
    if (self) {
        for (Class classToObserve in classesToObserve) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(onChangeNotification:)
                                                         name:IFANotificationPersistentEntityChange
                                                       object:classToObserve];
        }
    }
    return self;
}

#pragma mark - Overrides

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)onChangeNotification:(NSNotification *)notification {
    id object = notification.object;
    NSDictionary *userInfo = notification.userInfo;
    NSSet *insertedObjects = [IFAPersistenceManager insertedObjectsInPersistentEntityChangeNotificationUserInfo:userInfo];
    NSSet *deletedObjects = [IFAPersistenceManager deletedObjectsInPersistentEntityChangeNotificationUserInfo:userInfo];
    NSSet *updatedObjects = [IFAPersistenceManager updatedObjectsInPersistentEntityChangeNotificationUserInfo:userInfo];
    NSDictionary *originalProperties = [IFAPersistenceManager originalPropertiesInPersistentEntityChangeNotificationUserInfo:userInfo];
    NSDictionary *updatedProperties = [IFAPersistenceManager updatedPropertiesInPersistentEntityChangeNotificationUserInfo:userInfo];
    if (insertedObjects.count && [self.delegate respondsToSelector:@selector(persistentEntityChangeObserver:didObserveInsertionForClass:withInsertedObjects:)]) {
        [self.delegate persistentEntityChangeObserver:self
                          didObserveInsertionForClass:object
                                  withInsertedObjects:insertedObjects];
    }
    if (deletedObjects.count && [self.delegate respondsToSelector:@selector(persistentEntityChangeObserver:didObserveDeletionForClass:withDeletedObjects:originalProperties:)]) {
        [self.delegate persistentEntityChangeObserver:self
                           didObserveDeletionForClass:object
                                   withDeletedObjects:deletedObjects
                                   originalProperties:originalProperties];
    }
    if (updatedObjects.count && [self.delegate respondsToSelector:@selector(persistentEntityChangeObserver:didObserveUpdateForClass:withUpdatedObjects:originalProperties:updatedProperties:)]) {
        [self.delegate persistentEntityChangeObserver:self
                             didObserveUpdateForClass:object
                                   withUpdatedObjects:updatedObjects
                                   originalProperties:originalProperties
                                    updatedProperties:updatedProperties];
    }
    if ([self.delegate respondsToSelector:@selector(persistentEntityChangeObserver:didObserveChangeForClass:withInsertedObjects:deletedObjects:updatedObjects:originalProperties:updatedProperties:)]) {
        [self.delegate persistentEntityChangeObserver:self
                             didObserveChangeForClass:object
                                  withInsertedObjects:insertedObjects
                                       deletedObjects:deletedObjects
                                       updatedObjects:updatedObjects
                                   originalProperties:originalProperties
                                    updatedProperties:updatedProperties];
    }
}

@end
