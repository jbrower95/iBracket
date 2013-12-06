//
//  IRHelper.m
//  iRacket
//
//  Created by Justin Brower on 12/4/13.
//  Copyright (c) 2013 Justin Brower. All rights reserved.
//

#import "IRHelper.h"

@implementation IRHelper


+ (NSArray *)_explodeByParts:(NSString *)racketExpression
{
    NSMutableArray *output = [[NSMutableArray alloc] init];
    
    NSMutableString *stringBuffer = [[NSMutableString alloc] init];
    
    //debug
    printf("Exploding String: %s\n-----------------\n\n",[racketExpression UTF8String]);
    

    
    const char *buffer = [racketExpression cStringUsingEncoding:NSASCIIStringEncoding];
    for ( int i = 0; i < strlen(buffer); i++){
        
        char c = buffer[i];
        
        if ( c == '('){
            //dump the current buffer
            if ([stringBuffer length] > 0)
            {
                printf("Adding array members: %s\n",[stringBuffer UTF8String]);
                [output addObject:[stringBuffer copy]];
                [stringBuffer deleteCharactersInRange:NSMakeRange(0, [stringBuffer length])];
            }
            //recursively explode the child expression
            int location = [IRHelper findMatchingParens:racketExpression startAt:i];
            NSString *substring = [racketExpression substringWithRange:NSMakeRange(i+1,location - i)];
            printf("Located sub-racket expression: Range - [%d,%d]\n",i+1,location-i);
            printf("Expression: %s\n",[substring UTF8String]);
            [output addObject:[IRHelper _explodeByParts:substring]];
            i = location + 1;
            continue;
        }
        if ( c == ')' || c == ' '){
            //whitespace or close paren indicates to empty the current buffer
            if ([stringBuffer length] > 0)
            {
                printf("Emptying the current buffer: %s\n",[stringBuffer UTF8String]);
                [output addObject:[stringBuffer copy]];
                [stringBuffer deleteCharactersInRange:NSMakeRange(0, [stringBuffer length])];
            }
            continue;
        }
        [stringBuffer appendFormat:@"%c",c];
        printf("Current char: %c\n",c);

    }
    
    return output;
    
}

+ (NSArray *)explodeByParts:(NSString *)racketExpression
{
    //a quick helper to get rid of initial parenthesis
    if ([racketExpression hasPrefix:@"("]){
        //chop off an initial open paren. this will only happen at the initial phase because of the procedure's logic
        printf("Trimming initial brace...     ");
        racketExpression = [racketExpression substringFromIndex:1];
        printf("OK.\n\n");
    }
    return [IRHelper _explodeByParts:racketExpression];
}


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
