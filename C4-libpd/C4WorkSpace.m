//
//  C4WorkSpace.m
//  C4-libpd
//
//  Created by Adam Tindale on 2013-02-20.
//

#import "C4WorkSpace.h"
#import "C4PD.h"

@implementation C4WorkSpace
{
    C4PD * pd;
    UITextView * text;
    UISwitch * dspswitch;
    C4Shape * s ;
    int firstpatch;
}

-(void)setup
{
    pd = [[C4PD alloc]init];
    firstpatch = [pd openPatch:@"boop.pd"];
        
    s = [C4Shape rect:CGRectMake(0, 0, 40, 40)];
    
    ///// GUI Setup
    dspswitch = [[UISwitch alloc] initWithFrame:
                            CGRectMake(self.canvas.width - 90, 5, 0, 0)];
    [dspswitch addTarget:self action:@selector(switchIsChanged:)
        forControlEvents:UIControlEventValueChanged];
    [self.canvas addSubview:dspswitch];
    
    C4Label * dsptext = [C4Label labelWithText:@"DSP "];
    dsptext.center = CGPointMake(self.canvas.width - dspswitch.frame.size.width - dsptext.width, dspswitch.center.y);
    dsptext.userInteractionEnabled = NO;
    dsptext.textShadowColor = C4GREY;
    dsptext.textShadowOffset = CGSizeMake(1,1);
    [self.canvas addLabel:dsptext];
    
    /// Set up scrolling text output
    /// text is received from the PD print object via SOMETHING
    text = [[UITextView alloc] initWithFrame:
            CGRectMake(0,0 , self.canvas.width, self.canvas.height)];
    [text resignFirstResponder];
    text.userInteractionEnabled = NO;
    text.editable = NO;
    text.backgroundColor = [UIColor clearColor];
    text.text = [NSString stringWithFormat:@"%@", [NSDate date]];
    [self.canvas addSubview:text];
    
}

#pragma mark Touch Event Handlers
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pointOnScreen = [[touches anyObject] locationInView:self.view];
    [s setCenter:pointOnScreen];
    [self.canvas addSubview:s];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pointOnScreen = [[touches anyObject] locationInView:self.view];
    [s setCenter:pointOnScreen];
    
    [pd sendFloat:1-((float)pointOnScreen.y/self.canvas.height) toReceive:@"freq"];
    [pd sendFloat:(float)pointOnScreen.x/self.canvas.width toReceive:@"filterFreq"];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.canvas removeObject:s];
}

#pragma mark PDReceiverDelegate
/// receives anything that is passed to a [print] object in PD
-(void)receivePrint:(NSString *)message
{
    NSMutableString * str = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@ : %@", [NSDate date] , message]];
    [str appendFormat:@"\r%@", text.text];
    text.text = str;
}



#pragma mark Utilities and Callbacks
- (void)postString:(NSArray *)message
{
    
    NSMutableString * str = [[NSMutableString alloc] init];
    for (int i = 0; i < [message count]; i++)
    {
        [str appendFormat:@"\r%@ : C4PD. Patch ID: %d Patch Name %@", [NSDate date], i,  [message objectAtIndex:i]];
    }
    [str appendFormat:@"\r%@", text.text];
    text.text = str;
}

///// Audio On/Off Switch  /////
- (void) switchIsChanged:(UISwitch *)paramSender
{
    if ([paramSender isEqual:dspswitch ])
    {
        if ([paramSender isOn])
            [pd start];
        else
        {
            [pd stop];
            [pd closePatch:firstpatch];
        }
    }
}

@end