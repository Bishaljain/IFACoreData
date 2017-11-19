//
//  IFACoreUiConstants.m
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 24/06/10.
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

#import "IFACoreDataConstants.h"

@implementation IFACoreDataConstants

NSString* const IFACacheKeyEntityConfigDictionary = @"ifa.entityConfigDictionary";

// Notifications
NSString* const IFANotificationPersistentEntityChange = @"ifa.persistentEntityChange";

// Dictionary Keys
NSString* const IFAKeyInsertedObjects = @"ifa.key.insertedObjects";
NSString* const IFAKeyUpdatedObjects = @"ifa.key.updatedObjects";
NSString* const IFAKeyDeletedObjects = @"ifa.key.deletedObjects";
NSString* const IFAKeyUpdatedProperties = @"ifa.key.updatedProperties";
NSString* const IFAKeyOriginalProperties = @"ifa.key.originalProperties";

// Entity Config
NSString* const IFAEntityConfigFormNameDefault = @"main";
NSString* const IFAEntityConfigFormNameCreationShortcut = @"creationShortcut";

// Entity Config
NSString* const IFAInfoPListPreferencesClassName = @"IFAPreferencesClassName";

@end
