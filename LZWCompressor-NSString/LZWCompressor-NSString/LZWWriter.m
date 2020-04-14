// Writer source file that returns a byte when appropriate.

#import "LZWWriter.h"
@interface LZWWriter()
- (Buffer) getBuffer; //Returns a Buffer Struct.
@end

@implementation LZWWriter

- (id) init{
    self = [super init];
    self.buf = [self getBuffer];
    return self;
}

- (unsigned char) writeValue: (unsigned short) value withSize: (unsigned char) size {
    //Returns a Byte when appropriate.
    unsigned char sizeCopy = size;
    unsigned short valueCopy = value;
    unsigned char outputCode = 0;
    while(sizeCopy > 8){
        unsigned char need = 8 - self.buf.containerSize;
        unsigned char add = valueCopy >> (sizeCopy - need);
        outputCode = self.buf.container << need;
        outputCode = outputCode | add;
        valueCopy = valueCopy << (16 - sizeCopy + need);
        valueCopy = valueCopy >> (16 - sizeCopy + need);
        sizeCopy = sizeCopy - need;
        self.buf = [self getBuffer];
    }
    Buffer newBuffer = [self getBuffer];
    newBuffer.container = (unsigned char) valueCopy;
    newBuffer.containerSize = sizeCopy;
    self.buf = newBuffer;
    return outputCode;
}

- (unsigned char) clearGutter{
   //Returns left-over bits and/or Final Byte.
    unsigned char returnValue = self.buf.container;
    self.buf = [self getBuffer];
    return returnValue;
}

- (Buffer) getBuffer{
    //Returns a Buffer Struct.
    Buffer buffer;
    buffer.container = 0;
    buffer.containerSize = 0;
    return buffer;
}

@end
