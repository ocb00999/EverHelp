//
//  Note.h
//  EverHelp
//
//  Created by Chubin OU on 3/28/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Note : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSNumber *reward;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) PFGeoPoint *location;
@property (strong, nonatomic) NSData *voice;
@property (strong, nonatomic) NSData *image;
@property (strong, nonatomic) NSDate *timelimit;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) PFObject *pfobject;
@property (strong, nonatomic) NSString *title;



@end


