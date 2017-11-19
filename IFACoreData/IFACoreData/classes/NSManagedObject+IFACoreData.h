//
//  NSManagedObject+IFACategory.h
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 30/07/10.
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

@import Foundation;
@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@protocol IFAPersistenceManagerValidationAlertPresenter;

@interface NSManagedObject (IFACoreData)

@property (nonatomic, readonly) NSString *ifa_stringId;
@property (nonatomic, readonly) NSURL *ifa_urlId;

- (NSString*)ifa_labelForKeys:(NSArray*)aKeyArray;
- (BOOL)ifa_validateForSave:(NSError**)anError;
- (void)ifa_willDelete;
- (void)ifa_didDelete;
- (BOOL)ifa_deleteWithValidationAlertPresenter:(id<IFAPersistenceManagerValidationAlertPresenter> _Nullable)a_validationAlertPresenter;
- (BOOL)ifa_deleteAndSaveWithValidationAlertPresenter:(id<IFAPersistenceManagerValidationAlertPresenter> _Nullable)a_validationAlertPresenter;
- (BOOL)ifa_hasValueChangedForKey:(NSString*)a_key;

/**
 * Duplicate a managed object into a given target.
 * This method copies all properties. It also copies relatioships with the exception of 1-to-1 relationships.
 * For many-to-many relationships, it also duplicates the children to a maximum of one hierarchical level.
 * @param target Managed object instance to duplicate into.
 * @param ignoredKeys Keys to ignore when duplicating.
 */
- (void)ifa_duplicateToTarget:(NSManagedObject *)target ignoringKeys:(NSSet <NSString *> *_Nullable)ignoredKeys;

+ (instancetype)ifa_instantiate;
+ (NSMutableArray *)ifa_findAll;
+ (NSMutableArray *)ifa_findAllIncludingPendingChanges:(BOOL)a_includePendingChanges;
+ (void)ifa_deleteAllWithValidationAlertPresenter:(id<IFAPersistenceManagerValidationAlertPresenter> _Nullable)a_validationAlertPresenter;
+ (void)ifa_deleteAllAndSaveWithValidationAlertPresenter:(id<IFAPersistenceManagerValidationAlertPresenter> _Nullable)a_validationAlertPresenter;

@end

NS_ASSUME_NONNULL_END
