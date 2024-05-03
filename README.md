# circ
Circular Buffer

(Note: this is obviously far less substantial than my original proposal, as well as being a simpler data structure. My life is kind of a mess right now and I only had a few hours to work on this. ANYWAY,)

A simple/toy implementation of a circular buffer to demonstrate the basic algorithms/concept. Written in Common Lisp because I like it (note that I am not really demonstrating its powers very effectiely with this project). If you don't have a CL environment handy and really want to run the code yourself the fastest way is probably [portacle]( https://portacle.github.io/), but I demonstrate all of the functionality below.

A circular buffer is basically a region of memory with two pointers, one for reading and one for writing. In my implementation a built-in array type is used for the buffer itself because Common Lisp is a high-level language that generally does not work with memory/pointers directly. The buffer is contianed within a structure that also includes slots for the maximum size of the buffer, the read and write indices, and the current length of the used space in the buffer.

The basic operations implemented are creating a new buffer, writing to the buffer, and reading from the buffer.

When creating a new buffer with `new-circ`, a new `circ` struct is created with an array of the specified `size` with elements set to `nil` and read/write indexes as well as length set to 0.

When writing to the buffer with `write-to`, if the buffer's current occupied `length` is not equal to its maximum `size` then the index of the array at the current `write` pointer is set to the given argument for `num` (although it doesn't actually have to be a number since by default CL arrays allow multiple types) and the `write` "pointer" is incremented modulo the `size` (to keep things circular) and the `length` is incremented to reflect the additional item added to the buffer.

When reading from the buffer with `read-from`, if the buffer's current `length` is not 0 (if it is there is nothing to read) then the value at the `read` index is returned, the `read` index is incremented modulo `size` and the `length` is decremented.

Demonstration:
First, set the global variable `*buffer*` to a new buffer so you can manipulate it: `(setf *buffer* (new-circ 4)`
This will print a representation of the struct: `#S(CIRC :BUFFER #(NIL NIL NIL NIL) :SIZE 4 :READ 0 :WRITE 0 :LENGTH 0)`
Add some things to the buffer and look at it again (the `write-to` function returns the current length of the buffer or `nil` if it is full:
```
CL-USER> (write-to *buffer* 325)
1
CL-USER> (write-to *buffer* 456)
2
CL-USER> *buffer*
#S(CIRC :BUFFER #(325 456 NIL NIL) :SIZE 4 :READ 0 :WRITE 2 :LENGTH 2)
```
Read something:
```
CL-USER> (read-from *buffer*)
325
CL-USER> *buffer*
#S(CIRC :BUFFER #(325 456 NIL NIL) :SIZE 4 :READ 1 :WRITE 2 :LENGTH 1)
```
Note the item read is not deleted, but the pointers are set such that it will be overwritten once the write pointer wraps around.
A demonstration function `fill buffer` is included, it fills the available space in the buffer with sequential numbers, note the wrapping around:
```
CL-USER> (fill-buffer *buffer*)
NIL
CL-USER> *buffer*
#S(CIRC :BUFFER #(3 456 1 2) :SIZE 4 :READ 1 :WRITE 1 :LENGTH 4)
```
Also included is `read-buffer`, which reads and prints everything in the buffer, note that it again starts in the middle of the buffer at the current read pointer and wraps around:
```
CL-USER> (read-buffer *buffer*)

456 
1 
2 
3 
NIL
```
