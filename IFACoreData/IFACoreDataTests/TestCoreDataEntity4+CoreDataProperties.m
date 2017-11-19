//
//  TestCoreDataEntity4+CoreDataProperties.m
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 5/3/17.
//  Copyright © 2017 InfoAccent Pty Ltd. All rights reserved.
//

#import "TestCoreDataEntity4+CoreDataProperties.h"

@implementation TestCoreDataEntity4 (CoreDataProperties)

+ (NSFetchRequest<TestCoreDataEntity4 *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TestCoreDataEntity4"];
}

@dynamic attribute1;
@dynamic attribute2;
@dynamic name;
@dynamic children;
@dynamic entity5ToMany;
@dynamic entity5ToOne;
@dynamic child;

@end
