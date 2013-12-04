//
//  IRInterpreter.h
//  iRacket
//
//  Created by Justin Brower on 10/4/13.
//  Copyright (c) 2013 Justin Brower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRScope.h"
#import "IRLiteral.h"
#import "IRExpression.h"
typedef enum {IRStatusSuccess = 0, IRStatusError = 1} IRStatus;

/*
 
 IR Interpreter's job is to cycle through text and ascertain
 different IRLambda, IRExpression, and IRScope instances.
 
 The Interpreter then builds a namespace from the current definitions and expressions,
 and then one by one executes all of the expressions in the document.
 
 IRLambda expression definitions WITH NAMES are absorbed into the namespace.
 IRLambda expressions that are passed into a method ABSORB into that namespace and are available for call.
 
 (define) expressions are written into the current namespace -- be them variable asgn. or function asgn.
 
 
 to do: find out why digest block() is being fed weird values. 
 
 also, test out the find-matching-paren function.
 
 
 
 
 
*/
@interface IRInterpreter : NSObject
{

    
    //some interpreters might have a PARENT interpreter. If the parent is nil, this is the main body. Otherwise, it is a (local) block
    IRInterpreter *parent;
    
    IRScope *scope;
    
    NSFileHandle *_output;
    
}
@property (nonatomic, retain) IRInterpreter *parent;
@property (nonatomic, retain) IRScope *scope;

// executeRacket:  Executes inputted code [as string] and outputs any writing or output to STDOUT.txt
// if there is an error, returns IRStatusError, otherwise IRStatusSuccess
//
//
//Input: an NSString* representing the code to be interpretted
//       an NSPipe instance to output to
//Output: IRStatus representing the execution success or failure
- (IRStatus)executeRacket:(NSString *)code output:(NSPipe *)pipe;


- (NSArray *)explodeByParts:(NSString *)anExpression;

@end






