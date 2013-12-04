//
//  IRHelper.m
//  iRacket
//
//  Created by Justin Brower on 12/4/13.
//  Copyright (c) 2013 Justin Brower. All rights reserved.
//

#import "IRHelper.h"

@implementation IRHelper

/*
+ (NSArray *)explodeByParts:(NSString *)racketExpression
{
    NSString *anExpression = racketExpression;
    NSArray *seperatedParts = [anExpression componentsSeparatedByString:@" "];
    
    NSMutableArray *output = [[NSMutableArray alloc] init];
    NSMutableString *currentBlock = [[NSMutableString alloc] init];
    int insideBlock = 0;
    int paren_count = 0;
        
    
    for (NSString *part in seperatedParts)
    {
        if ( insideBlock == 1)
        {
            // we are inside of an expression
            // append
            if ( [part isEqualToString:@")"] || [part hasSuffix:@")"])
            {
                // this is an ending part
                paren_count -= 1;
                [currentBlock appendFormat:@"%@",part];
                if ( paren_count == 0)
                {
                    insideBlock = 0;
                    [output addObject:[currentBlock copy]];
                    [currentBlock deleteCharactersInRange:NSMakeRange(0, [currentBlock length])];
                }
                    
            }
            else if ( [part isEqualToString:@"("] || [part hasPrefix:@"("])
            {
                //increase the paren_count
                paren_count++;
                //put a space and append this
                [currentBlock appendFormat:@"%@",part];
            }
            else
            {
                // it's not an opening or closing part.. just append it
                [currentBlock appendFormat:@"%@",part];
            }
        }
        else
        {
            //we're not inside a block, check to see if we're entering one
            if ( [part isEqualToString:@"("] || [part hasPrefix:@"("])
            {
                //increase the paren_count
                paren_count++;
                //clear the buffer and enter a block
                [currentBlock deleteCharactersInRange:NSMakeRange(0,[currentBlock length])];
                //start appending...
                [currentBlock appendFormat:@"%@",part];
                insideBlock = 1;
            }
            else
            {
                //it's just a generic expression, append it as an expression
                [output addObject:part];
            }
        }
    }
    
    return output;
}*/


+ (NSArray *)explodeByParts:(NSString *)racketExpression
{
    NSMutableArray *output = [[NSMutableArray alloc] init];
    
    NSMutableString *stringBuffer = [[NSMutableString alloc] init];
    
    const char *buffer = [racketExpression cStringUsingEncoding:NSASCIIStringEncoding];
    for ( int i = 0; i < strlen(buffer); i++){
        
        char c = buffer[i];
        
        if ( c == '('){
            //dump the current buffer
            if ([stringBuffer length] > 0)
            {
                [output addObject:[stringBuffer copy]];
                [stringBuffer deleteCharactersInRange:NSMakeRange(0, [stringBuffer length])];
            }
            //recursively explode the child expression
            int location = [IRHelper findMatchingParens:racketExpression startAt:i];
            NSString *substring = [racketExpression substringWithRange:NSMakeRange(i+1,location - i)];
            [output addObject:[IRHelper explodeByParts:substring]];
            i = location + 1;
            continue;
        }
        if ( c == ')'){
            //end of the expression, tail-recursive call
            continue;
        }
        if ( c == ' '){
            //skip whitespace
            continue;
        }
        [stringBuffer appendFormat:@"%c",c];
        
    }
    
    return output;
    
}

// (this (is a) test)



+ (int)findMatchingParens:(NSString *)input startAt:(int)start
{
    const char *buffer = [input cStringUsingEncoding:NSASCIIStringEncoding];
    //the number of open parenthesis
    int upCount = 1;
    for ( int i = (start + 1);i< strlen(buffer);i++){
        if (buffer[i] == ')'){
            upCount--;
        }
        else if (buffer[i] == '('){
            upCount++;
        }
        if (upCount == 0){
            return i;
        }
    }
    return -1;
}

+ (BOOL)isParensValid:(NSString *)input
{
    NSMutableArray *parens = [[NSMutableArray alloc] init];
    //make a stack for the parens
    
    char c;
    int i = 0;
    const char *buffer = [input cStringUsingEncoding:NSASCIIStringEncoding];
    while ((c = buffer[i++])) {
        // iterating using c char
        
        if (c == '('){
            //c is an open paren, open a parenthesis on the stack
            [parens addObject:@"("];
        }
        if ( c == ')'){
            //c is a closed paren, close a paren on the stack
            if ([parens count] == 0){
                return NO;
            }
            else{
                [parens removeLastObject];
            }
        }
        
    }
    if ([parens count] == 0){
        return YES;
    }
    else{
        return NO;
    }
    
}



@end
