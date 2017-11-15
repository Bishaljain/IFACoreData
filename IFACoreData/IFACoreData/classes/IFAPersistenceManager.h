//
//  IFAPersistenceManager.h
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 11/06/10.
//  Copyright 2010 InfoAccent Pty Limited. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <CoreData/CoreData.h>

@class IFAEntityConfig;
@class NSPersistentStore;
@class NSManagedObject;
@class NSFetchRequest;
@class NSManagedObjectID;
@class NSFetchedResultsController;
@protocol IFAPersistenceManagerDelegate;

@interface IFAPersistenceManager : NSObject

@property (nonatomic, weak) id<IFAPersistenceManagerDelegate> delegate;

@property (strong, readonly) NSManagedObjectModel *managedObjectModel;

/**
* Main managed object context with concurrency type NSMainQueueConcurrencyType for exclusive access from the main thread.
*/
@property (strong, readonly) NSManagedObjectContext *managedObjectContext;

/**
* Managed object context with concurrency type NSPrivateQueueConcurrencyType for asynchronous background fetching. Normally used in combination with the dispatchSerialBlock methods from IFAAsynchronousWorkManager and its shared instance.
*/
@property (strong, readonly) NSManagedObjectContext *privateQueueChildManagedObjectContext;

@property (strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, readonly) NSPersistentStore *persistentStore;
@property (strong, readonly) IFAEntityConfig *entityConfig;

@property BOOL isCurrentManagedObjectDirty;

@property BOOL savesInMainThreadOnly;

- (void) resetEditSession;

- (BOOL)validateValue:(id *)a_value forProperty:(NSString *)a_propertyName inManagedObject:a_managedObject alertPresenter:(UIViewController *)a_alertPresenter;
- (BOOL)saveManagedObjectContext:(NSManagedObjectContext*)a_moc;
- (BOOL)saveMainManagedObjectContext;
- (BOOL)saveObject:(NSManagedObject *)aManagedObject validationAlertPresenter:(UIViewController *)a_validationAlertPresenter;
- (BOOL)save;
- (BOOL)deleteObject:(NSManagedObject *)aManagedObject validationAlertPresenter:(UIViewController *)a_validationAlertPresenter;
- (BOOL)deleteAndSaveObject:(NSManagedObject *)aManagedObject validationAlertPresenter:(UIViewController *)a_validationAlertPresenter;
- (void)rollback;
//- (void)undo;

- (NSUInteger)countEntity:(NSString *)entityName;

- (NSUInteger)countEntity:(NSString *)anEntityName
            keysAndValues:(NSDictionary *)aDictionary;

- (NSUInteger)countEntity:(NSString *)entityName
            withPredicate:(NSPredicate *)predicate;

- (BOOL)validateForSave:(NSManagedObject *)aManagedObject validationAlertPresenter:(UIViewController *)a_validationAlertPresenter;

- (NSManagedObject *)instantiate:(NSString *)entityName;

- (NSMutableArray *)findAllForEntity:(NSString *)entityName;

- (NSMutableArray *)findAllForEntity:(NSString *)entityName
               includePendingChanges:(BOOL)a_includePendingChanges;

- (NSMutableArray *)findAllForEntity:(NSString *)entityName
               includePendingChanges:(BOOL)a_includePendingChanges
                  includeSubentities:(BOOL)a_includeSubentities;

- (NSMutableArray *)findAllForEntity:(NSString *)entityName
               includePendingChanges:(BOOL)a_includePendingChanges
                  includeSubentities:(BOOL)a_includeSubentities
                 usedForRelationship:(BOOL)a_usedForRelationship;

- (void)deleteAllAndSaveForEntity:(NSString *)entityName
         validationAlertPresenter:(UIViewController *)a_validationAlertPresenter;

- (void)deleteAllForEntity:(NSString *)a_entityName
  validationAlertPresenter:(UIViewController *)a_validationAlertPresenter;

- (NSManagedObject *) findSystemEntityById:(NSUInteger)anId entity:(NSString *)anEntityName;
- (NSManagedObject *) findByName:(NSString*)aName entity:(NSString *)anEntityName;
- (NSManagedObject *) findById:(NSManagedObjectID*)anObjectId;
- (NSManagedObject *) findByStringId:(NSString*)aStringId;

- (NSManagedObject *)findByUuid:(NSString *)uuid
                     entityName:(NSString *)entityName;

-(NSArray*)findByKeysAndValues:(NSDictionary*)aDictionary entity:(NSString *)anEntityName;
-(NSManagedObject*)findSingleByKeysAndValues:(NSDictionary*)aDictionary entity:(NSString *)anEntityName;
- (BOOL)isSystemEntityForEntity:(NSString*)anEntityName;

