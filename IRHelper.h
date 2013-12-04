//
//  IRHelper.h
//  iRacket
//
//  Created by Justin Brower on 12/4/13.
//  Copyright (c) 2013 Justin Brower. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 
 Houses all of the functions that classes commonly use
 
 
 
 
 */
@interface IRHelper : NSObject



+ (NSArray *)explodeByParts:(NSString *)racketExpression;
+ (BOOL)isParensValid:(NSString *)input;
+ (int)findMatchingParens:(NSString *)snippet startAt:(int)start;

@end
