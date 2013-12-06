//
//  IRExpression.h
//  iRacket
//
//  Created by Justin Brower on 10/4/13.
//  Copyright (c) 2013 Justin Brower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRLiteral.h"
@class IRLambda;
@class IRScope;
/*
 
 IRExpression:
 
 
 A placeholder for an IRExpression.
 
- Evaluates to an IRLiteral
 
 */
@interface IRExpression : NSObject
{
    NSString *function;
    // the first part of the expression SHOULD be an expression with a name
    //
    // (+ 5 4) ==> @"+"
    
    NSMutableArray *parameters;
    // the parameters in the expression
    //
    //(+ 5 4) ==> array(5,4)
    
    IRScope *scope;
    
    
    
}
@property (nonatomic, retain) IRScope *scope;
@property (nonatomic, retain) NSMutableArray *parameters;
@property (nonatomic, retain) NSString *function;
- (id)evaluate;
// tries to evalute the expression. if it returns something, it'll be a pointer to an object or something of that nature.
// can return either
//
// IRLiteral
// IRLambda

-(id)initWithBody:(NSArray *)params;

@end
