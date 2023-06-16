# OdinConnectFour

Follows the Ruby TDD Connect Four assignment.    
--------------------------------  

This project uses the MIT License.   

Project instructions:  
--------------------------------  

Project: TDD Connect Four 
-------------------------------- 
Hopefully everyone has played Connect Four at some point (if not, see the Wikipedia page). It’s a basic game where each player takes turns dropping pieces into the cage. Players win if they manage to get 4 of their pieces consecutively in a row, column, or along a diagonal.  

The game rules are fairly straightforward and you’ll be building it on the command line like you did with the other games. If you want to spice up your game pieces, look up the unicode miscellaneous symbols. The Ruby part of this should be well within your capability by now so it shouldn’t tax you much to think about it.  

The major difference here is that you’ll be doing this TDD-style. So figure out what needs to happen, write a (failing) test for it, then write the code to make that test pass, then see if there’s anything you can do to refactor your code and make it better.  

Only write exactly enough code to make your test pass. Oftentimes, you’ll end up having to write two tests in order to make a method do anything useful. That’s okay here. It may feel a bit like overkill, but that’s the point of the exercise. Your thoughts will probably be something like “Okay, I need to make this thing happen. How do I test it? Okay, wrote the test, how do I code it into Ruby? Okay, wrote the Ruby, how can I make this better?” You’ll find yourself spending a fair bit of time Googling and trying to figure out exactly how to test a particular bit of functionality. That’s also okay… You’re really learning RSpec here, not Ruby, and it takes some getting used to.  

Assignment 2  
---------------------------------------
Build Connect Four! Just be sure to keep it TDD.  

Notes from the Author (Peter Hawes)  
---------------------------------------

Test Driven Development is difficult for beginners!  
Introducing dependency injection makes it easier to set certain in-progress values for player objects as instance variables of the game object or for the value of cells_array as used in the Board class.  
In principle Connect Four is very similar to TicTacToe, albeit with far more winning lines (69 instead of 8).

I used the Colorize Gem to make the board display with red and yellow tiles on a white background.  

Colorize License
----------------------------------
Copyright (C) 2007-2016 Michał Kalbarczyk

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

