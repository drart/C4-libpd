//
//  C4PureData.m
//  C4-libpd
//
//  Created by Adam Tindale on 2013-02-20.
//

#import "C4PureData.h"

@implementation C4PureData
    static C4PureData * mystaticinstance;

-(id) init
{
    if (nil != mystaticinstance)
        @throw [NSException exceptionWithName:@"MultipleDefinitionsOfC4PD" reason:@"Multiple instatiations of C4PureDat are not allowed" userInfo:nil ];
    
    mystaticinstance = self;
    
    audioController = [[PdAudioController alloc] init];
    if ([audioController configureAmbientWithSampleRate:44100 numberChannels:2 mixingEnabled:YES] != PdAudioOK)
    {
        NSLog(@"failed to initialize audio components");
        exit(1); /// bad idea.
    }
    
    patches = [[NSMutableArray alloc] init];
    patchionary = [[NSMutableDictionary alloc] init];
    
    return self;
}

-(id) initWithPatch: (NSString *) patchName
{
    self = [self init];
    [self openPatch:patchName];
    
    return self;
}
-(void) start
{
    audioController.active = YES; // ;dsp on
}

-(void) stop
{
    audioController.active = NO;  // ;dsp off
}

//-------------------------------------------
// Patch Management
//-------------------------------------------

-(id) openPatch: (NSString *) patchName
{    
    PdFile * pdpatch = [PdFile openFileNamed:patchName path:[[NSBundle mainBundle] resourcePath]];
    if (!pdpatch) {
        NSLog(@"Failed to open patch!"); // Gracefully handle failure...
    }
    [patches addObject:pdpatch];

    // FUTURE
    [patchionary setObject:pdpatch forKey: [NSString stringWithFormat:@"%d", [pdpatch dollarZero]]];
    
    return pdpatch;
}

-(void) closePatch: (int) index
{
    [patches[index] closeFile];
    [patches removeObjectAtIndex:index];
    //[file closeFile];
}

-(void) closeThisPatch:(PdFile *)file
{
    if ([patches containsObject:file])
        [self closePatch:[patches indexOfObject:file]];

}

-(void) closePatchFromFilename:(NSString *)fileName
{
    for(PdFile * file in patches)
    {
        if ([file respondsToSelector:NSSelectorFromString(fileName)])
        {
            [self closeThisPatch:file];
        }
    }
}

-(int) numberOfPatchesOpen
{
    return [patches count];
}

-(PdFile *) returnPatch: (int)index
{
    return [patches objectAtIndex:index];
}

-(void) printPatches
{
    for (PdFile * file in patches)
    {
        NSLog(@"C4PD. Patch Id: %d,  Patch Name:  %@", [patches indexOfObject:file], [file baseName]);
    }
}

-(NSArray *) patchNames
{
    int patchCount = [patches count];
    NSMutableArray * patchNameArray = [[NSMutableArray alloc] initWithCapacity:patchCount];
    for (int i = 0 ; i < patchCount; i++)
    {
        [patchNameArray insertObject:[[patches objectAtIndex:i] baseName] atIndex:i];
    }
    return patchNameArray;
}


//-------------------------------------------
// Message Sending
//-------------------------------------------

-(void) sendBang:(NSString *)receiver
{
    [PdBase sendBangToReceiver:receiver];
}

-(void) sendBangToAPatch:(NSString *)receiver toPatch:(int)index
{
    [PdBase sendBangToReceiver:[NSString stringWithFormat:@"%d%@",[[patches objectAtIndex:index] dollarZero],receiver]];
}

-(void) sendFloat:(float)f toReceiver: (NSString * ) r
{
    [PdBase sendFloat:f toReceiver:r];
}

-(void) sendFloatToAPatch: (float) f toReceiver: (NSString *) r toPatch: (int) index
{
    [PdBase sendFloat:f toReceiver: [NSString stringWithFormat:@"%d%@",[[patches objectAtIndex:index] dollarZero],r]];
}

/*
//-------------------------------------------
// MIDI Sending
//-------------------------------------------

-(int) sendNoteOn:(int)channel pitch:(int)pitch velocity:(int)velocity
{
    return [PdBase sendNoteOn:channel pitch:pitch velocity:velocity];
}
- (int)sendControlChange:(int)channel controller:(int)controller value:(int)value;
- (int)sendProgramChange:(int)channel value:(int)value;
- (int)sendPitchBend:(int)channel value:(int)value;
- (int)sendAftertouch:(int)channel value:(int)value;
- (int)sendPolyAftertouch:(int)channel pitch:(int)pitch value:(int)value;
- (int)sendMidiByte:(int)port byte:(int)byte;
- (int)sendSysex:(int)port byte:(int)byte;
- (int)sendSysRealTime:(int)port byte:(int)byte;
*/

@end

