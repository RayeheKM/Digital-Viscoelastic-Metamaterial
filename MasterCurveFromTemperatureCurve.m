   c   l   c      
   c   l   e   a   r       a   l   l      
   c   l   o   s   e       a   l   l      
      
   t   a   r   g   e   t   F   r   e   q   u   e   n   c   y       =       1   ;       %   H   z      
   M   o   d   u   l   u   s   _   T   e   m   p   S   w   e   e   p   D   a   t   a       =       i   m   p   o   r   t   d   a   t   a   (   '   C   :   \   U   s   e   r   s   \   B   r   i   n   s   o   n   L   a   b   \   D   e   s   k   t   o   p   \   D   i   g   i   t   a   l   M   e   t   a   m   a   t   e   r   i   a   l   \   C   o   d   e   s   \   M   o   d   u   l   u   s   _   T   e   m   p   S   w   e   e   p   D   a   t   a   .   x   l   s   x   '   )   ;      
      
   %       I   m   p   o   r   t       t   h   e       d   a   t   a       f   r   o   m       t   h   e       E   x   c   e   l       f   i   l   e      
   d   a   t   a       =       i   m   p   o   r   t   d   a   t   a   (   '   C   :   \   U   s   e   r   s   \   B   r   i   n   s   o   n   L   a   b   \   D   e   s   k   t   o   p   \   D   i   g   i   t   a   l   M   e   t   a   m   a   t   e   r   i   a   l   \   C   o   d   e   s   \   M   a   s   t   e   r   C   u   r   v   e   .   x   l   s   x   '   )   ;      
      
   %       S   k   i   p       t   h   e       f   i   r   s   t       t   w   o       r   o   w   s       (   a   s   s   u   m   i   n   g       d   a   t   a       s   t   a   r   t   s       f   r   o   m       t   h   e       t   h   i   r   d       r   o   w   )      
   M   a   s   t   e   r   C   u   r   v   e   D   a   t   a       =       d   a   t   a   .   d   a   t   a   (   3   :   e   n   d   ,       :   )   ;           %       A   d   j   u   s   t       '   3   :   e   n   d   '       t   o       s   k   i   p       r   o   w   s       1       a   n   d       2      
      
      
   %       C   o   n   v   e   r   t       t   h   e       t   e   m   p   e   r   a   t   u   r   e   s       f   r   o   m       C   e   l   s   i   u   s       t   o       K   e   l   v   i   n      
   T   e   m   p   e   r   a   t   u   r   e   M   a   p   _   K       =       M   o   d   u   l   u   s   _   T   e   m   p   S   w   e   e   p   D   a   t   a   .   d   a   t   a   (   :   ,   5   )       +       2   7   3   .   1   5   ;      
      
      
   T       =       [   3   0   3   .   1   5   ,       3   0   8   .   1   5   ,       3   1   3   .   1   5   ,       3   1   8   .   1   5   ,       3   2   3   .   1   5   ,       3   2   8   .   1   5   ,       3   3   3   .   1   5   ,       3   3   8   .   1   5   ,       3   4   3   .   1   5   ,       3   4   8   .   1   5   ,       3   5   3   .   1   5   ,       3   5   8   .   1   5   ,       3   6   3   .   1   5   ]   ;      
   a   _   T       =       [   1   .   6   4   E   +   0   5   ,       7   .   4   7   E   +   0   4   ,       8   .   1   4   E   +   0   3   ,       3   .   2   4   E   +   0   2   ,       1   .   4   8   E   +   0   1   ,       1   .   0   0   E   +   0   0   ,       1   .   0   9   E   -   0   1   ,       1   .   8   2   E   -   0   2   ,       3   .   9   5   E   -   0   3   ,       9   .   9   3   E   -   0   4   ,       2   .   7   4   E   -   0   4   ,       4   .   3   0   E   -   0   5   ,       3   .   1   4   E   -   0   6   ]   ;      
      
   %       I   n   t   e   r   p   o   l   a   t   e       t   h   e       s   h   i   f   t       f   a   c   t   o   r   s       f   o   r       e   a   c   h       u   n   i   q   u   e       t   e   m   p   e   r   a   t   u   r   e       i   n       t   h   e       m   a   p      
   s   h   i   f   t   F   a   c   t   o   r   s       =       i   n   t   e   r   p   1   (   T   ,       a   _   T   ,       T   e   m   p   e   r   a   t   u   r   e   M   a   p   _   K   ,       '   p   c   h   i   p   '   ,       '   e   x   t   r   a   p   '   )   ;           %       '   e   x   t   r   a   p   '       h   a   n   d   l   e   s       t   e   m   p   e   r   a   t   u   r   e   s       o   u   t   s   i   d   e       r   a   n   g   e      
      
   %       A   p   p   l   y       s   h   i   f   t       a   n   d       b   r   o   a   d   e   n   i   n   g       f   a   c   t   o   r   s       t   o       f   r   e   q   u   e   n   c   y      
   f   r   e   q       =       l   o   g   1   0   (   t   a   r   g   e   t   F   r   e   q   u   e   n   c   y   )       +       l   o   g   1   0   (   s   h   i   f   t   F   a   c   t   o   r   s   )   ;      
   f   r   e   q       =       1   0   .   ^   f   r   e   q   ;      
      
   s   m   o   o   t   h   e   d   m   a   s   t   e   r   c   u   r   v   e   =   [   f   r   e   q   ,   M   o   d   u   l   u   s   _   T   e   m   p   S   w   e   e   p   D   a   t   a   .   d   a   t   a   (   :   ,   6   )   .   *   1   0   ^   6   ,   M   o   d   u   l   u   s   _   T   e   m   p   S   w   e   e   p   D   a   t   a   .   d   a   t   a   (   :   ,   7   )   .   *   1   0   ^   6   ]   ;      
   %       E   x   t   r   a   c   t       f   r   e   q   u   e   n   c   y   ,       s   t   o   r   a   g   e   ,       a   n   d       l   o   s   s       d   a   t   a      
   f   r   e   q   u   e   n   c   y       =       M   a   s   t   e   r   C   u   r   v   e   D   a   t   a   (   :   ,   1   )   ;      
   s   t   o   r   a   g   e   M   o   d   u   l   u   s       =       M   a   s   t   e   r   C   u   r   v   e   D   a   t   a   (   :   ,   2   )   ;      
   l   o   s   s   M   o   d   u   l   u   s       =       M   a   s   t   e   r   C   u   r   v   e   D   a   t   a   (   :   ,   3   )   ;      
      
      
   %       y   y   a   x   i   s       l   e   f   t   ;      
   l   o   g   l   o   g   (   f   r   e   q   ,       M   o   d   u   l   u   s   _   T   e   m   p   S   w   e   e   p   D   a   t   a   .   d   a   t   a   (   :   ,   6   )   ,       '   k   '   )      
   h   o   l   d       o   n      
   l   o   g   l   o   g   (   M   a   s   t   e   r   C   u   r   v   e   D   a   t   a   (   :   ,   1   )   ,       M   a   s   t   e   r   C   u   r   v   e   D   a   t   a   (   :   ,   2   )   .   /   1   0   ^   6   ,       '   -   -   b   '   )      
   y   l   a   b   e   l   (   '   S   t   o   r   a   g   e       M   o   d   u   l   u   s       (   M   P   a   )   '   )   ;      
      
   %       y   y   a   x   i   s       r   i   g   h   t   ;      
   %       f   i   g   u   r   e      
   l   o   g   l   o   g   (   f   r   e   q   ,       M   o   d   u   l   u   s   _   T   e   m   p   S   w   e   e   p   D   a   t   a   .   d   a   t   a   (   :   ,   7   )   ,       '   m   '   )      
   %       h   o   l   d       o   n      
   l   o   g   l   o   g   (   M   a   s   t   e   r   C   u   r   v   e   D   a   t   a   (   :   ,   1   )   ,       M   a   s   t   e   r   C   u   r   v   e   D   a   t   a   (   :   ,   3   )   .   /   1   0   ^   6   ,       '   -   -   r   '   )      
   y   l   a   b   e   l   (   '   L   o   s   s       M   o   d   u   l   u   s       (   M   P   a   )   '   )   ;      
      
   x   l   a   b   e   l   (   '   F   r   e   q   u   e   n   c   y       (   H   z   )   '   )   ;      
      
   l   e   g   e   n   d   (   '   S   t   o   r   a   g   e       (   M   P   a   )       f   r   o   m       t   e   m   p   e   r   a   t   u   r   e       s   w   e   e   p       d   a   t   a   '   ,       '   S   t   o   r   a   g   e       (   M   P   a   )       f   r   o   m       f   r   e   q   u   e   n   c   y       s   w   e   e   p       d   a   t   a   '   ,       '   L   o   s   s       (   M   P   a   )       f   r   o   m       t   e   m   p   e   r   a   t   u   r   e       s   w   e   e   p       d   a   t   a   '   ,       '   L   o   s   s       (   M   P   a   )       f   r   o   m       f   r   e   q   u   e   n   c   y       s   w   e   e   p       d   a   t   a   '   ,       '   L   o   c   a   t   i   o   n   '   ,   '   b   e   s   t   '   )      
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ��