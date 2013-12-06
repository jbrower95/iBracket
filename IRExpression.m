//
//  IRExpression.m
//  iRacket
//
//  Created by Justin Brower on 10/4/13.
//  Copyright (c) 2013 Justin Brower. All rights reserved.
//

#import "IRExpression.h"

@implementation IRExpression
@synthesize scope, function, parameters;

- (id)initWithBody:(NSArray *)params scope:(IRScope *)scope
{
    id f = [params objectAtIndex:0];
    
    if ( [f isKindOfClass:[NSArray class]] || [f isKindOfClass:[NSMutableArray class]] ){
        //compound function type...
        IRExpression *subExpression = [[IRExpression alloc] initWithBody:f scope:scope];
        id output = [subExpression evaluate];
        if ([output isKindOfClass:[IRLambda class]])
        {
            //form a lambda expression
        }
            
    }
    else if ([f isKindOfClass:[NSString class]]){
        //regular function
        self.function = [f copy];
    }
    else{
        //throw an error
              
    }
    
    
    return self;
}

- (IRLiteral *)evaluate
{
    //the first step to evaluating an expression is to evaluate its params/components.
    
    // this is what makes the whole recursion thing possible..
    
    NSMutableArray *evalutedParameters = [[NSMutableArray alloc] init];
    for (id a in parameters)
    {
        if([a isKindOfClass:[IRLiteral class]])
        {
                // this one is good and ready for munching!
                
            [evalutedParameters addObject:a];
            continue;
        }
        if([a isKindOfClass:[IRExpression class]])
        {
                
        
            // this expression needs to be evaluted before it can be added...
            IRLiteral *value = [a evaluate];
            [evalutedParameters addObject:a];
        }
        if([a isKindOfClass:[IRLambda class]])
        {
            //one of the parameters is a lambda and so we should continue, because we can't eval it
            continue;
            
            
        }
        
        
    }
    
    
    //list of primitive functions that we can calculate with software
    NSArray *identifiers = [NSArray arrayWithObjects:@"*",@"+",@"-",@"/",@"<",@">",@">=",@"<=",@"%",@"expt",@"log",@"ln",@"=",@"max",@"min",@"sqr",@"sqrt",nil];
    
    
   //our function is located in self.function; check to see if it's a primitive
    int index = -1;
    if ([identifiers containsObject:function])
    {
        index = [identifiers indexOfObject:function];
    }
    if ( index != -1 )
    {
        // if our function is primitive.....
        IRLiteral *output = [[IRLiteral alloc] init];;
        switch (index)
        {
            case 0:
            {
                if ([parameters count] == 0)
                {
                    //wrong number of parameters. send a message
                    
                }
                //zero is times.
                
                float o = 1;
                for ( NSNumber *i in parameters)
                {
                    o = o * [i floatValue];
                }
                
                [output assignNumber:[NSNumber numberWithFloat:o]];
                return output;
                break;
            }
            case 1:
            {
                //plus
                if ([parameters count] == 0)
                {
                    //wrong number of parameters. send a message
                }
                float x = 0;
                for ( NSNumber *i in parameters)
                {
                    x = x + [i floatValue];
                }
                
                
                [output assignNumber:[NSNumber numberWithFloat:x]];
                return output;
                break;
            }
            case 2:
            {
                if ([parameters count] < 2)
                {
                    //wrong number of parameters. send a message
                    
                }
                //minus
                float x = [(NSNumber *)[parameters objectAtIndex:0] floatValue];
                //initialize x to the first parameter
                [parameters removeObjectAtIndex:0];
                for ( NSNumber *i in parameters)
                {
                    x = x - [i floatValue];
                }
                [output assignNumber:[NSNumber numberWithFloat:x]];
                return output;
                break;
            }
            case 3:
            {
                if ([parameters count] != 2)
                {
                    //wrong number of parameters. send a message
                    
                }
                //division
                float a = (float)[(NSNumber *)[parameters objectAtIndex:0] floatValue];
                float b = (float)[(NSNumber *)[parameters objectAtIndex:1] floatValue];
                [output assignNumber:[NSNumber numberWithFloat:1.0*a/b]];
                return output;
                break;
            }
            case 4:
            {
                if ([parameters count] != 2)
                {
                    //wrong number of parameters. send a message
                    
                }
                //less than
                float a = (float)[(NSNumber *)[parameters objectAtIndex:0] floatValue];
                float b = (float)[(NSNumber *)[parameters objectAtIndex:1] floatValue];
                [output assignBool:(a<b)];
                return output;
                break;
            }
            case 5:
            {
                if ([parameters count] != 2)
                {
                    //wrong number of parameters. send a message
                    
                }
                //greater than
                float a = (float)[(NSNumber *)[parameters objectAtIndex:0] floatValue];
                float b = (float)[(NSNumber *)[parameters objectAtIndex:1] floatValue];
                [output assignBool:(a>b)];
                return output;
                break;
            }
            case 6:
            {
                if ([parameters count] != 2)
                {
                    //wrong number of parameters. send a message
                    
                }
                //greater than / equal
                float a = (float)[(NSNumber *)[parameters objectAtIndex:0] floatValue];
                float b = (float)[(NSNumber *)[parameters objectAtIndex:1] floatValue];
                [output assignBool:(a>=b)];
                return output;
                break;
            }
            case 7:
            {
                if ([parameters count] != 2)
                {
                    //wrong number of parameters. send a message
                    
                }
                //less than / equal
                float a = (float)[(NSNumber *)[parameters objectAtIndex:0] floatValue];
                float b = (float)[(NSNumber *)[parameters objectAtIndex:1] floatValue];
                [output assignBool:(a<=b)];
                return output;
                break;
            }
            case 8:
            {
                if ([parameters count] != 2)
                {
                    //wrong number of parameters. send a message
                    
                }
                //mod
                int a = (float)[(NSNumber *)[parameters objectAtIndex:0] intValue];
                int b = (float)[(NSNumber *)[parameters objectAtIndex:1] intValue];
                [output assignNumber:[NSNumber numberWithInt:a%b]];
                return output;
                break;
            }
            case 9:
            {
                if ([parameters count] != 2)
                {
                    //wrong number of parameters. send a message
                    
                }
                //expt
                float a = (float)[(NSNumber *)[parameters objectAtIndex:0] floatValue];
                float b = (float)[(NSNumber *)[parameters objectAtIndex:1] floatValue];
                [output assignNumber:[NSNumber numberWithFloat:pow(a,b)]];
                return output;
                break;
            }
            case 10:
            {
                //log
                if ([parameters count] != 1)
                {
                    //wrong number of parameters. send a message
                    
                }
                float a = (float)[(NSNumber *)[parameters objectAtIndex:0] floatValue];
                [output assignNumber:[NSNumber numberWithFloat:log10(a)]];
                return output;
                break;
            }
            case 11:
            {
                //ln
                if ([parameters count] != 1)
                {
                    //wrong number of parameters. send a message
                    
                }
                float a = (float)[(NSNumber *)[parameters objectAtIndex:0] floatValue];
                [output assignNumber:[NSNumber numberWithFloat:log(a)]];
                return output;
                break;
            }
            case 12:
            {
                //=
                float a = (float)[(NSNumber *)[parameters objectAtIndex:0] floatValue];
                float b = (float)[(NSNumber *)[parameters objectAtIndex:1] floatValue];
                [output assignBool:(a==b)];
                return output;
                break;
            }
            case 13:
            {
                //max
                float a = (float)[(NSNumber *)[parameters objectAtIndex:0] floatValue];
                float b = (float)[(NSNumber *)[parameters objectAtIndex:1] floatValue];
                [output assignNumber:[NSNumber numberWithFloat:((a>b) ? a : b)]];
                return output;
                break;
            }
            case 14:
            {
                //min: can take arbitrary amount of arguments, returns min
                float a = (float)[(NSNumber *)[parameters objectAtIndex:0] floatValue];
                float b = (float)[(NSNumber *)[parameters objectAtIndex:1] floatValue];
                [output assignNumber:[NSNumber numberWithFloat:((a<b) ? a : b)]];
                return output;
                break;
            }
            case 15:
            {
                //sqr
                float a = (float)[(NSNumber *)[parameters objectAtIndex:0] floatValue];
                [output assignNumber:[NSNumber numberWithFloat:pow(a,2)]];
                return output;
                break;
            }
            case 16:
            {
                //sqrt
                float a = (float)[(NSNumber *)[parameters objectAtIndex:0] floatValue];
                [output assignNumber:[NSNumber numberWithFloat:sqrtf(a)]];
                return output;
                break;
            }

        
        }
    }
    else
    {
        // we have to look up how to evaluate this function, it's a lambda.... (or a typo!)
        
        
        
        
        
        
        
        
    }
    @throw [NSException exceptionWithName:@"NSUnevaluablePhrase" reason:@"Got to end up eval without success." userInfo:nil];
    
}

@end