- (NSArray*) fetchWithPredicate:(NSPredicate*)aPredicate
						 entity:(NSString*)anEntityName;
- (NSArray*) fetchWithPredicate:(NSPredicate*)aPredicate
						 entity:(NSString*)anEntityName
                          block:(void (^)(NSFetchRequest *aFetchRequest))aBlock;
- (NSArray*) fetchWithPredicate:(NSPredicate*)aPredicate
						 entity:(NSString*)anEntityName
                      countOnly:(BOOL)aCountOnlyFlag;
- (NSArray*) fetchWithPredicate:(NSPredicate*)aPredicate 
				 sortDescriptor:(NSSortDescriptor*)aSortDescriptor
						 entity:(NSString*)anEntityName;
- (NSArray*) fetchWithPredicate:(NSPredicate*)aPredicate 
				 sortDescriptor:(NSSortDescriptor*)aSortDescriptor
						 entity:(NSString*)anEntityName
                          limit:(NSUInteger)aLimit;
- (NSArray*) fetchWithPredicate:(NSPredicate*)aPredicate 
				sortDescriptors:(NSArray*)aSortDescriptorArray
						 entity:(NSString*)anEntityName;
- (NSArray*) fetchWithPredicate:(NSPredicate*)aPredicate 
				sortDescriptors:(NSArray*)aSortDescriptorArray
						 entity:(NSString*)anEntityName
                          limit:(NSUInteger)aLimit;
- (NSArray*) fetchWithPredicate:(NSPredicate*)aPredicate 
				sortDescriptors:(NSArray*)aSortDescriptorArray
						 entity:(NSString*)anEntityName
                          limit:(NSUInteger)aLimit
                      countOnly:(BOOL)aCountOnlyFlag;
- (NSArray*) fetchWithPredicate:(NSPredicate*)aPredicate
                sortDescriptors:(NSArray*)aSortDescriptorArray
                         entity:(NSString*)anEntityName
                          limit:(NSUInteger)aLimit
                      countOnly:(BOOL)aCountOnlyFlag
                          block:(void (^)(NSFetchRequest *aFetchRequest))aBlock;
- (NSManagedObject*) fetchSingleWithPredicate:(NSPredicate*)aPredicate entity:(NSString*)anEntityName;
- (NSManagedObject*) fetchSingleForEntity:(NSString*)anEntityName;
- (id)fetchWithExpression:(NSExpression *)anExpression
               resultType:(NSAttributeType)aResultType
                   entity:(NSString*)anEntityName;

- (NSFetchedResultsController*) fetchControllerWithPredicate:(NSPredicate*)aPredicate 
                                              sortDescriptor:(NSSortDescriptor*)aSortDescriptor
                                                      entity:(NSString*)anEntityName
                                          sectionNameKeyPath:(NSString *)aSectionNameKeyPath
                                                   cacheName:(NSString*)aCacheName;
- (NSFetchedResultsController*) fetchControllerWithPredicate:(NSPredicate*)aPredicate 
                                             sortDescriptors:(NSArray*)aSortDescriptorArray
                                                      entity:(NSString*)anEntityName
                                          sectionNameKeyPath:(NSString *)aSectionNameKeyPath
                                                   cacheName:(NSString*)aCacheName;

- (id) metadataValueForKey:(NSString *)aKey;
- (void) setMetadataValue:(id)aValue forKey:(NSString *)aKey;

- (NSArray *)listSortDescriptorsForEntity:(NSString *)a_entityName;

- (NSArray *)listSortDescriptorsForEntity:(NSString *)a_entityName
                        usedForRelationship:(BOOL)a_usedForRelationship;

/**
* Executes performBlock: on the receiver's managedObjectContext property instance and makes the main managed object context the instance returned by currentManagedObjectContext for the thread executing the block provided.
* @param a_block Block to execute.
*/
- (void)performOnMainManagedObjectContextQueue:(void (^)(void))a_block;

/**
* Executes performBlockAndWait: on the receiver's managedObjectContext property instance and makes the main managed object context the instance returned by currentManagedObjectContext for the thread executing the block provided.
* @param a_block Block to execute.
*/
- (void)performAndWaitOnMainManagedObjectContextQueue:(void (^)(void))a_block;

/**
* Executes performBlock: on the NSManagedObjectContext instance provided and makes that managed object context the instance returned by currentManagedObjectContext for the thread executing the block provided.
* @param a_managedObjectContext Managed object context to send performBlock: to.
* @param a_block Block to execute.
*/
- (void)performOnQueueOfManagedObjectContext:(NSManagedObjectContext *)a_managedObjectContext
                                       block:(void (^)(void))a_block;

