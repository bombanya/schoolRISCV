# RISC-V simple counter program
#
# Stanislav Zhelnio, 2020
#

            .text

start:      li a0, 129
            li a1, 255
            or a2, a0, a1 
            or a2, a1, a0