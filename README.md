ece382_lab02
============

Decryption - Practice programming skills by writing subroutines which use both the call-by-value and call-by-reference techniques to pass arguments to your subroutines. This program will decrypt a message given a key.
____________________

Kaboom! Here is the:
_Required Functionality Answer_

C	o	n	g	r	a	t	u	l  a	t	i	o	n	s	!	.	.Y	o	u	.	d	e	c	r	y p	t	e	d	.	t	h	e	. E	C	E	3	8 2	.	h	i  d	d	e	n	.	m	e	s	s  a	g	e	.	a	n	d	.	a  c	h	i	e	v	e	d	.	r  e	q	u	i	r	e	d	.	f  u	n  c	t	i	o	n	a	l i	t	y	#

How did I get there? Well, first I started out with a prelab:
###Flowchart
![alt text](https://raw.githubusercontent.com/byarbrough/ece382_lab02/master/flow2.jpg "Initial Flowchart")

The primary difference between this program and Lab01 is that this program uses subroutines in the form of stack pointers. Subroutines are useful for segmenting code and keeping it clean. They are especially useful when a segment of code is going to be used over and over. The decryptCharacter subroutine is a prime example of when a subroutine should be used because it performs a specific task when passed parameters and returns a result which the program continues to execute on.. Arguably, the first subroutine doesn't need to be a subroutine as it is only called once, but it is good practice. Also, if the code was going to be modified to decrypt several messages then the two subroutine setup would certainly be handy. Yes, this could have been done with loops, but not as effectively. Plus, the push and pop functions allow for the preservation of registers which may be destroyed or wasted by counting loops.

####From Boxes to Code
I worked backwards in the actual programming. First, I made sure that I could setup registers and decode a single character. In order to do this I had to write coherent skeleton code to be filled in later. This made a smaller problem out of a bigger one (a good coding technique). The commit labeled "decrypt single byte" from the history of _main.asm_ shows this first program.
Once I had a single character decoded, I only had to modify the first subroutine to advance pointers and recall the second subroutine. Much of the code from Lab01 could be reused to do this.

####Side Note: Hardware
Because this program was implemented on the TI MSP430, there was a limited amount of RAM, which could not be exceeded. This restricts the number of characters which are decoded before the program fills RAM and crashes after 512 bytes.

###B Functionality
Having the required functionality, it was not a major step to go to B functionality. The trickiest part was deciding just how I wanted to do things. It would have been great to have a .length() function to just determine the length of the key, but this isn't that sissy high level language stuff. I eventually ended up making the user have to input the length of the key, in bytes, in ROM (keyL). This hurt my pride a bit, but had to be done.
Having the key length always accessible allowed me to put a loop within the first subroutine. For a key length of two bytes, it would solve a character, advance a pointer to the second byte in the key, and then call decryptCharacter again. This isn't very pretty looking code, but is robust enough to handle a key length that is just as long as the message.

####Side Note: Debugging
Thus far I had not had to do any significant debugging. The largest problems were caused by simple errors on my part. The beloved register indexed addressing got me once or twice, messing up where things were stored at. The biggest error that I had to debug was when I modified dTrk. In my infinite wisdom, I had the original command for initialization as mov.b #0x200, dTrk . This built just fine, but I would not store things in the correct place - I couldn't even find where things were being modified. Well, of course 0x200 is a word, not a byte, so mov.b just stores 0x00. This obviously doesn't work.
Once I fixed that error and finished up my loops, I got:

_B Functionality Answer_

T	h	e	.	m	e	s	s	a g	e	.	k	e	y	.	l	e n	g	t	h	.	i	s	.	1 6	.	b	i	t	s	.	.	.I	t	.	o	n	l	y	.	c o	n	t	a	i	n	s	.	l e	t t	e	r	s	,	.	p e	r	i	o	d	s	,	.	a n	d	.	s	p	a	c	e	s#

###Cracking the Key - A functionality
This was, obviously, the most difficult part of the lab. At first I misinterpreted the hint from solving message B; I thought that it meant the 16 bit (two byte) key had a letter, a pace, and a period. Clearly, this was not the case, so caused some confusion. I consulted with C2C Sabin Park and realized which information pertained to the message itself instead of the key. This allowed me to take a different approach to solving the key, and took me a comparatively short amount of time from that point.

First, I went to Wiki and found a chart of which letters are the most common in the English language - as it turns out, "e". 

_Frequency of Letters in the English Language (Wikipedia)_
	
![alt text](http://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/English_letter_frequency_%28alphabetic%29.svg/600px-English_letter_frequency_%28alphabetic%29.svg.png  "Frequency of Letters in the English Language ")
	
I then counted which values were the most common in the encrypted message: 0x90, 0x16, and 0x17 all appeared four times. From this, I concluded that one of those three values likely translates to "e". By XORing the encrypted byte with the ASCII code for "e", I could determine which key would result in an "e". I then ran this through the program. If it output a bunch of garblygook, then I knew it was likely not the key. Furthermore, I knew that I was looking only for ASCII letters, periods, and spaces, so if I saw anything else, I knew that I had the incorrect key.

Here is an example of an incorrect key combination.
0x90 xor 0x45 = 0xD5 -> find the key if 0x90 is 'E'

_Incorrect Result_ 

.	.	.	.	.	K	.	.	. .	.	K	.	.	.	.	. .	E	.	-	.	.	.	.	. .	.	E	.	,	.	.	.	E .	,	.	.	.	E	Z	.	. .	.	g	.	U	.	.	.	% .	.	.	.	*	.	.	.	. .	.	.	.	.	.	.	e 

Clearly, this is not a correct key.

As it turns out, the value 0x16 corresponds to 'e' and 0x90 corresponds to '.'
Setting the key to 0x73, 0xBE yields.... *drum-roll*

_A Functionality Answer_

F	a	s	t	.	.	N	e	a  t .	.	A	v	e	r	a	g e	.	.	F	r	i	e	n	d l	y	.	.	G	o	o	d	. .	G	o	o	d

I was pretty excited about this.

Unfortunately, it was not all as easy as this. Before I tried 'e' I tried both '.' and space as well as 'E'. Also, I conveniently tried 0x16 after 0x90 every time. This resulted in some extra runs. Also, I incorrectly assumed that because 0x16 and 0x17 were only one bit off that they were adjacent letters - most likely 'h' and 'i' or 'm' and 'n' since they are quite common. That was a dumb waste of time. Once I started focusing on 'e' it all worked out just fine.

###Conclusion
This lab was a lot of fun. I am one step closer to becoming an assembly ninja, as I now know how to employ subroutines. Also, it was nice to jump back in to some decryption techniques.


###Documentation
I only needed outside resources for the A functionality. C2C Sabin Park mentioned frequency analysis and explained that I can't read; the message was confined to letters, periods, and spaces. Not the key itself. I then went to Wiki and found a table of letter frequency in English.
