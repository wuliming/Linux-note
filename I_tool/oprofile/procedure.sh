gcc -c -g -fPIC end.c
gcc -shared -fPIC -o libend.so end.o
cp libend.so /usr/lib64/libend.so
opcontrol --reset
opcontrol --start
