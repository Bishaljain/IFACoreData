//
//  NSManagedObject+IFACategory.m
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

#import "NSManagedObject+IFACoreData.h"
#import "IFAPersistenceManager.h"
#import "IFAEntityConfig.h"
#import "NSObject+IFACoreData.h"

@implementation NSManagedObject (IFACoreData)

#pragma mark - Public

-(NSString*)ifa_stringId {
    return [self.ifa_urlId description];
}

-(NSURL*)ifa_urlId {
    return [[self objectID] URIRepresentation];
}

- (NSString*)ifa_labelForKeys:(NSArray*)aKeyArray{
	NSMutableString *label = [NSMutableString string];
	for (int i = 0; i < [aKeyArray count]; i++) {
		if (i>0) {
			if (i==([aKeyArray count]-1)) {
				[label appendString:NSLocalizedStringFromTable(@" and ", @"IFALocalizable", @"final separator in a list of names")];
			}else {
				[label appendString:NSLocalizedStringFromTable(@", ", @"IFALocalizable", @"separator in a list of names")];
			}

		}
		[label appendString:[[IFAPersistenceManager sharedInstance].entityConfig labelForProperty:[aKeyArray objectAtIndex:i] inObject:self]];
	}
	return label;
}

- (BOOL)ifa_validateForSave:(NSError**)anError{
	// does nothing here, but the subclass can override and implement its own custom validation
	return YES;
}

- (void)ifa_willDelete {
	// does nothing here, but the subclass can override it
}

- (void)ifa_didDelete {
	// does nothing here, but the subclass can override it
}

//- (BOOL)ifa_deleteWithValidationAlertPresenter:(UIViewController *)a_validationAlertPresenter {
//    return [[IFAPersistenceManager sharedInstance] deleteObject:self validationAlertPresenter:a_validationAlertPresenter];
//}
//
//- (BOOL)ifa_deleteAndSaveWithValidationAlertPresenter:(UIViewController *)a_validationAlertPresenter {
//    return [[IFAPersistenceManager sharedInstance] deleteAndSaveObject:self validationAlertPresenter:a_validationAlertPresenter];
//}

- (BOOL)ifa_hasValueChangedForKey:(NSString*)a_key{
    return [self.changedValues objectForKey:a_key]!=nil;
}

- (NSNumber*)ifa_minimumValueForProperty:(NSString*)a_propertyName{
    return [self IFA_validationPredicateParameterProperty:a_propertyName string:@"SELF >= "];
}

- (NSNumber*)ifa_maximumValueForProperty:(NSString*)a_propertyName{
    return [self IFA_validationPredicateParameterProperty:a_propertyName string:@"SELF <= "];
}

- (void)ifa_duplicateToTarget:(NSManagedObject *)target ignoringKeys:(NSSet <NSString *> *_Nullable)ignoredKeys {
    [self IFA_duplicateToTarget:target ignoringKeys:ignoredKeys originalParent:nil newParent:nil];
}

+ (instancetype)ifa_instantiate {
	return [[IFAPersistenceManager sharedInstance] instantiate:[self description]];
}

+ (NSMutableArray *)ifa_findAll {
    return [[IFAPersistenceManager sharedInstance] findAllForEntity:[self ifa_entityName]];
}

+ (NSMutableArray *)ifa_findAllIncludingPendingChanges:(BOOL)a_includePendingChanges {
    return [[IFAPersistenceManager sharedInstance] findAllForEntity:[self ifa_entityName] includePendingChanges:a_includePendingChanges];
}

//+ (void)ifa_deleteAllWithValidationAlertPresenter:(UIViewController *)a_validationAlertPresenter {
//    for (NSManagedObject *l_mo in [[IFAPersistenceManager sharedInstance] findAllForEntity:[self ifa_entityName]]) {
//        [l_mo ifa_deleteWithValidationAlertPresenter:a_validationAlertPresenter];
//    }
//}
//
//+ (void)ifa_deleteAllAndSaveWithValidationAlertPresenter:(UIViewController *)a_validationAlertPresenter {
//    [self ifa_deleteAllWithValidationAlertPresenter:a_validationAlertPresenter];
//    [[IFAPersistenceManager sharedInstance] save];
//}

#pragma mark - Private

- (NSNumber*)IFA_validationPredicateParameterProperty:(NSString*)a_propertyName string:(NSString*)a_string{
    NSNumber *l_value = nil;
    for (NSPredicate *l_validationPredicate in [[self ifa_descriptionForProperty:a_propertyName] validationPredicates]) {
        NSString *l_predicateFormat = [l_validationPredicate predicateFormat];
        NSRange l_range = [l_predicateFormat rangeOfString:a_string];
        if (l_range.location!=NSNotFound) {
            NSNumberFormatter *l_numberFormatter = [[NSNumberFormatter alloc] init];
            [l_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            l_value = [l_numberFormatter numberFromString:[l_predicateFormat substringFromIndex:[a_string length]]];
        }
    }
    return l_value;
}

- (void)IFA_duplicateToTarget:(NSManagedObject *)target ignoringKeys:(NSSet <NSString *> *_Nullable)ignoredKeys originalParent:(NSManagedObject *)originalParent newParent:(NSManagedObject *)newParent {
    if (![target isMemberOfClass:[self class]]) {
        return;
    }
    
    NSEntityDescription *entityDescription = self.objectID.entity;
    
    // Set attributes
    NSArray *attributeKeys = entityDescription.attributesByName.allKeys;
    NSMutableDictionary *attributeKeysAndValues = [[self dictionaryWithValuesForKeys:attributeKeys] mutableCopy];
    if (ignoredKeys) {
        [attributeKeysAndValues removeObjectsForKeys:ignoredKeys.allObjects];
    }
    [target setValuesForKeysWithDictionary:attributeKeysAndValues];
    
    // Set relationships
    [entityDescription.relationshipsByName enumerateKeysAndObjectsUsingBlock:^(NSString *relationshipName, NSRelationshipDescription *relationshipDescription, BOOL *stop) {
        id value = [self valueForKey:relationshipName];
        if (!value) {
            return;
        }
        if (relationshipDescription.isToMany) {
            if (!relationshipDescription.inverseRelationship.isToMany) {
                NSString *destinationEntityName = relationshipDescription.destinationEntity.name;
                if ([value isKindOfClass:[NSSet class]]) {
                    NSSet <NSManagedObject *> *childManagedObjects = value;
                    NSMutableSet <NSManagedObject *> *childManagedObjectDuplicates = [NSMutableSet new];
                    [childManagedObjects enumerateObjectsUsingBlock:^(NSManagedObject *childManagedObject, BOOL *innerStop) {
                        NSManagedObject *childManagedObjectDuplicate = [NSClassFromString(destinationEntityName) ifa_instantiate];
                        [childManagedObject IFA_duplicateToTarget:childManagedObjectDuplicate ignoringKeys:nil originalParent:self newParent:target];
                        [childManagedObjectDuplicates addObject:childManagedObjectDuplicate];
                    }];
                    value = childManagedObjectDuplicates;
                } else {
                    return;
                }
            }
        } else {
            if (value && [value isKindOfClass:[NSManagedObject class]] && value == originalParent) {
                value = newParent;
            }
        }
        [target setValue:value forKey:relationshipName];
    }];
}

@end
