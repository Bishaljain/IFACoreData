//
//  TestCoreDataEntity4Child+CoreDataProperties.m
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 5/3/17.
//  Copyright © 2017 InfoAccent Pty Ltd. All rights reserved.
//

#import "TestCoreDataEntity4Child+CoreDataProperties.h"

@implementation TestCoreDataEntity4Child (CoreDataProperties)

+ (NSFetchRequest<TestCoreDataEntity4Child *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TestCoreDataEntity4Child"];
}

@dynamic attribute1;
@dynamic attribute2;
@dynamic childrenParent;
@dynamic childParent;

@end
