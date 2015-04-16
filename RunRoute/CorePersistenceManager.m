//
//  CorePersistenceManager.m
//  RunRoute
//
//  Created by Bruno Omella Mainieri on 4/8/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import "CorePersistenceManager.h"

@implementation CorePersistenceManager

static id instance;

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[CorePersistenceManager alloc] init];
        
    });
    
    return instance;
}

-(NSArray *)fetchDataForEntity:(NSString *)entity usingPredicate:(NSPredicate *)predicate{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setPredicate:predicate];
    NSEntityDescription *description = [NSEntityDescription entityForName:entity inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:description];
    
    NSError *error;
    NSArray *resultSet = [[self managedObjectContext] executeFetchRequest:request error:&error];
    
    if(error){
        NSLog(@"Error %ld: %@",(long)[error code], [error description]);
        return nil;
    }
    
    return resultSet;
}

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



@end
