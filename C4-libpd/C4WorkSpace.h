//
//  C4WorkSpace.h
//  C4-libpd
//
//  Created by Adam Tindale on 2013-02-20.
//

/** The C4WorkSpace class is a subclass of C4CanvasController.
 
 The purpose of this class is to provide a simplified interface into which a programmer will build their applications.
 
 Instead of seeing the guts of the C4CanvasController file, C4WorkSpace.m is a much cleaner implementation.
 
 @warning See C4CanvasController for a full list of functionality available in C4WorkSpace.
 */
#import "PdAudioController.h"

@interface C4WorkSpace : C4CanvasController 
@property (strong, nonatomic, readonly) PdAudioController *audioController;
@end
