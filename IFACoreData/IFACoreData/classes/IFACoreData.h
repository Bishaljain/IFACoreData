//
//  IFACoreData.h
//  IFACoreData
//
//  Created by Marcelo Schroeder on 16/11/17.
//  Copyright © 2017 Marcelo Schroeder. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for IFACoreData.
FOUNDATION_EXPORT double IFACoreDataVersionNumber;

//! Project version string for IFACoreData.
FOUNDATION_EXPORT const unsigned char IFACoreDataVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <IFACoreData/PublicHeader.h>

#import <IFACoreData/IFAPersistenceManager.h>
#import <IFACoreData/IFAPreferencesManager.h>
#import <IFACoreData/IFAHelpManager.h>
#import <IFACoreData/IFAEnumerationEntity.h>
#import <IFACoreData/IFASystemEntity.h>
#import <IFACoreData/IFACoreDataUtils.h>
#import <IFACoreData/IFACoreDataConstants.h>
#import <IFACoreData/IFAEntityConfig.h>
#import <IFACoreData/NSObject+IFACoreData.h>
#import <IFACoreData/NSManagedObject+IFACoreData.h>
#import <IFACoreData/NSManagedObjectContext+IFACoreData.h>
#import <IFACoreData/IFAPersistenceChangeDetector.h>
#import <IFACoreData/IFAPersistentEntityChangeObserver.h>
