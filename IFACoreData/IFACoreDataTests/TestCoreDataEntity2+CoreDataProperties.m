//
//  TestCoreDataEntity2+CoreDataProperties.m
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 4/3/17.
//  Copyright © 2017 InfoAccent Pty Ltd. All rights reserved.
//

#import "TestCoreDataEntity2+CoreDataProperties.h"

@implementation TestCoreDataEntity2 (CoreDataProperties)

+ (NSFetchRequest<TestCoreDataEntity2 *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TestCoreDataEntity2"];
}

@dynamic attribute1;
@dynamic attribute2;

@end
