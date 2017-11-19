//
// Created by Marcelo Schroeder on 5/06/15.
// Copyright (c) 2015 InfoAccent Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IFAPersistentEntityChangeObserverDelegate;

/**
* Convenience class (with corresponding delegate protocol) that makes it easier to observe persistence changes via the underlying IFANotificationPersistentEntityChange notification.
*/
@interface IFAPersistentEntityChangeObserver : NSObject

@property (nonatomic, weak) id<IFAPersistentEntityChangeObserverDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;

/**
* @param classesToObserve Array containing Class instances indicating which NSManagedObject subclasses will be observed for changes (i.e. insertions, deletions and updates).
*/
- (instancetype)initWithClassesToObserve:(NSArray *)classesToObserve NS_DESIGNATED_INITIALIZER;

@end

@protocol IFAPersistentEntityChangeObserverDelegate <NSObject>

@optional

/**
* Called to notify of one or more object insertions for a given managed object class.
* @param persistentEntityChangeObserver The sender.
* @param observedClass The observed managed object class.
* @param insertedObjects NSManagedObject instances of objects that have been inserted (if any). This parameter corresponds to the IFAKeyInsertedObjects key in the underlying IFANotificationPersistentEntityChange notification's userInfo.
*/
- (void)persistentEntityChangeObserver:(IFAPersistentEntityChangeObserver *)persistentEntityChangeObserver
           didObserveInsertionForClass:(Class)observedClass
                   withInsertedObjects:(NSSet *)insertedObjects;

/**
* Called to notify of one or more object deletions for a given managed object class.
* @param persistentEntityChangeObserver The sender.
* @param observedClass The observed managed object class.
* @param deletedObjects NSManagedObject instances of objects that have been deleted (if any). This parameter corresponds to the IFAKeyDeletedObjects key in the underlying IFANotificationPersistentEntityChange notification's userInfo.
* @param originalProperties NSDictionary instance where the key is the string version of the deleted or updated managed object and the value is an NSDictionary instance containing the properties and their original values. This parameter corresponds to the IFAKeyOriginalProperties key in the underlying IFANotificationPersistentEntityChange notification's userInfo.
*/
- (void)persistentEntityChangeObserver:(IFAPersistentEntityChangeObserver *)persistentEntityChangeObserver
            didObserveDeletionForClass:(Class)observedClass
                    withDeletedObjects:(NSSet *)deletedObjects
                    originalProperties:(NSDictionary *)originalProperties;

/**
* Called to notify of one or more object updates for a given managed object class.
* @param persistentEntityChangeObserver The sender.
* @param observedClass The observed managed object class.
* @param updatedObjects NSManagedObject instances of objects that have been updated (if any). This parameter corresponds to the IFAKeyUpdatedObjects key in the underlying IFANotificationPersistentEntityChange notification's userInfo.
* @param originalProperties NSDictionary instance where the key is the string version of the deleted or updated managed object and the value is an NSDictionary instance containing the properties and their original values. This parameter corresponds to the IFAKeyOriginalProperties key in the underlying IFANotificationPersistentEntityChange notification's userInfo.
* @param updatedProperties NSDictionary instance where the key is the string version of the updated managed object and the value is an NSDictionary instance containing the updated properties and their updated values. This parameter corresponds to the IFAKeyUpdatedProperties key in the underlying IFANotificationPersistentEntityChange notification's userInfo.
*/
- (void)persistentEntityChangeObserver:(IFAPersistentEntityChangeObserver *)persistentEntityChangeObserver
              didObserveUpdateForClass:(Class)observedClass
                    withUpdatedObjects:(NSSet *)updatedObjects
                    originalProperties:(NSDictionary *)originalProperties
                     updatedProperties:(NSDictionary *)updatedProperties;

/**
* Called to notify of one or more object insertions, deletions or updates for a given managed object class.
* @param persistentEntityChangeObserver The sender.
* @param observedClass The observed managed object class.
* @param insertedObjects NSManagedObject instances of objects that have been inserted (if any). This parameter corresponds to the IFAKeyInsertedObjects key in the underlying IFANotificationPersistentEntityChange notification's userInfo.
* @param deletedObjects NSManagedObject instances of objects that have been deleted (if any). This parameter corresponds to the IFAKeyDeletedObjects key in the underlying IFANotificationPersistentEntityChange notification's userInfo.
* @param updatedObjects NSManagedObject instances of objects that have been updated (if any). This parameter corresponds to the IFAKeyUpdatedObjects key in the underlying IFANotificationPersistentEntityChange notification's userInfo.
* @param originalProperties NSDictionary instance where the key is the string version of the deleted or updated managed object and the value is an NSDictionary instance containing the properties and their original values. This parameter corresponds to the IFAKeyOriginalProperties key in the underlying IFANotificationPersistentEntityChange notification's userInfo.
* @param updatedProperties NSDictionary instance where the key is the string version of the updated managed object and the value is an NSDictionary instance containing the updated properties and their updated values. This parameter corresponds to the IFAKeyUpdatedProperties key in the underlying IFANotificationPersistentEntityChange notification's userInfo.
*/
- (void)persistentEntityChangeObserver:(IFAPersistentEntityChangeObserver *)persistentEntityChangeObserver
              didObserveChangeForClass:(Class)observedClass
                   withInsertedObjects:(NSSet *)insertedObjects
                        deletedObjects:(NSSet *)deletedObjects
                        updatedObjects:(NSSet *)updatedObjects
                    originalProperties:(NSDictionary *)originalProperties
                     updatedProperties:(NSDictionary *)updatedProperties;

@end