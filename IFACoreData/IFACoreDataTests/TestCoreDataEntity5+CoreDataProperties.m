//
//  TestCoreDataEntity5+CoreDataProperties.m
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 4/3/17.
//  Copyright © 2017 InfoAccent Pty Ltd. All rights reserved.
//

#import "TestCoreDataEntity5+CoreDataProperties.h"

@implementation TestCoreDataEntity5 (CoreDataProperties)

+ (NSFetchRequest<TestCoreDataEntity5 *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TestCoreDataEntity5"];
}

@dynamic attribute1;
@dynamic attribute2;
@dynamic entity4ToOne;
@dynamic entity4ToMany;

@end
