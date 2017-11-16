//
//  IFAHelpManager.m
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

#import "IFAHelpManager.h"

@interface IFAHelpManager ()
@end

@implementation IFAHelpManager

#pragma mark - Public

- (NSString *)helpForSectionNamed:(NSString *)a_sectionName inFormNamed:(NSString *)a_formName
                       createMode:(BOOL)a_createMode entityNamed:(NSString *)a_entityName {
    NSString *help = nil;
    if (a_createMode) {
        help = [self IFA_helpDescriptionFor:a_entityName formName:a_formName sectionName:a_sectionName createMode:YES];
    }
    if (!help) {
        help = [self IFA_helpDescriptionFor:a_entityName formName:a_formName sectionName:a_sectionName createMode:NO];
    }
    return help;
}

- (NSString *)helpForPropertyName:(NSString *)a_propertyName inEntityName:(NSString *)a_entityName
                            value:(NSString *)a_value {
    NSMutableString *helpTargetId = [NSMutableString stringWithFormat:@"entities.%@.properties.%@", a_entityName, a_propertyName];
    if (a_value) {
        [helpTargetId appendFormat:@".values.%@", a_value];
    }
    NSString *help = [self IFA_helpDescriptionForHelpTargetId:helpTargetId];
    return help;
}

- (NSString *)emptyListHelpForEntityName:(NSString *)a_entityName {
    NSString *helpTargetId = [NSString stringWithFormat:@"entities.%@.list.placeholder", a_entityName];
    NSString *help = [self IFA_helpDescriptionForHelpTargetId:helpTargetId];
    return help;
}

- (NSString *)helpTargetIdForEntityNamed:(NSString *)a_entityName {
    return [NSString stringWithFormat:@"entities.%@", a_entityName];
}

+ (instancetype)sharedInstance {
    static dispatch_once_t c_dispatchOncePredicate;
    static id c_instance = nil;
    dispatch_once(&c_dispatchOncePredicate, ^{
        c_instance = [self new];
    });
    return c_instance;
}

#pragma mark - Private

-(NSString*)IFA_helpStringForKeyPath:(NSString*)a_keyPath{
    NSString *l_string = NSLocalizedStringFromTable(a_keyPath, @"IFAHelpLocalizable", nil);
    return [l_string isEqualToString:a_keyPath] ? nil : l_string;
}

-(NSString*)IFA_helpDescriptionForHelpTargetId:(NSString*)a_helpTargetId {
    return [self IFA_helpStringForKeyPath:[NSString stringWithFormat:@"%@.description", a_helpTargetId]];
}

- (NSString *)IFA_helpDescriptionFor:(NSString *)a_entityName formName:(NSString *)a_formName
                     sectionName:(NSString *)a_sectionName createMode:(BOOL)a_createMode {
    NSObject *mode = a_createMode ? @"create" : @"any";
    NSString *helpTargetId = [NSString stringWithFormat:@"entities.%@.forms.%@.sections.%@.modes.%@", a_entityName,
                                                   a_formName, a_sectionName, mode];
    return [self IFA_helpDescriptionForHelpTargetId:helpTargetId];
}

@end
