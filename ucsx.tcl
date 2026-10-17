# Eggdrop NO - Den norske hjelpesiden - http://www.eggdrop.no/
# Undernet Channel Service X [ucsx tcl v0.2] © 2001, Eggdrop NO
# Copyright © Stephan Engebretsen  - Email: furt@eggdrop.no

# Made March 4th 2001, Last updated: April 17th 2001.

#(A)# EXPLAINATION #(A)#

# Since Undernet have got a new Channel Service bot, I assumed
# someone would need something like this. This script simply
# checks the channels you specifie, each minute, and if bot is
# opless, it asks X for op status.

# If any questions, comments or replyes, please send me an
# email to furt@eggdrop.no, or stop by #eggdrop at Undernet.


#(B)# CONFIGURATION #(B)# 

# With which nickID is your bot registered in CService bots with?
set conf.ucsx.id "Eggdrop"

# What's your bots password in CService bots?
# (Passwords can be more than one word)
set conf.ucsx.pw "Some Password Here"

# On which channels should this script be activeted on?
# (If more than one, split with space)
# NOTE! If you want it to work on all possible channels,
# change/set this line to: set conf.ucsx.cn all
set conf.ucsx.cn "#eggdrop #eggdrop.no #etc"

# (0/1) Do you want users to be informed via partyline whenever I
# send an op request for a channel?
set conf.ucsx.rq "0"


#(C)# BINDS / PROCEDURES #(C)#

# ## Process: "time"
# Will automaticly be called each minute.
bind time - * proc.ucsx.time
proc proc.ucsx.time {min hour day month year} {

  # Gets all the global variables needed.
  global botnick {conf.ucsx.id} {conf.ucsx.pw} {conf.ucsx.cn} {conf.ucsx.rq}

  if {[string tolower ${conf.ucsx.cn}] == "all"} {set chans [channels]} {
   set chans ${conf.ucsx.cn}
  }

  # Goes through all of the channel with a 'foreach' loop.
  foreach chan [string tolower $chans] {

    # Checks if we are opped on channel.
    if {([botisop $chan]) || (![onchan X $chan])} {continue}

    # Makes a list of channels I were opless on.
    if {[info exists chlist]} {lappend chlist $chan} {set chlist $chan}

    # Sends the login line to CService bot.
    if {![info exists login]} {
      putserv "PRIVMSG X@Channels.Undernet.Org :login ${conf.ucsx.id} ${conf.ucsx.pw}"
      set login "true"
    }

    # ..And in case autoop is turned off, we'll send op requests as well.
    putserv "PRIVMSG X :op $chan $botnick"
  }

  # If enabled, we'll inform the users.
  if {(${conf.ucsx.rq}) && ([info exists chlist])} {putlog "\[UCSX\] Sent op request for channels: [join $chlist ", "]"}

  # Ends the process.
  return 1
}

# Gives some nice credits :P~
putlog "UCSX TCL v0.2 © 2001, furt <furt@eggdrop.no> \[http://www.eggdrop.no/\]"


#(D)# SCRIPTS HISTORY #(D)#

# [04.03.00: v0.1] - furt
#   o  Script is finnished, and ready for use.
#
# [06.03.00: v0.2] - furt
#   o  Replaced "return 0" with "continue" so that
#      the bot would check through all of the channels.
#      A very stupid thing to forget in the first version <g>
#   o  Fixed so the bot only logs on to X once, at not
#      one time for each channel. Another stupid thing.
#   o  Oh, btw, thanks to xXsPEEdXx. He found out the things
#      that was fixed to this version :P~
# [04.17.01: v0.2+MC] - MC_8 - Carl M. Gregory <gregory@worldinter.net>
#   o  Bot wasn't performing login procedurs with X upon (re)start,
#      was a problem with the conf.ucsx.cn veriable.
#   o  Also adjusted the conf.ucsx.cn a bit so that if set to all
#      it will recognize newly added channls without restarting.
