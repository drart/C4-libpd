C4-libpd
=========

A working attempt to merge libpd with C4. 

Getting Started
================

Download and install C4 - http://www.cocoaforartists.org

- Click on the XCODE project. 
- Select the C4-libpd scheme and run it on either the simulator or your device
- Enjoy!
- Hack!
- Email me. <adam@adamtindale.com>


LOG
========

- Created xcode project
- Added git submodule git://github.com/libpd/libpd.git
- Added to root project
- Changed relative search headers  $(SRCROOT)/../../ libpd
- ibpd-ios as a dependency 
- added AudioToolbox.framework
- Put PDAudioController in C4PureData h/m
- Implemented PDReceiverDelegate protocol for C4Workspace
----- C4PDclass branch -- testing a new build without xcode project put in
- Preprocessor Macro in Build settings -> HAVE_UNISTD_H to get <sys/stat.h> included
- Compiler flags in Build Phase for .m files in libpd -> -fno-objc-arc
- added -w flag for the pd files to suppress the unused variable warnings
-  C4PD static to prevent multiple instantiations of PDAudioController
- Made better demo patches

TODO
======

- Add http://theamazingaudioengine.com/
- Make a real log file
- Manage opening and closing patches (Kind of done)
- create a C4label for every patch opened an allow to quit
- listopen patches should PDbase for open patches, as users can bypass C4PD by calling PDbase directly (or indirectly through PDFile).
