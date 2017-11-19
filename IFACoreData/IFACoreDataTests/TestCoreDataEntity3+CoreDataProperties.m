//
//  TestCoreDataEntity3+CoreDataProperties.m
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 4/3/17.
//  Copyright © 2017 InfoAccent Pty Ltd. All rights reserved.
//

#import "TestCoreDataEntity3+CoreDataProperties.h"

@implementation TestCoreDataEntity3 (CoreDataProperties)

+ (NSFetchRequest<TestCoreDataEntity3 *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TestCoreDataEntity3"];
}

@dynamic attribute1;
@dynamic attribute2;

@end
