//
//  IRInterpreter.m
//  iRacket
//
//  Created by Justin Brower on 10/4/13.
//  Copyright (c) 2013 Justin Brower. All rights reserved.
//

#import "IRInterpreter.h"
#define IR_VERSION 1.0
@implementation IRInterpreter
@synthesize parent,scope;
- (id)initInterpreter:(BOOL)isChild
{
    self = [super init];
    self.scope = [[IRScope alloc] initWithParent:nil];
  
    return self;
}

- (void)printStringArray:(NSArray *)input indent:(int)indent
{
    for (int i = 0;i < indent;i++)
    {
        printf("       ");
    }
    int i = 0;
    for ( id a in input)
    {
        if ( [a isKindOfClass:[NSString class]]){
            printf("array[%d] = %s\n",i,[a UTF8String]);
        }
        if ( [a isKindOfClass:[NSMutableArray class]] || [a isKindOfClass:[NSArray class]]){
            [self printStringArray:a indent:(indent + 1)];
        }
        i++;
    }
}

- (void)printArray:(NSArray *)input
{
    [self printStringArray:input indent:0];
}



- (IRStatus)executeRacket:(NSString *)code output:(NSPipe *)pipe
{
    printf("IRInterpreter Starting Up... version %.2f\n-----------------------------\n",IR_VERSION);
    
    _output = [pipe fileHandleForWriting];
    NSFileHandle *output = [pipe fileHandleForWriting];
    [_output retain];

    //check to see that the code has valid parentheses
    
    BOOL success = [IRHelper isParensValid:code];
    
    
    if ( !success )
    {
        [output writeData:[@"Error: Number of opening brackets inconsistent with number of closing brackets. Check your syntax, fool." dataUsingEncoding:NSUTF8StringEncoding]];
        
        printf("\n===========\nCode failed initial test\n==============\n\n");
        
        return IRStatusError;
    }

    
    
    printf("Checking scope... ");
    if ( self.scope )
    {
        printf("OK (0)\n");
        
    }
    else{
        printf("\n  Re-initializing... \n");
        self.scope = [[IRScope alloc] initWithParent:nil];
        printf("OK (0)\n");
    }
    
    // begin parsing
    NSArray *parts = [IRHelper explodeByParts:code];
    
    IRExpression *expression = [[IRExpression alloc] initWithBody:parts];
    [expression setScope:self.scope];
    [expression evaluate];
    
    
    
    
    return IRStatusSuccess;
}

