//
//  C4PD.h
//  C4-libpd
//
//  Created by Adam Tindale on 2013-04-04.
//

#import "C4Object.h"
#import "PdAudioController.h"

@interface C4PD : C4Object //<C4Notification>

-(id) init;
-(int) initWithPatch: (NSString *) patchName;

-(void) start;
-(void) stop;

// Patch Management
-(int) openPatch: (NSString *) patchName;
-(void) closePatch: (int) index;
//-(void) closePatchFromFilename: (NSString *) fileName;
-(int) numberOfPatchesOpen;
//-(void) printPatches;
//-(NSArray *) patchNames;

// Messaging objects
-(void) sendBang:(NSString *)receive;
-(void) sendBangToAPatch:(NSString *)receive toPatch:(int)index;
-(void) sendFloat: (float)f toReceive:(NSString *)receive;
-(void) sendFloatToAPatch:(float)f toReceive:(NSString *)receive toPatch:(int)index;


+(void)sendMessage:(NSString *)message withArguments:(NSArray *)list toReceive:(NSString *)receive;
+ (int)getBlockSize;
+ (int)openAudioWithSampleRate:(int)samplerate inputChannels:(int)inputChannels outputChannels:(int)outputchannels;
+ (void)computeAudio:(BOOL)enable ;
+ (int)processFloatWithInputBuffer:(float *)inputBuffer outputBuffer:(float *)outputBuffer ticks:(int)ticks;

// Send MIDI to PD
/*- (int)sendNoteOn:(int)channel pitch:(int)pitch velocity:(int)velocity;
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
