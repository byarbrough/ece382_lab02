ece382_lab02
============

Lab 02 - Decryption



Required Functionality Answer
C	o	n	g	r	a	t	u	l a	t	i	o	n	s	!	.	.Y	o	u	.	d	e	c	r	yp	t	e	d	.	t	h	e	. E	C	E	3	8 2	.	h	i d	d	e	n	.	m	e	s	s  a	g	e	.	a	n	d	.	a c	h	i	e	v	e	d	.	r e	q	u	i	r	e	d	.	f u	n c	t	i	o	n	a	l i	t	y	#

B Functionality Answer
T	h	e	.	m	e	s	s	a g	e	.	k	e	y	.	l	e n	g	t	h	.	i	s	.	1 6	.	b	i	t	s	.	.	.I	t	.	o	n	l	y	.	c o	n	t	a	i	n	s	.	l e	t t	e	r	s	,	.	p e	r	i	o	d	s	,	.	a n	d	.	s	p	a	c	e	s#

###Cracking the Key
This was, obviously, the most difficult part of the lab. At first I misinterpreted the hint from solving message B; I thought that it meant the 16 bit (two byte) key had a letter, a pace, and a period. Clearly, this was not the case, so caused some confusion. I consulted with C2C Sabin Park and realized which information pertained to the message itself instead of the key. This allowed me to take a different approach to solving the key, and took me a comparatively short amount of time from that point.

First, I went to Wiki and found a chart of which letters are the most common in the English language - as it turns out, "e". I then counted which valeus were the most common in the encrypted message: 0x90, 0x16, and 0x17 all appeared four times. From this, I concluded that one of those three values likely translates to "e". By XORing the encrypted byte with the ASCII code for "e", I could determine which 

A Functionality Answer
F	a	s	t	.	.	N	e	a  t .	.	A	v	e	r	a	g e	.	.	F	r	i	e	n	d l	y	.	.	G	o	o	d	. .	G	o	o	d


Documentation
I only needed outside resources for the A functionality. C2C Sabin Park mentioned frequency analysis and explained that I can't read; the message was confined to letters, periods, and spaces. Not the key itself. I then went to Wiki and found a table of letter frequency in English.