//
//  C4WorkSpace.m
//  C4-libpd
//
//  Created by Adam Tindale on 2013-02-20.
//  Copyright (c) 2013 Adam Tindale. All rights reserved.
//

#import "C4WorkSpace.h"
#import "C4PureData.h"

@implementation C4WorkSpace
{
    C4PureData *pd;
    C4PureData *pd2;
    PdFile * ff;
    UITextView * text;
    C4Shape * s ;

}

-(void)setup {

    // C4PDprint receives print messages from PD
    [PdBase setDelegate:self];
    
    /// Set up scrolling text output
    /// text is received from the PD print object via PDReceiverDelegate method below
    text = [[UITextView alloc] initWithFrame:
            CGRectMake(0,0 , self.canvas.width, self.canvas.height)];
    [text resignFirstResponder];
    text.userInteractionEnabled = NO;
    text.editable = NO;
    text.backgroundColor = [UIColor clearColor];
    text.text = [NSString stringWithFormat:@"%@", [NSDate date]];
    [self.canvas addSubview:text];
    

    
    pd = [[C4PureData alloc] initWithPatch:@"test.pd"];
    
    ff = [pd openPatch:@"test2.pd"]; // open another patch!!!
    
    [pd printPatches];
    
    for (int i = [pd numberOfPatchesOpen]-1 ; i >= 0 ; i--)
    {
        [pd closePatch:i];
    }
    NSLog(@"Number of patches open: %d", [pd numberOfPatchesOpen]);
    
    sleep(1);
    
    [pd openPatch:@"test2.pd"];
    [PdBase sendFloat:0.4 toReceiver:@"left"];
    [pd sendFloatToAPatch:0.4 toReceiver:@"right" toPatch:0];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (nil == s)
        s = [C4Shape rect:CGRectMake(0, 0,100, 100)];
    
    CGPoint pointOnScreen = [[touches anyObject] locationInView:self.view];
    
    [s setCenter:pointOnScreen];
    [s setFillColor:[UIColor blackColor]];
    [s setStrokeColor:[UIColor grayColor]];
    [self.canvas addShape:s];
    
    [pd openPatch:@"test2.pd"]; // [self.pd openPatch]
    [pd printPatches];  // [self.pd printPatches] ??
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pointOnScreen = [[touches anyObject] locationInView:self.view];
    [s setCenter:pointOnScreen];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.canvas removeObject:s];
}

///// PDReceiverDelegate  /////

-(void)receivePrint:(NSString *)message
{
    NSMutableString * s = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@ : %@", [NSDate date] , message]];
    [s appendFormat:@"\r%@", text.text];
    text.text = s;
}
///// PDListener /////
- (void)receiveBangFromSource:(NSString *)source
{
    [self receivePrint:source];
}

- (void)receiveFloat:(float)received fromSource:(NSString *)source
{
    [self receivePrint:source];
}
- (void)receiveSymbol:(NSString *)symbol fromSource:(NSString *)source
{
    [self receivePrint:source];
}
- (void)receiveList:(NSArray *)list fromSource:(NSString *)source
{
    [self receivePrint:source];
}
- (void)receiveMessage:(NSString *)message withArguments:(NSArray *)arguments fromSource:(NSString *)source
{
    [self receivePrint:source];
}

@end


