//
//  TestCoreDataEntity4Child+CoreDataProperties.h
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 5/3/17.
//  Copyright © 2017 InfoAccent Pty Ltd. All rights reserved.
//

#import "TestCoreDataEntity4Child+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TestCoreDataEntity4Child (CoreDataProperties)

+ (NSFetchRequest<TestCoreDataEntity4Child *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *attribute1;
@property (nullable, nonatomic, copy) NSNumber *attribute2;
@property (nullable, nonatomic, retain) TestCoreDataEntity4 *childrenParent;
@property (nullable, nonatomic, retain) TestCoreDataEntity4 *childParent;

@end

NS_ASSUME_NONNULL_END
