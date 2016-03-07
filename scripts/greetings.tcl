# ####
# INFO
# ####
#
# greetings.tcl v1.0 (Nov 01, 2007)
#
# ###########
# DESCRIPTION
# ###########
# 
# Channel Greetings for on join users with Random Welcome Messages, Set your channel via Partyline/DCC.
# Optional greeting style with your choice like; Greet users with Channel Message, Private Message or Notice.
# Ideal script for those who wish to set greeetings on specific channel(s) with optional style and random message.
#
# ########
# FEATURES
# ########
# 
# You can set your own greet messages.
# Set particular channel where you want to activate greeting system and also you can deactivate in the same manner.
# By default, this script greet user with on channel with any random message, even you can set greet style to wish user via MSG/Notice.
# you can change the settings as per your desire which is suitable for your channel.
#
# ############
# INSTALLATION
# ############
#
# * First unzip zipped file i.e. greetings.zip file 
# * Put greetings.tcl file in your eggdrop "/scripts" folder
# * Add a link at the bottom of your eggdrop's .CONF file
#
#   	   source scripts/greetings.tcl
#
# * Save your bot's configuration
# * RESTART your bot -OR- do .rehash from the partyline (DCC) to load the tcl.
#
# #######
# UPDATES
# #######
# 
# v0.0 - 01/08/2006 - Not Released, Beta Testing =)
# v1.0 - 01/11/2007 - Initial Release.
#
# #######
# CONTACT
# #######
#
# Any suggestions, comments, questions or bugs,
# feel free to email me at:
#
#			fyre_tcls@yahoo.com
#
# fyre @ #Eggdrop & #RO-TCL
# On Undernet IRC Network
#
# #########
# DOWNLOADS
# #########
#
# This script and other good TCL Scripts can be found on:
#
# * http://www.egghelp.org/
# * http://www.tclscript.com/
#
# -REGARDS-

########################
#- Channel Activation -#
########################

# Use .chanset to activate/deactivate channel greetings on the particular channel.
# Partyline/DCC :  n|n .chanset 
#       Example : .chanset #mychan1 +greetings
#                 .chanset #mychan2 -greetings

####################
#- Greeting Style -#
####################

# Set greeting style here, options are as follows.
# 0 - Channel Message
# 1 - Notice
# 2 - Private Message
set style "0"

###############
#- Greetings -#
###############

# Here you can set any join message for your channel.
set gmsg {
    "Welcome..."
    "Hello, how are you?"
    "Stay and Have Fun =)"
    "More msg..."
    "Here more..."
    "and it goes on..."
    "I Love You"
    "...............HAVE FUN!"}

########################################################
#- Don't edit below unless you know what you're doing -#
########################################################

bind join - * fyre_greet
setudef flag greetings

proc fyre_greet {nick uhost hand chan args} {
  global gmsg style botnick
  if {![channel get $chan greetings]} { return 0 }
  if {[isbotnick $nick]} {
    return 0
  }
  if {$style == "0"} { putserv "PRIVMSG $chan :$nick: [fyre_msg $args]" }
  if {$style == "1"} { putserv "NOTICE $nick :$nick: [fyre_msg $args]" }
  if {$style == "2"} { putserv "PRIVMSG $nick :$nick: [fyre_msg $args]" }
  return 0
}

proc fyre_msg {nick} {
   global gmsg
   set greetz [lindex $gmsg [rand [llength $gmsg]]]
   return "$greetz" 

}

#######################################################
putlog "LOADED: Greetings (greetings.tcl v1.0) by fyre"
#######################################################
