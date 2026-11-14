.data
# The string to be processed.
test_string: .string "hello, world!"

# Force the next variable to align to a 4-byte boundary.
.align 2

# A dedicated memory location to store the length.
length_result: .word 0

.text
.globl main

main:
    # 1. Test strlen
    la a0, test_string
    jal ra, strlen
    
    # Store the length in memory so the autograder can check it
    la t0, length_result
    sw a0, 0(t0)

    # 2. Test to_upper
    # Note: While .string literals can be read-only in real systems, 
    # the .data section in this simulator is writable, so modifying 
    # test_string in place is perfectly safe here.
    la a0, test_string
    jal ra, to_upper

    # Exit program
    li a0, 10
    ecall


# -------------------------------------------------
# Function: strlen
# Purpose: return the length of a string
# Arguments:
#   a0 = address of the string
# Returns:
#   a0 = length
# 
# TODO: Fix the bug in this function!
# -------------------------------------------------
strlen:
    li   t0, 0             # length counter
    mv   t1, a0            # pointer to current character

strlen_loop:
    lbu t2, 0(t1)
    beq t2, zero, strlen_done

    addi t0, t0, 1
    addi t1, t1, 1
    j strlen_loop

strlen_done:
    add a0, t0, zero
    ret

# -------------------------------------------------
# Function: to_upper
# Purpose: convert all lowercase letters in a string 
#          to uppercase in place. 
# Hint: "in place" means you aren't copying the string to another location,
#       you are modifying each byte where it already is. By the end, 
#       the string located at test_string should be "HELLO, WORLD!"
# Arguments:
#   a0 = address of the string
# Returns:
#   a0 = address of the modified string
#
# TODO: Implement this function from scratch!
# -------------------------------------------------
to_upper:
    mv t0, a0

upper_loop:
    lbu t1, 0(t0)
    beq t1, zero, upper_done

    li t2, 97
    blt t1, t2, upper_next

    li t2, 122
    blt t2, t1, upper_next

    addi t1, t1, -32
    sb t1, 0(t0)

upper_next:
    addi t0, t0, 1
    j upper_loop

upper_done:
    ret
