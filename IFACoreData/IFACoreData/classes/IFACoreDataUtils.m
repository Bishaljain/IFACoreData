//
//  IFAUIUtils.m
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 17/06/10.
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

#import "IFACoreDataUtils.h"
@import Foundation;
@import CoreData;
@import IFAFoundation;
#import "NSObject+IFACoreData.h"
#import "IFAPersistenceManager.h"

@implementation IFACoreDataUtils

#pragma mark - Public

+ (void) handleUnrecoverableError:(NSError *)anErrorContainer{
    //TODO: are we losing important info here?
    NSLog(@"Unrecoverable error - description: %@", [anErrorContainer localizedDescription]);
    NSLog(@"Unrecoverable error - failure reason: %@", [anErrorContainer localizedFailureReason]);
    NSArray* detailedErrors = [[anErrorContainer userInfo] objectForKey:NSDetailedErrorsKey];
    if(detailedErrors != nil && [detailedErrors count] > 0) {
        for(NSError* detailedError in detailedErrors) {
            NSLog(@"Unrecoverable error - user info from detailed errors: %@", [detailedError userInfo]);
        }
    }else{
        NSLog(@"Unrecoverable error - user info: %@", [anErrorContainer userInfo]);
    }
    NSAssert(NO, @"Unrecoverable Error: %@", [anErrorContainer localizedDescription]);
}

+ (NSError*) newErrorWithCode:(NSInteger)anErrorCode errorMessage:(NSString*)anErrorMessage{
    NSArray *keyArray = @[NSLocalizedDescriptionKey];
    NSArray *objArray = @[anErrorMessage];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
    return [[NSError alloc] initWithDomain:IFAErrorDomainCommon code:anErrorCode userInfo:userInfo];
}

+ (NSError*) newErrorContainer{
    NSArray *errors = [NSMutableArray array];
    NSArray *keyArray = @[NSDetailedErrorsKey];
    NSArray *objArray = @[errors];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
    return [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSValidationMultipleErrorsError userInfo:userInfo];
}

+ (NSError*) newErrorContainerWithError:(NSError*)anError{
    NSError *errorContainer = [self newErrorContainer];
    [self addError:anError toContainer:errorContainer];
    return errorContainer;
}

+ (void) addError:(NSError*)anError toContainer:(NSError*)anErrorContainer{
    AssertNotNil(anError);
    AssertNotNil(anErrorContainer);
            AssertTrue([anErrorContainer code]==NSValidationMultipleErrorsError);
    id obj = [[anErrorContainer userInfo] valueForKey:NSDetailedErrorsKey];
    AssertNotNil(obj);
    AssertNotNilAndClass(obj, NSMutableArray);
    NSMutableArray *errors = obj;
    [errors addObject:anError];
}
+ (NSString*)stringValueForObject:(id)anObject{
    //    NSLog(@"stringValueForObject: %@", [anObject description]);
    if (anObject==nil) {
        return anObject;
    }else if ([anObject isKindOfClass:[NSString class]]) {
        return anObject;
    }else if ([anObject isKindOfClass:[NSDate class]]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        return [dateFormatter stringFromDate:anObject];
    }else if ([anObject isKindOfClass:[NSManagedObject class]]) {
        return [(NSManagedObject *)anObject ifa_longDisplayValue];
    }else if ([anObject isKindOfClass:[NSSet class]]) {
        if ([anObject count]==0) {
            return @"";
        }else {
            NSString *l_entityName = [((NSManagedObject *) [anObject anyObject]) ifa_entityName];
            NSArray *sortDescriptors = [[IFAPersistenceManager sharedInstance] listSortDescriptorsForEntity:l_entityName
                                                                                        usedForRelationship:YES];
            NSArray *sortedArray = [[anObject allObjects] sortedArrayUsingDescriptors:sortDescriptors];
            NSMutableString *l_string = [NSMutableString string];
            BOOL l_firstTime = YES;
            for (NSManagedObject *l_managedObject in sortedArray) {
                if (l_firstTime) {
                    l_firstTime = NO;
                }else {
                    [l_string appendString:@", "];
                }
                [l_string appendString:[l_managedObject ifa_displayValue]];
            }
            return l_string;
        }
    }else {
        NSAssert(NO, @"Unexpected class: %@", [[anObject class] description]);
        return @"***UNKNOWN***";
    }
}

+ (NSString*)stringValueForBoolean:(BOOL)aBoolean{
    return aBoolean ? NSLocalizedStringFromTable(@"yes", @"IFALocalizable", nil) : NSLocalizedStringFromTable(@"no", @"IFALocalizable", nil);
}

+ (NSString*)onOffStringValueForBoolean:(BOOL)aBoolean{
    return aBoolean ? NSLocalizedStringFromTable(@"on", @"IFALocalizable", nil) : NSLocalizedStringFromTable(@"off", @"IFALocalizable", nil);
}

@end
