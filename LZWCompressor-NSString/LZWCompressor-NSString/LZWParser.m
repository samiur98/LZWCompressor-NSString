//  Parser source file that parses encoded string during the decoding process.

#import "LZWParser.h"
@interface LZWParser()
- (Container) getContainer; //Returns a Container Struct.
@end

@implementation LZWParser

- (id) init{
    self = [super init];
    self.container = [self getContainer];
    return self;
}

- (unsigned short) getValue: (unsigned char) size{
    //Returns the oldest n number of bits in the container, where n is specified by the size argument.
    unsigned char need = self.container.containerSize - size;
    unsigned short result = self.container.value >> need;
    Container con = [self getContainer];
    con.value = self.container.value << (size + (16 - self.container.containerSize));
    con.value = con.value >> (size + (16 - self.container.containerSize));
    con.containerSize = self.container.containerSize - size;
    self.container = con;
    return result;
}

- (void) append: (unsigned char) value{
    //Adds 8 bits to the container and appends the containerSize accordingly.
    Container con = [self getContainer];
    con.value = self.container.value << 8;
    con.containerSize = self.container.containerSize + 8;
    con.value = con.value | value;
    self.container = con;
}

- (BOOL) isReady: (unsigned char) size{
    //Returns true if container has enough bits, specified by the size.
    if(self.container.containerSize >= size){
        return true;
    }
    return false;
}

- (Container) getContainer{
    //Returns a Container Struct.
    Container con;
    con.value = 0;
    con.containerSize = 0;
    return con;
}
@end
