# RISC-V simple counter program
#
# Stanislav Zhelnio, 2020
#

            .text

start:      li a0, 129
            lui a0, 0
            li a1, 255
            or a2, a0, a1 
            li a3, 0xa5980a00
            li a4, 0x01500d00
            add a5, a3, a4
            or a6, a3, a4
