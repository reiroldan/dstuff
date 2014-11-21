import std.stdio, std.string, std.conv;

class ZmqMessage {

private:

    alias frame = void[];
    frame[] _buffer;
    size_t _length;
    frame[64] _initialBuffer;  

public:

    this() {
        _length = 0;
        _buffer = _initialBuffer;
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
        insert(0, frame);
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

    void insert(size_t index, void[] frame) {
        if (index > _length)
            throw new Exception("Can't insert frame past the end of the message.");
    
        if (_length == _buffer.length)
            ensureCapacity(_length + 1);
			
		if (index < _length) 
			_buffer[index + 1 .. _length - index] = _buffer[index .. $];

        _buffer[index] = frame;
        _length++;        
    }

    @property size_t length() { return _length; }

    @property bool empty() { return _length ? false : true; }

    @property size_t capacity() { return _buffer.length; }

    @property void capacity(size_t value) {
        if(value == _buffer.length)
            return;

        if (value < _length)
            throw new Exception("Capacity can't go below the current length");
                
        frame[] array = new frame[value];

        if (_length > 0)
            array = _buffer[0 .. _length];            
        
        _buffer = array;

        return;            
    }

private:

    void ensureCapacity(size_t min) {
        if(_buffer.length >= min)
            return;
    
        size_t num = (_buffer.length == 0) ? 4 : (_buffer.length * 2);

        if (num < min)
            num = min;
        
        capacity = num;        
    }
}

void main() {
}