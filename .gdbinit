define connect
set debug remote 1
set serial baud 115200
set detach-on-fork off
set follow-fork-mode child
target remote /dev/cu.usbserial-0177E4AD
end

define microkit_init 
break main.c:724
c
end
