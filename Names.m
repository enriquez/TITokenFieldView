//
//  Names.m
//  TokenFieldExample
//
//  Created by Tom on 06/03/2010.
//  Copyright 2010 Tom Irving. All rights reserved.
//

#import "Names.h"

@implementation Contact

- (id)initWithName:(NSString *)aName andEmail:(NSString *)anEmail {
    if (!(self = [super init])) return nil;
    
    self.name = aName;
    self.email = anEmail;
    
    return self;
}

@end

@implementation Names

+ (NSArray *)listOfNames {
	
	// Generated with http://www.kleimo.com/random/name.cfm
	
	return @[
			@"Samuel Prescott",
			@"Grace Mcburney", 
			@"Rosemary Sells",
			@"Janet Canady",
			@"Gregory Leech",
			@"Geneva Mcguinness",
			@"Billy Shin",
			@"Douglass Fostlick",
			@"Roberta Pedersen",
			@"Earl Rashid",
			@"Matthew Hooks",
			@"Regina Toombs",
			@"Victor Sisneros",
			@"Beverly Covington",
			@"Steve Crews",
			@"Carlos Trejo",
			@"Victoria Delgadillo",
			@"Leah Greenberg",
			@"Deborah Depew",
			@"Jeffery Khoury",
			@"Kathryn Worsham",
			@"Olivia Brownell",
			@"Gary Pritchard",
			@"Susan Cervantes",
			@"Olvera Nipplehead",
			@"Debra Graves",
			@"Albert Deltoro",
			@"Carole Flatt",
			@"Philip Vo",
			@"Phillip Wagstaff",
			@"Xiao Jacquay",
			@"Cleotilde Vondrak",
			@"Carter Redepenning",
			@"Kaycee Wintersmith",
			@"Collin Tick",
			@"Peg Yore",
			@"Cruz Buziak",
			@"Ardath Osle",
			@"Frederic Manusyants",
			@"Collin Politowski",
			@"Hunter Wollyung",
			@"Cruz Gurke",
			@"Sulema Sholette",
			@"Denver Goetter",
			@"Chantay Phothirath",
			@"Arlean Must",
			@"Carlo Henggeler",
			@"Daughrity Maichle",
			@"Zada Wintermantel",
			@"Denver Kubu",
			@"Carlo Guzma",
			@"Emory Swires",
			@"Kirby Manas",
			@"Tobie Spirito",
			@"Lane Defaber",
			@"Sparkle Mousa",
			@"Chantay Palczynski",
			@"Denver Perfater",
			@"Tom Irving"
			];
}

+ (NSArray /* Contact */ *)listOfContacts {
    NSArray *names = [Names listOfNames];
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[names count]];
    
    for (NSString *name in names) {
        //convert Samuel Prescott to samuel@prescott.com
        NSString *email = [[[name lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"@"] stringByAppendingString:@".com"];
        [result addObject:[[Contact alloc] initWithName:name andEmail:email]];
    }
    
    return result;
}

@end