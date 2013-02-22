//
//  Names.h
//  TokenFieldExample
//
//  Created by Tom on 06/03/2010.
//  Copyright 2010 Tom Irving. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

- (id)initWithName:(NSString *)aName andEmail:(NSString *)anEmail;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;

@end

@interface Names : NSObject

+ (NSArray *)listOfNames;

//returns list of Contact objects
+ (NSArray /* Contact */ *)listOfContacts;

@end