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

//explodes a racket expression into subexpressions and strings
+ (NSArray *)explodeByParts:(NSString *)racketExpression;

//checks to see if the parenthesis in a given statement are valid
+ (BOOL)isParensValid:(NSString *)input;

//finds the location of the matching paren for a given paren
+ (int)findMatchingParens:(NSString *)snippet startAt:(int)start;

@end