- (IRStatus)executeRacketOld:(NSString *)code output:(NSPipe *)pipe
{
    
    
    /*
     here it goes. time to read racket
     
     
    first, check the code for errors
    */
    
    // racket code HAS to be incorrect if # ")" is not equal to "("
    
    //
    
    // a couple of tests:
    
    
    [self printArray:[self explodeByParts:@"(if (> 5 4) 4 5)"]];
    return IRStatusSuccess;
    
    
    
    _output = [pipe fileHandleForWriting];
    NSFileHandle *output = [pipe fileHandleForWriting];
    [_output retain];
    
    printf("IRInterpreter Starting Up... version %.2f\n-----------------------------\n",IR_VERSION);
    
    printf("Checking scope.... ");
    if ( self.scope )
    {
        printf("OK (0)\n");
        
    }
    else{
        printf("Re-initializing...\n");
        self.scope = [[IRScope alloc] initWithParent:nil];
    }
    
    

    BOOL result = [self validateCode:code];
    if ( !result )
    {
        [output writeData:[@"Error: Number of opening brackets inconsistent with number of closing brackets. Check your syntax, fool." dataUsingEncoding:NSUTF8StringEncoding]];
        
        printf("\n===========\nCode failed initial test\n==============\n\n");
        
        return IRStatusError;
    }
    
    BOOL running = YES;
    int pointer_head = 0;
    int opening_parens = 0;
    BOOL inside_parens = NO;
    
    BOOL reading_first = NO;
    
    BOOL last_white = NO;
    
    BOOL comment_mode = NO;
    
    NSMutableString *buffer = [[NSMutableString alloc] init];
    printf("Starting loop...\n");
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    if ( code.length == 0 )
    {
        //this is bad.
        [_output writeData:[@"Error: Empty Source." dataUsingEncoding:NSUTF8StringEncoding]];
        return IRStatusError;
        
    }
    do {
        NSString *current;
        @try{
            current = [code substringWithRange:NSMakeRange(pointer_head,1)];
        }
        @catch(NSException *exception)
        {
            //we've hit a range exception
            [output writeData:[@"Range exception -- aborting.\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        if ( [code characterAtIndex:pointer_head] == '\n' || [current isEqualToString:@" "] ||  pointer_head == [code length])
        {
            //we're in whitespace, just keep going
            printf("Found Whitespace...\n");
            last_white = YES;
            
            //if we have a buffer, it's a variable call
            if ( buffer && [buffer length] > 0)
            {
                id var = [self.scope variableLookup:buffer];
                
                if ( var == nil)
                {
                    printf("Found bad variable '%s'\n",[buffer UTF8String]);
                    // alert the buffer
                    [output writeData:[[NSString stringWithFormat:@"Error: Unknown symbol %@. Aborting...\n",buffer] dataUsingEncoding:NSUTF8StringEncoding]];
                    break;
                }
                //otherwise, we have a lookup
                
                if ( [var isKindOfClass:[IRLiteral class]])
                {
                    //we have a literal: print it!
                    printf("Printing '%s'\n==============\n",[buffer UTF8String]);
                    [var printToHandle:output];
                    printf("\n=================\n");
             
                }
                
                [buffer deleteCharactersInRange:NSMakeRange(0,[buffer length])];
                
                
                
            }
            
            
            pointer_head++;
            continue;
        }
        
        
        
        if (comment_mode)
        {
            //we're in a comment until the next '\n'
            if ( [code characterAtIndex:pointer_head] == '\n')
            {
                //we've hit the end of our comment. proceed...
                comment_mode = NO;
                printf("...and it's over\n");
            }
            
            pointer_head++;
            continue;
        }
        
        
         // read one char from
        if ( [current isEqualToString:@";"])
        {
            //we're leaving a comment...
            comment_mode = YES;
            pointer_head++;
            printf("Comment started.....");
            
            continue;
        }

        NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789-*+_#!@$%^&~`:,.?/\\"];

        if ( !([current rangeOfCharacterFromSet:set].location == NSNotFound))
        {
            printf("Found data...! Read into buffer.\n");
            [buffer appendString:current];
            pointer_head++;
            continue;
            
        }
        
        
        if ( [current isEqualToString:@"("])
        {
            //we're entering a code block;
            
            
            int ending = [self findMatchingParens:code startAt:pointer_head];
            printf("Matching paren for %d located at %d",pointer_head,ending);
            // this will give us the ending point for this block
            
            printf("Range of block: (%d,%d)",pointer_head,[code length] - ending);
            
            NSString *encapsulating_block = [code substringWithRange:NSMakeRange(pointer_head,ending-pointer_head+1)];
            
            printf("Code block about to be digested:\n===================\n%s\n===============\n",[encapsulating_block UTF8String]);
            
            BOOL result = [self validateCode:encapsulating_block];
            if ( !result )
            {
                [output writeData:[@"Error: Number of opening brackets inconsistent with number of closing brackets. Check your syntax, fool.\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
            
            
            //determine what type of block this is. that sort of thing
            IRExpression *t = [self digestBlock:encapsulating_block];
            if ( t )
            {
                //t is now a valid IRExpression
                [self.scope.expressions addObject:t];
                
            }
            
            //move the pointer to the END of this block
            pointer_head += [encapsulating_block length];
            
        }
   
    
        //printf("Reached end of iteration... proceeding to (%d)\n",pointer_head);
        //increment the pointer head
        pointer_head++;
    } while ( pointer_head < [code length] );
    
    //if we have anything leftover in the buffer, read it now:
    
   if ( buffer && buffer.length > 0)
   {
       id var = [self.scope variableLookup:buffer];
       
       if ( var == nil)
       {
           printf("Found bad variable '%s'\n",[buffer UTF8String]);
           // alert the buffer
           [output writeData:[[NSString stringWithFormat:@"Error: Unknown symbol %@. Aborting...\n",buffer] dataUsingEncoding:NSUTF8StringEncoding]];
       }
       else if ([var isKindOfClass:[IRLiteral class]])
       {
           //we have a literal: print it!
           printf("Printing '%s'\n==============\n",[buffer UTF8String]);
           [var printToHandle:output];
           printf("\n=================\n");
       }
       
       [buffer deleteCharactersInRange:NSMakeRange(0,[buffer length])];
       
   }
    
    
    
    
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    
    float runtime = end - start;
    printf("Finished interpretting. Runtime: %f seconds",runtime);
    
    return 0;
}

// finds the matching parenthesis for a parenthesis at a specified position
- (int)findMatchingParens:(NSString *)snippet startAt:(int)start
{
    
    
    //finds the index of the closing parens for a paren, -1 if it doesn't exist
    int index = -1;
    
    
    int counter = 0;
    int position = start;
    while ( position < [snippet length])
    {
        NSString *snip = [snippet substringWithRange:NSMakeRange(position, 1)];
        if ( [snip isEqualToString:@"("])
        {
            counter++;
        }
        else if ([snip isEqualToString:@")"])
        {
            counter--;
            if (counter == 0)
            {
                //we hit our missing paren
                index = position;
                break;
            }
            
        }
        
        
        position++;
    }
 
    
    return index;
}

/*
 
 digestBlock: Purpose:
    
        To create IRExpressions from the blocks in the main body of the program.
 
 
            a) This function is NOT to be used recursively.
 
            b) This function dispatches IRExpressions and calls evaluate on them from the root level
            c) This function should set up scope inheritance
 
        The only functions that should be directly evaluated in here are:
 
            Let, Define, Define-Struct, and Local
 
 
 */

- (IRExpression *)digestBlock:(NSString *)block
{
    printf("Digesting block()......\n");
    // we need to seperate this block into its insides..
    
    //right now it's in the form (x y (z c f h) y ())
    //a block is an IRExpression!
    //
    //but it might be a lambda expression, or a definition, so we have to check that first
    NSString *content = [[block substringFromIndex:1] substringToIndex:[block length]-2];
    
     
    //explode content by whitespaces
    
    NSArray *members = [content componentsSeparatedByString:@" "];
    
    if ([members count] == 0)
    {
        //it's an empty expression
        [_output writeData:[@"Error: expected function after open paranthesis, found nothing." dataUsingEncoding:NSUTF8StringEncoding]];
        return IRStatusError;
    }
    
    //otherwise, continue
    NSString *function = [members objectAtIndex:0];
    
    /*
    //debug
    int i = 0;
    for ( NSString *x in members)
    {
        printf("Parameters[%d] = %s\n",i,[x UTF8String]);
        i++;
        
    }*/
    
    
    //
    if ( [function isEqualToString:@"if"])
    {
        //todo: Implement an if statement
        
        NSMutableArray *expressions = [[NSMutableArray alloc] init];
        
        //crackit expression is stored in content: maybe break it off in there
        
        
        int offset = [content rangeOfString:@"if"].location + 2;
        //offset is the spot to start looking from
        
        printf("Evaluating if() expression...\n");
    
        /*search for question*/
        if ( [[members objectAtIndex:1] hasPrefix:@"("] )
        {
                //then, just like most things in life, this expression is complicated.
            
                //find the index of members[1] and find the matching closing parenthesis
            int question_offset = [content rangeOfString:[members objectAtIndex:1]].location;
            
            int question_end = [self findMatchingParens:content startAt:question_offset];
            
            printf("Finding matching parenthesis for question block...\n");
            if (question_end == -1 )
            {
                //throw an error and end it
                [_output writeData:[@"Error: If statement expected a full question, but there was no closing parenthesis." dataUsingEncoding:NSUTF8StringEncoding]];
                return IRStatusError;
            }
            //we've found the closing paren, digest that block now and get a value:
            printf("Digesting if() question block...\n");
            NSString *if_block = [content substringWithRange:NSMakeRange(question_offset+1, question_end - question_offset-1)];
            //[self digestBlock:if_block];
            printf("If Block: %s\n",[if_block UTF8String]);
            
            NSMutableArray *exploded_if = [NSMutableArray arrayWithArray:[if_block componentsSeparatedByString:@" "]];
            
            IRExpression *expr = [[IRExpression alloc] init];
            [expr setFunction:[exploded_if objectAtIndex:0]];
            [exploded_if removeObjectAtIndex:0];
            [expr setParameters:exploded_if];
            
            IRLiteral *solution = [expr evaluate];
            
            if ( [solution type] == IRLiteralBool)
            {
                if ( [solution getBool] == YES)
                {
                //yes
                    printf("Result of question true! \n");
                
                    
                }
                else{
                //no
                    printf("Result of question false!\n");
                    
                    
                }
                
            }
            else{
                
                // throw an error
                [_output writeData:[@"Error: Expected question of type bool." dataUsingEncoding:NSUTF8StringEncoding]];
                return IRStatusError;
            }
            
            
            
            
        }
        else
        {
            //this is a regular if expression and there's a variable in the question spot
            
            
            
        }
        
        
        
        
        return IRStatusSuccess;
    }
    if ( [function isEqualToString:@"switch"])
    {
        //todo: implement a switch statement
        return IRStatusSuccess;
    }
    
    
    
    if ( [function isEqualToString:@"define-struct"])
    {
        //todo: implement define struct
        
        return IRStatusSuccess;
    }
    
    
    if ([function isEqualToString:@"define"])
    {
        //define -- simple definitions && function definitions
        //should expect two things then
        printf("Define found - altering the namespace!\n");
        if ( [members count] < 2)
        {
            [_output writeData:[@"Error: define expected atleast two arguments." dataUsingEncoding:NSUTF8StringEncoding]];
            return IRStatusError;
            
        }
        
        NSString *symbol = [members objectAtIndex:1];
        NSNumberFormatter *helper = [[NSNumberFormatter alloc] init];
    
        int state = 0;
        int starting_member = 0;
        int ending_member = 0;
        // 0: simple definition
        // 1: string definition
        // 2: function definition
        int counter = 0;
        for ( NSString *i in members)
        {
            if ([i hasPrefix:@"\""] || [i hasPrefix:@"'"])
            {
                //it's a string, congratulations.
                state = 1;
                starting_member = counter;
            }
            if ( [i hasSuffix:@"\""] || [i hasSuffix:@"'"])
            {
                printf("Found string definition");
                ending_member = counter;
                //found the last part of the string
            }
            
            if( [i hasPrefix:@"("] )
            {
                // this is a function definition. just abort in this loop and we'll
                // handle it later
                printf("Found function definition...\n");
                state = 2;
            }
            
            
            
            counter++;
        }
        //if it gets out of this loop without assigning a value to state, we have a simple
        //integer definition
        IRLiteral *value = [[IRLiteral alloc] init];
        
        if ( state == 0)
        {
            //it's either a bool or a number
            
            if ( [members count] != 3)
            {
                printf("Error: Incorrect number of members for a simple definition: expected 2.\n");
                [_output writeData:[@"Error: Define expected two arguments for a simple definition." dataUsingEncoding:NSUTF8StringEncoding]];
                return IRStatusError;
            }
            NSString *datum = [members objectAtIndex:2];
            if ( [helper numberFromString:datum] != nil)
            {
                [value assignNumber:datum];
            } else if ( [datum isEqualToString:@"true"] || [datum isEqualToString:@"false"])
            {
                [value assignBool:[datum isEqualToString:@"true"]];
            } else {
                
                [_output writeData:[[NSString stringWithFormat:@"Error: unrecognizable datum '%@'",datum] dataUsingEncoding:NSUTF8StringEncoding]];
                return IRStatusError;
                //throw an error: datum un-recognizable
                
            }
            
        }
        
        
        if ( state == 1 )
        {
            // it's a string
            NSMutableString *stringReconstruction = [[NSMutableString alloc] init];
            for ( int i = starting_member; i <= ending_member; i++)
            {
                [stringReconstruction appendString:[members objectAtIndex:i]];
                if ( !(i == ending_member))
                {
                [stringReconstruction appendString:@" "];
                }
            }
            //it's a simple definition
            NSString *datum = [members objectAtIndex:2];
            
            [value assignString:stringReconstruction];
            [stringReconstruction release];
        
        }
        if ( state == 2)
        {
            /* TO DO: Implement inline function definition... */
            
        }
            
                
        NSString *datum = [members objectAtIndex:1];
        printf("Scope altered: Variable '%s' is now set.\n",[datum UTF8String]);
        [[self.scope definitions] setObject:value forKey:datum];
            
        
        [helper release];
        
        
        return IRStatusSuccess;
    }

    
    //if we've gotten to this point, we don't know what "function" is.
    //it's not one of the language prims, so lets check the other primset
    
    
    IRExpression *expression = [[IRExpression alloc] init];
    
    [expression setFunction:function];
    
    
    NSMutableArray *explodedParts = [NSMutableArray arrayWithArray:[self explodeByParts:block]];
    [explodedParts removeObjectAtIndex:0];
    [expression setParameters:explodedParts];
    
    //[expression setParameters:];
    
   // [expression evaluate];
    
    /*
     to do, finish implementing generic procedures
     */
    
    
    return IRStatusSuccess;
}

/*
    explodeByParts:
 
        Breaks up an IRExpression like:
            (a b (c d e) f g)
 
        into an array containing:
 
 
            "a" "b" "(c d e)" f g
 
 */
- (NSArray *)explodeByParts:(NSString *)anExpression
{
    
    NSArray *seperatedParts = [anExpression componentsSeparatedByString:@" "];
    printf("Splitting input expression...\n");
    [self printStringArray:seperatedParts];
    NSMutableArray *output = [[NSMutableArray alloc] init];
    NSMutableString *currentBlock = [[NSMutableString alloc] init];
    int insideBlock = 0;
    int paren_count = 0;
    
    // (if true false true) => ["if","true","false","true"]
    
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
                printf("Found closing paren... inside block (%d)\n",paren_count);
                [currentBlock appendFormat:@" %@",part];
                if ( paren_count == 0)
                {
                insideBlock = 0;
                [output addObject:[currentBlock copy]];
                [currentBlock deleteCharactersInRange:NSMakeRange(0, [currentBlock length])];
                }
                
            }else if ( [part isEqualToString:@"("] || [part hasPrefix:@"("])
            {
                
                //increase the paren_count
                paren_count++;
                //put a space and append this
                [currentBlock appendFormat:@" %@",part];
            } else
            {
                // it's not an opening or closing part.. just append it
                [currentBlock appendFormat:@" %@",part];
                
                
            }
        }
        else {
            //we're not inside a block, check to see if we're entering one
            if ( [part isEqualToString:@"("] || [part hasPrefix:@"("])
            {
                //increase the paren_count
                paren_count++;
                printf("Found opening paren...(%d)\n",paren_count);
                
                //clear the buffer and enter a block
                [currentBlock deleteCharactersInRange:NSMakeRange(0,[currentBlock length])];
                //start appending...
                [currentBlock appendFormat:@" %@",part];
                insideBlock = 1;
            } else{
                
                //it's just a generic expression, append it as an expression
                [output addObject:part];
                
                   }
   
             }
            
        
        
    }  
    
    
    return output;
    
}


- (BOOL)validateCode:(NSString *)code
{
    
    NSUInteger count = 0, length = [code length];
    
    NSRange range = NSMakeRange(0, length);
    while(range.location != NSNotFound)
    {
        range = [code rangeOfString: @"(" options:0 range:range];
        if(range.location != NSNotFound)
        {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++;
        }
    }
    int open = (int)count;
    
    
    count = 0;
    range = NSMakeRange(0, length);
    while(range.location != NSNotFound)
    {
        range = [code rangeOfString: @")" options:0 range:range];
        if(range.location != NSNotFound)
        {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++;
        }
    }
    int closed = count;
    if ( open != closed )
    {
        // there is an improper number of brackets in here
        return NO;
        
    }
    return YES;
}

@end