/**
* Executes performBlockAndWait: on the NSManagedObjectContext instance provided and makes that managed object context the instance returned by currentManagedObjectContext for the thread executing the block provided.
* @param a_managedObjectContext Managed object context to send performBlockAndWait: to.
* @param a_block Block to execute.
*/
- (void)performAndWaitOnQueueOfManagedObjectContext:(NSManagedObjectContext *)a_managedObjectContext
                                              block:(void (^)(void))a_block;

/**
* Synchronously executes the block provided on the current thread and makes the main managed object context the instance returned by currentManagedObjectContext for the duration of the provided block's execution.
* @param a_block Block to execute.
*/
- (void)performOnCurrentThreadForMainManagedObjectContext:(void (^)(void))a_block;

/**
* Synchronously executes the block provided on the current thread and makes the managed object context provided the instance returned by currentManagedObjectContext for the duration of the provided block's execution.
* @param a_managedObjectContext Current managed object context for the dureation of the provided block's execution.
* @param a_block Block to execute.
*/
- (void)performOnCurrentThreadWithManagedObjectContext:(NSManagedObjectContext *)a_managedObjectContext
                                                 block:(void (^)(void))a_block;

-(NSMutableArray*)managedObjectsForIds:(NSArray*)a_managedObjectIds;

- (BOOL)migratePersistentStoreFromPrivateContainerToGroupContainerIfRequiredWithDatabaseResourceName:(NSString *)a_databaseResourceName
                                                                      managedObjectModelResourceName:(NSString *)a_managedObjectModelResourceName
                                                                    managedObjectModelResourceBundle:(NSBundle *)a_managedObjectModelResourceBundle
                                                                  securityApplicationGroupIdentifier:(NSString *)a_securityApplicationGroupIdentifier
                                                                                               error:(NSError **)a_error;

/**
* Configure the persistence manager instance, including the Core Data stack.
*
* This method can configure either a SQLite store or an in memory store. The type of store will depend on the a_databaseResourceName parameter.
* After completion, the following properties will have been set: managedObjectModel, persistentStoreCoordinator, managedObjectContext, privateQueueChildManagedObjectContext and entityConfig.
*
* @param a_databaseResourceName Name of the SQLite database file for a SQLite store, without the ".sqlite" file suffix. If nil, an in-memory store will be created instead.
* @param a_databaseResourceRelativeFolderPath Relative folder path for the database file. It is ignored if a_databaseResourceAbsoluteFolderPath is provided. If the a_securityApplicationGroupIdentifier parameter is provided, then the folder path is relative to the group's container folder, otherwise it is relative to the default documents folder.
* @param a_databaseResourceAbsoluteFolderPath Absolute folder path for the database file. It takes precedence over the a_databaseResourceRelativeFolderPath parameter.
* @param a_managedObjectModelResourceName Name of Core Data data model resource, without the ".momd" suffix.
* @param a_managedObjectModelResourceBundle Bundle for the data model resource. If nil, main bundle will be used.
* @param a_managedObjectModelVersion Version of the managed object model to use. If not provided, then the current version is used.
* @param a_mergePolicy The merge policy to be adopted by the main managed object context.
* @param a_entityConfigBundle Bundle to load "EntityConfig.plist" from.
* @param a_securityApplicationGroupIdentifier Optional security application group identifier. This is only relevant when a_databaseResourceRelativeFolderPath is provided. See the description of that parameter for more details.
* @param a_muteChangeNotifications Pass YES to mute change notifications, otherwise pass NO.
* @param a_readOnly Pass YES to access the data store as read-only, otherwise pass NO.
*/
- (void)configureWithDatabaseResourceName:(NSString *)a_databaseResourceName
       databaseResourceRelativeFolderPath:(NSString *)a_databaseResourceRelativeFolderPath
       databaseResourceAbsoluteFolderPath:(NSString *)a_databaseResourceAbsoluteFolderPath
           managedObjectModelResourceName:(NSString *)a_managedObjectModelResourceName
         managedObjectModelResourceBundle:(NSBundle *)a_managedObjectModelResourceBundle
                managedObjectModelVersion:(NSNumber *)a_managedObjectModelVersion
                              mergePolicy:(NSMergePolicy *)a_mergePolicy
                       entityConfigBundle:(NSBundle *)a_entityConfigBundle
       securityApplicationGroupIdentifier:(NSString *)a_securityApplicationGroupIdentifier
                  muteChangeNotifications:(BOOL)a_muteChangeNotifications
                                 readOnly:(BOOL)a_readOnly;

- (void)manageDatabaseVersioningChangeWithSystemEntityConfigBundle:(NSBundle *)a_systemEntityConfigBundle
                                                             block:(void (^)(NSUInteger a_oldSystemEntitiesVersion, NSUInteger a_newSystemEntitiesVersion))a_block;

