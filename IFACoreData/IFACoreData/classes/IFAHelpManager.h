//
//  IFAHelpManager.h
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 22/03/12.
//  Copyright (c) 2012 InfoAccent Pty Limited. All rights reserved.
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

#import <Foundation/Foundation.h>

/**
* Manages help mode and assists with retrieving help text used throughout the app.
*/
@interface IFAHelpManager : NSObject

/**
* Help text for section obtained from IFAHelpLocalizable.strings.
* IFAHelpLocalizable.strings entry key format:
*   entities.<entityName>.forms.<formName>.sections.<sectionName>.modes.(any|create).description
* @param a_sectionName Name of the section the help is for.
* @param a_formName Name of the form the help is for.
* @param a_entityName Name of the persistent entity the help is for.
* @param a_createMode Whether the help is for creation mode or not.
* @returns Form section help in plain text format.
*/
- (NSString *)helpForSectionNamed:(NSString *)a_sectionName
                      inFormNamed:(NSString *)a_formName
                       createMode:(BOOL)a_createMode
                      entityNamed:(NSString *)a_entityName;

/**
* Help text for property obtained from IFAHelpLocalizable.strings.
* IFAHelpLocalizable.strings entry key format at property level:
*   entities.<entityName>.properties.<propertyName>.description
* IFAHelpLocalizable.strings entry key format at property value level:
*   entities.<entityName>.properties.<propertyName>.values.<value>.description
* @param a_propertyName Name of the property to get the help text for.
* @param a_entityName Name of entity the property belongs to.
* @param a_value Optional. Provide if help for specific value is required. This is useful for input controls such as switches and pickers, where the help text may change depending on the value selected by the user.
* @returns Property help in plain text format.
*/
- (NSString *)helpForPropertyName:(NSString *)a_propertyName
                     inEntityName:(NSString *)a_entityName
                            value:(NSString *)a_value;

/**
* Help text for empty list obtained from IFAHelpLocalizable.strings.
* IFAHelpLocalizable.strings entry key format:
*   entities.<entityName>.list.placeholder.description
* @param a_entityName Name of the persistent entity the help text is for.
* @returns Empty list help in plain text format.
*/
- (NSString *)emptyListHelpForEntityName:(NSString *)a_entityName;

/**
* Provides the key prefix used for persistent entity related entries in IFAHelpLocalizable.strings.
* @param a_entityName Name of the entity to provide the help target ID for.
* @returns Help target ID for the given entity name.
*/
- (NSString *)helpTargetIdForEntityNamed:(NSString *)a_entityName;

+ (instancetype)sharedInstance;

@end
