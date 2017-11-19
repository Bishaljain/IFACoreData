//
//  TestCoreDataEntity1+CoreDataProperties.m
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 4/3/17.
//  Copyright © 2017 InfoAccent Pty Ltd. All rights reserved.
//

#import "TestCoreDataEntity1+CoreDataProperties.h"

@implementation TestCoreDataEntity1 (CoreDataProperties)

+ (NSFetchRequest<TestCoreDataEntity1 *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TestCoreDataEntity1"];
}

@dynamic attribute1;
@dynamic attribute2;

@end