- (void)pushChildManagedObjectContext;
- (void)popChildManagedObjectContext;
- (NSArray *)childManagedObjectContexts;
- (void)removeAllChildManagedObjectContexts;

-(NSManagedObjectContext*)currentManagedObjectContext;

- (NSFetchRequest *)findAllFetchRequest:(NSString *)entityName
                  includePendingChanges:(BOOL)a_includePendingChanges;

- (NSFetchRequest *)findAllFetchRequest:(NSString *)entityName
                  includePendingChanges:(BOOL)a_includePendingChanges
                      usedForRelationship:(BOOL)a_usedForRelationship;

- (NSArray*) executeFetchRequest:(NSFetchRequest*)aFetchRequest;
- (NSMutableArray*) executeFetchRequestMutable:(NSFetchRequest*)aFetchRequest;

- (NSFetchRequest*) fetchRequestWithPredicate:(NSPredicate*)aPredicate
                              sortDescriptors:(NSArray*)aSortDescriptorArray
                                       entity:(NSString*)anEntityName;
- (NSFetchRequest*) fetchRequestWithPredicate:(NSPredicate*)aPredicate
                              sortDescriptors:(NSArray*)aSortDescriptorArray
                                       entity:(NSString*)anEntityName
                                        limit:(NSUInteger)aLimit
                                    countOnly:(BOOL)aCountOnlyFlag;

- (NSMutableArray *)inMemorySortObjects:(NSMutableArray *)objects
                          ofEntityNamed:(NSString *)entityName
                    usedForRelationship:(BOOL)usedForRelationship;

/**
* @returns YES if there are unsaved changes in the main managed object context or in any of the pushed child managed object contexts, otherwise it returns NO.
*/
- (BOOL)unsavedEditingChanges;

/**
 * This method synchronises managed objects of a given entity name with the provided objects.
 * It is useful in situations where a local cache needs to be synchronised with objects coming from a remote server.
 * Any updates, insertions and deletions are performed in the current managed object context. The caller is responsible in saving the context.
 * @param entityName Name of the entity to be synchronised (i.e. the target of the synchronisation).
 * @param sourceObjects Array of source objects to be synchronised with.
 * @param keyPathMapping Dictionary containing the mapping between source key paths (the keys in the dictionary) and target key paths (the values in the dictionary). Do not include the id key path mapping.
 * @param sourceIdKeyPath Key path corresponding to the shared ID in the source object. Used to match the source and target objects for syncing.
 * @param targetIdKeyPath Key path corresponding to the shared ID in the target object. Used to match the source and target objects for syncing.
 * @param mappingBlock Provides an opportunity to perform addition mapping from sourceObject to targetManagedObject.
 * @returns Array containing the synchronised objects respecting the sort order of the source objects.
 */
- (NSArray <NSManagedObject *> *)syncEntityNamed:(NSString *)entityName
							   withSourceObjects:(NSArray *)sourceObjects
								  keyPathMapping:(NSDictionary *)keyPathMapping
								 sourceIdKeyPath:(NSString *)sourceIdKeyPath
								 targetIdKeyPath:(NSString *)targetIdKeyPath
									mappingBlock:(void (^)(id sourceObject, NSManagedObject *targetManagedObject))mappingBlock;

+ (instancetype)sharedInstance;
+ (BOOL)setValidationError:(NSError**)anError withMessage:(NSString*)anErrorMessage;
+ (NSMutableArray*)idsForManagedObjects:(NSArray*)a_managedObjects;

+ (NSSet *)insertedObjectsInPersistentEntityChangeNotificationUserInfo:(NSDictionary *)userInfo;
+ (NSSet *)deletedObjectsInPersistentEntityChangeNotificationUserInfo:(NSDictionary *)userInfo;
+ (NSSet *)updatedObjectsInPersistentEntityChangeNotificationUserInfo:(NSDictionary *)userInfo;
+ (NSDictionary *)originalPropertiesInPersistentEntityChangeNotificationUserInfo:(NSDictionary *)userInfo;
+ (NSDictionary *)updatedPropertiesInPersistentEntityChangeNotificationUserInfo:(NSDictionary *)userInfo;
@end

@protocol IFAPersistenceManagerDelegate <NSObject>

@optional

/**
* This callback offers the chance to have some work done before a CRUD save is performed (e.g. synchronisation of external changes).
* @param persistenceManager The sender.
* @param object The managed object being inserted, updated or deleted.
*/
- (void)  persistenceManager:(IFAPersistenceManager *)persistenceManager
willPerformCrudSaveForObject:(NSManagedObject *)object;

@end
