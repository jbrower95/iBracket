//
//  IRScope.h
//  iRacket
//
//  Created by Justin Brower on 10/4/13.
//  Copyright (c) 2013 Justin Brower. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRLambda;
@class IRExpression;
@interface IRScope : NSObject
{
    //every interpreter should have a list of defined variables. A dictionary is a convenient way of representing this
    NSMutableDictionary *definitions;
    
    //scopes may have evaluatable expressions. These are located in a list and executed in order.
    NSMutableArray *expressions;
    
    //represents the children of this scope. Children are able to inherit this scope's variables
    NSMutableArray *children;
    
    //represents the parent of this IRScope.
    IRScope *parent;
}
@property (nonatomic, retain) IRScope *parent;
@property (nonatomic, retain) NSMutableArray *children;
@property (nonatomic, retain) NSMutableDictionary *definitions;
@property (nonatomic, retain) NSMutableArray *expressions;




//takes an identifier string and returns an associated variable
- (id)variableLookup:(NSString *)identifier;
- (id)initWithParent:(IRScope *)aParent;

@end
