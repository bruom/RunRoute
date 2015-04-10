//
//  CorePersistenceManager.h
//  RunRoute
//
//  Created by Bruno Omella Mainieri on 4/8/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CorePersistenceManager : NSObject

+(instancetype)sharedInstance;


#pragma mark - CoreData
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (NSArray *)fetchDataForEntity:(NSString *)entity usingPredicate:(NSPredicate *)predicate;

-(void)saveContext;

@end
