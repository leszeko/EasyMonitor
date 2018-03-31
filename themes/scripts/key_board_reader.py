#!/usr/bin/env python

import sys,termios, time

## Font attributes ##
# off
off = '\x1b[0m' # off
default = '\x1b[39m' # default foreground
DEFAULT = '\x1b[49m' # default background
# 
bd = '\x1b[1m' # bold
ft = '\x1b[2m' # faint
st = '\x1b[3m' # standout
ul = '\x1b[4m' # underlined
bk = '\x1b[5m' # blink
rv = '\x1b[7m' # reverse
hd = '\x1b[8m' # hidden
nost = '\x1b[23m' # no standout
noul = '\x1b[24m' # no underlined
nobk = '\x1b[25m' # no blink
norv = '\x1b[27m' # no reverse
# colors
black = '\x1b[30m'
BLACK = '\x1b[40m'
red = '\x1b[31m'
RED = '\x1b[41m'
green = '\x1b[32m'
GREEN = '\x1b[42m'
yellow = '\x1b[33m'
YELLOW = '\x1b[43m'
blue = '\x1b[34m'
BLUE = '\x1b[44m'
magenta = '\x1b[35m'
MAGENTA = '\x1b[45m'
cyan = '\x1b[36m'
CYAN = '\x1b[46m'
white = '\x1b[37m'
WHITE = '\x1b[47m'
# light colors
dgray = '\x1b[90m'
DGRAY = '\x1b[100m'
lred = '\x1b[91m'
LRED = '\x1b[101m'
lgreen = '\x1b[92m'
LGREEN = '\x1b[102m'
lyellow = '\x1b[93m'
LYELLOW = '\x1b[103m'
lblue = '\x1b[94m'
LBLUE = '\x1b[104m'
lmagenta = '\x1b[95m'
LMAGENTA = '\x1b[105m'
lcyan = '\x1b[96m'
LCYAN = '\x1b[106m'
lgray = '\x1b[97m'
LGRAY = '\x1b[107m'



 ## 256 colors ##
# \x1b[38;5;#m foreground, # = 0 - 255
# \x1b[48;5;#m background, # = 0 - 255
## True Color ##
# \x1b[38;2;r;g;bm r = red, g = green, b = blue foreground
# \x1b[48;2;r;g;bm r = red, g = green, b = blue background

# ----------------------------------------------------------------------------------
# prepare terminal settings
fd = sys.stdin.fileno()
old_settings = termios.tcgetattr(fd)
new_settings = termios.tcgetattr(fd)
new_settings[3] &= ~termios.ICANON
new_settings[3] &= ~termios.ECHO

# ----------------------------------------------------------------------------------
def clear(what='screen'):
        '''
        erase functions:
                what: screen => erase screen and go home
                      line   => erase line and go to start of line
                      bos    => erase to begin of screen
                      eos    => erase to end of screen
                      bol    => erase to begin of line
                      eol    => erase to end of line
        '''
        clear = {
                'screen': '\x1b[2J\x1b[H',
                'line': '\x1b[2K\x1b[G',
                'bos': '\x1b[1J',
                'eos': '\x1b[J',
                'bol': '\x1b[1K',
                'eol': '\x1b[K',
                }
        sys.stdout.write(clear[what])
        sys.stdout.flush()

# ----------------------------------------------------------------------------------
def move(pos):
        '''
        move cursor to pos
        pos = tuple (x,y)
        '''
        x,y = pos
        sys.stdout.write('\x1b[{};{}H'.format(str(x),str(y)))
        sys.stdout.flush()

# ----------------------------------------------------------------------------------
def put(*args):
        '''
        put text on on screen
        a tuple as first argument tells absolute position for the text
       does not change cursor position
        args = list of optional position, formatting tokens and strings
        '''
        args = list(args)
        if type(args[0]) == type(()):
                x,y = args[0]
                del args[0]
                args.insert(0,'\x1b[{};{}H'.format(str(x),str(y)))
        args.insert(0,'\x1b[s')
        args.append('\x1b[u')
        sys.stdout.write(''.join(args))
        sys.stdout.flush()

