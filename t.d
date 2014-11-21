import std.stdio, std.string, std.conv, std.exception;

class ZmqMessage {

private:

    alias frame = void[];
    frame[] _buffer;
    size_t _length;

public:

    this() {
        _length = 0;
        _buffer = new frame[64];
    }

    this(size_t capacity) {
        _buffer = new frame[capacity];
    }

    unittest {        
        auto ctor = new ZmqMessage(10);       
        assert(ctor._buffer.length == 10);
    }   

    // add to the back
    void append(void[] frame) {
        if (_length == _buffer.length)
            ensureCapacity(_length + 1);
        
        _buffer[_length++] = frame;        
    }

    unittest {
        auto item = new ZmqMessage();
        item.append(new frame(10));
        assert(item._buffer[0].length == 10, text("length should be 10, was ", item._buffer[0].length));

        item.append(new frame(15));
        assert(item._buffer[1].length == 15, text("length should be 15, was ", item._buffer[1].length));        
    }

    // add to the front
    void push(void[] frame) {
        if (_length == _buffer.length)
            ensureCapacity(_length + 1);

		_buffer[1 .. $] = _buffer[0 .. $ - 1];		
        _buffer[0] = frame;
        _length++;        
    }

    unittest {
        auto item = new ZmqMessage();
        item.push(new frame(10)); 
        assert(item._buffer[0].length == 10, text("length should be 10, was ", item._buffer[0].length));

        item.push(new frame(15));
        assert(item._buffer[0].length == 15, text("length should be 15, was ", item._buffer[0].length));              
    }

    void[] pop() {
        return null;
    }    

    @property size_t length() { return _length; }

    @property bool empty() { return _length ? false : true; }

    @property size_t capacity() { return _buffer.length; }

    @property void capacity(size_t value) {
        if(value == _buffer.length) {
            return;
		}
        
        enforce(value < _length, "Capacity can't go below the current length");
                
        frame[] array = new frame[value];

        if (_length > 0) {
            array = _buffer[0 .. _length];            
        }

        _buffer = array;

        return;            
    }

private:

    void ensureCapacity(size_t min) {
        if(_buffer.length >= min)
            return;

        if (_buffer.length ? (_buffer.length * 2) : 4 < min) {
            capacity = min;
        }
    }
}

void main() {
}
