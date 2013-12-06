//
//  FirstViewController.m
//  iRacket
//
//  Created by Justin Brower on 10/4/13.
//  Copyright (c) 2013 Justin Brower. All rights reserved.
//

#import "FirstViewController.h"
#import "IRHelper.h"
@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize input;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
-(IBAction)runCode:(id)sender
{
    NSString *code = [input text];
    fileHandle = [[NSFileHandle alloc] init];
    IRInterpreter *interpreter = [[IRInterpreter alloc] init];
    [interpreter setParent:nil];
    pipe = [[NSPipe alloc] init];
    
    [[pipe fileHandleForReading] waitForDataInBackgroundAndNotify];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outputReceived:) name:NSFileHandleDataAvailableNotification object:[pipe fileHandleForReading]];
    
    NSArray *parts = [IRHelper explodeByParts:@"(let ((x 15) (y 20)) (+ x y))"];
    
    [self printArray:parts];
    
    
   // [interpreter executeRacket:code output:pipe];
    [input resignFirstResponder];
    output = [[UITextView alloc] initWithFrame:input.frame];
    [output setBackgroundColor:[UIColor grayColor]];
    [output setTextColor:[UIColor blackColor]];
    [output setAlpha:0];
    [self.view addSubview:output];
    [UIView animateWithDuration:0.3 animations:^(void){
        [input setAlpha:0];
        [output setAlpha:1];
        [input setUserInteractionEnabled:NO];
    }];
    
    
}

- (void)printStringArray:(NSArray *)input indent:(int)indent
{

    int i = 0;
    for ( id a in input)
    {
        if ( [a isKindOfClass:[NSString class]]){
            for (int i = 0;i < indent;i++)
            {
                printf("       ");
            }
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
    NSLog(@"%@",input);
    [self printStringArray:input indent:0];
}


- (void)outputReceived:(NSNotification *)notification
{
    NSData *newData = [[pipe fileHandleForReading] availableData];
    
    NSString *stringRep = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
   
    NSLog(@"Output received called...");
    [output setText:[NSString stringWithFormat:@"%@\n%@\n",output.text,stringRep]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