# ----------------------------------------------------------------------------------
def write(*args):
        '''
        writes text on on screen
        a tuple as first argument gives the relative position to current cursor position
        does change cursor position
        args = list of optional position, formatting tokens and strings
        '''
        args = list(args)
        if type(args[0]) == type(()):
                pos = []
                x,y = args[0]
                if x > 0:
                        pos.append('\x1b[{}A'.format(str(x)))
                elif x < 0:
                        pos.append('\x1b[{}B'.format(abs(str(x))))
                if y > 0:
                        pos.append('\x1b[{}C'.format(str(y)))
                elif y < 0:
                        pos.append('\x1b[{}D'.format(abs(str(y))))
                del args[0]
                args = pos + args
        sys.stdout.write(''.join(args))
        sys.stdout.flush()


# ----------------------------------------------------------------------------------
def getch():
        '''
        Get character.
        '''
        # get character
        try:
                termios.tcsetattr(fd,termios.TCSANOW,new_settings)
                ch = sys.stdin.read(1)
        finally:
                termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
        # return
        return ch

# ----------------------------------------------------------------------------------


if __name__ == '__main__':
        clear()
        esc_mode = False
        esc_string = ''
        esc_codes = {
                '[A': 'Up',
                '[B': 'Down',
                '[C': 'Right',
                '[D': 'Left',
                '[F': 'End',
                '[H': 'Pos1',
                '[2~': 'Ins',
                '[3~': 'Del',
                '[5~': 'PgUp',
                '[6~': 'PdDown',
                'OP': 'F1',
                'OQ': 'F2',
                'OR': 'F3',
                'OS': 'F4',
                '[15~': 'F5',
                '[17~': 'F6',
                '[18~': 'F7',
                '[19~': 'F8',
                '[20~': 'F9',
                '[21~': 'F10',
                '[23~': 'F11',
                '[24~': 'F12',
                '[29~': 'Apps',
                '[34~': 'Win',
                '[1;2A': 'S-Up',
                '[1;2B': 'S-Down',
                '[1;2C': 'S-Right',
                '[1;2D': 'S-Left',
                '[1;2F': 'S-End',
                '[1;2H': 'S-Pos1',
                '[2;2~': 'S-Ins',
                '[3;2~': 'S-Del',
                '[5;2~': 'S-PgUp',
                '[6;2~': 'S-PdDown',
                '[1;2P': 'S-F1',
                '[1;2Q': 'S-F2',
                '[1;2R': 'S-F3',
                '[1;2S': 'S-F4',
                '[15;2~': 'S-F5',
                '[17;2~': 'S-F6',
                '[18;2~': 'S-F7',
                '[19;2~': 'S-F8',
                '[20;2~': 'S-F9',
                '[21;2~': 'S-F10',
                '[23;2~': 'S-F11',
                '[24;2~': 'S-F12',
                '[29;2~': 'S-Apps',
                '[34;2~': 'S-Win',
                '[1;3A': 'M-Up',
                                  '[1;3B': 'M-Down',
                '[1;3C': 'M-Right',
                '[1;3D': 'M-Left',
                '[1;3F': 'M-End',
                '[1;3H': 'M-Pos1',
                '[2;3~': 'M-Ins',
                '[3;3~': 'M-Del',
                '[5;3~': 'M-PgUp',
                '[6;3~': 'M-PdDown',
                '[1;3P': 'M-F1',
                '[1;3Q': 'M-F2',
                '[1;3R': 'M-F3',
                '[1;3S': 'M-F4',
                '[15;3~': 'M-F5',
                '[17;3~': 'M-F6',
                '[18;3~': 'M-F7',
                '[19;3~': 'M-F8',
                '[20;3~': 'M-F9',
                '[21;3~': 'M-F10',
                '[23;3~': 'M-F11',
                '[24;3~': 'M-F12',
                '[29;3~': 'M-Apps',
                '[34;3~': 'M-Win',
                '[1;5A': 'C-Up',
                '[1;5B': 'C-Down',
                '[1;5C': 'C-Right',
                '[1;5D': 'C-Left',
                '[1;5F': 'C-End',
                '[1;5H': 'C-Pos1',
                '[2;5~': 'C-Ins',
                '[3;5~': 'C-Del',
                '[5;5~': 'C-PgUp',
                '[6;5~': 'C-PdDown',
                '[1;5P': 'C-F1',
                '[1;5Q': 'C-F2',
                '[1;5R': 'C-F3',
                '[1;5S': 'C-F4',
                '[15;5~': 'C-F5',
                '[17;5~': 'C-F6',
                '[18;5~': 'C-F7',
                '[19;5~': 'C-F8',
                '[20;5~': 'C-F9',
                '[21;5~': 'C-F10',
                '[23;5~': 'C-F11',
                '[24;5~': 'C-F12',
                '[29;5~': 'C-Apps',
                '[34;5~': 'C-Win',
                '[1;6A': 'S-C-Up',
                '[1;6B': 'S-C-Down',
                '[1;6C': 'S-C-Right',
                '[1;6D': 'S-C-Left',
                '[1;6F': 'S-C-End',
                '[1;6H': 'S-C-Pos1',
                '[2;6~': 'S-C-Ins',
                           '[3;6~': 'S-C-Del',
                '[5;6~': 'S-C-PgUp',
                '[6;6~': 'S-C-PdDown',
                '[1;6P': 'S-C-F1',
                '[1;6Q': 'S-C-F2',
                '[1;6R': 'S-C-F3',
                '[1;6S': 'S-C-F4',
                '[15;6~': 'S-C-F5',
                '[17;6~': 'S-C-F6',
                '[18;6~': 'S-C-F7',
                '[19;6~': 'S-C-F8',
                '[20;6~': 'S-C-F9',
                '[21;6~': 'S-C-F10',
                '[23;6~': 'S-C-F11',
                '[24;6~': 'S-C-F12',
                '[29;6~': 'S-C-Apps',
                '[34;6~': 'S-C-Win',
                '[1;7A': 'C-M-Up',
                '[1;7B': 'C-M-Down',
                '[1;7C': 'C-M-Right',
                '[1;7D': 'C-M-Left',
                '[1;7F': 'C-M-End',
                '[1;7H': 'C-M-Pos1',
                '[2;7~': 'C-M-Ins',
                '[3;7~': 'C-M-Del',
                '[5;7~': 'C-M-PgUp',
                '[6;7~': 'C-M-PdDown',
                '[1;7P': 'C-M-F1',
                '[1;7Q': 'C-M-F2',
                '[1;7R': 'C-M-F3',
                '[1;7S': 'C-M-F4',
                '[15;7~': 'C-M-F5',
                '[17;7~': 'C-M-F6',
                '[18;7~': 'C-M-F7',
                '[19;7~': 'C-M-F8',
                '[20;7~': 'C-M-F9',
                '[21;7~': 'C-M-F10',
                '[23;7~': 'C-M-F11',
                '[24;7~': 'C-M-F12',
                '[29;7~': 'C-M-Apps',
                '[34;7~': 'C-M-Win',
                }
                # 8 wre S-C-M

        ctrl_codes = {
                0: 'C-2',
                1: 'C-A',
                2: 'C-B',
                3: 'C-C',
                4: 'C-D',
                5: 'C-E',
                6: 'C-F',
                7: 'C-G',
                8: 'C-H',
                       9: 'C-I',
                10: 'C-J',
                11: 'C-K',
                12: 'C-L',
                13: 'C-M',
                14: 'C-N',
                15: 'C-O',
                16: 'C-P',
                17: 'C-Q',
                18: 'C-R',
                19: 'C-S',
                20: 'C-T',
                21: 'C-U',
                22: 'C-V',
                23: 'C-W',
                24: 'C-X',
                25: 'C-Y',
                26: 'C-Z',
                27: 'C-3',
                29: 'C-5',
                30: 'C-6',
                31: 'C-7',
                }

        while True:
                move((1,1))
                clear('line')
                put((1,1),green,':',off)
                move((1,3))
                ch = getch()
                if esc_mode:
                        esc_string += ch
                        # esc string terminators
                        if ch in ['A','B','C','D','F','H','P','Q','R','S','~']:
                                esc_mode = False
                                move((2,0))
                                clear('line')
                                put((2,5),esc_codes[esc_string])
                                esc_string = ''
                        elif ch == '\x1b':
                                esc_mode = False
                else:
                        # esc mode
                        if ch == '\x1b':
                                esc_mode = True
                        # ctrl
                        elif ord(ch) in ctrl_codes.keys():
                                move((2,0))
                                clear('line')
                                put((2,5),ctrl_codes[ord(ch)])

                        move((2,0))
                        put((2,3),str(ch))
