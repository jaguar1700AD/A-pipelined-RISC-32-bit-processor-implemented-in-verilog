#!/usr/bin/env python
# coding: utf-8

# In[9]:


bcode = {     'ADD'   : '100001',     'SUB'   : '100010',     'AND'   : '100100',     'OR'    : '101000',     'SLT'   : '110000',     'MUL'   : '100000',     'HLT'   : '111111',     'LW'    : '000011',     'SW'    : '000110',     'ADDI'  : '001110',     'SUBI'  : '001101',     'SLTI'  : '010000',     'BNEQZ' : '000111',     'BEQZ'  : '011110',     'NO_OP' : '000000'  }


# In[36]:


def convert_to_bin(n, k):
    n = int(n)
    if (n >= 0):
        a = bin(n).replace('0b','')
    else:
        a = bin(n + 2 ** k).replace('0b','')
    a = (k - len(a)) * '0' + a
    return a


# In[55]:


type1 = ['ADD','SUB','AND','OR','SLT','MUL']
type2 = ['LW', 'SW', 'ADDI', 'SUBI', 'SLTI']
type3 = ['BNEQZ', 'BEQZ']
type4 = ['NO_OP', 'HLT']

with open('test_program.txt', 'r') as file:
    with open('test_program_bin', 'w') as file_out:
        for line in file:
            arr = line.strip('\n').split(' ')
            if arr[0] in type1:
                regd = convert_to_bin(arr[1].strip(',').strip('R'), 5)
                regs = convert_to_bin(arr[2].strip(',').strip('R'), 5)
                regt = convert_to_bin(arr[3].strip(',').strip('R'), 5)
                print(bcode[arr[0]] + regd + regs + regt + '0'*11, file = file_out)
            elif arr[0] in type2:
                regd = convert_to_bin(arr[1].strip(',').strip('R'), 5)
                regs = convert_to_bin(arr[2].strip(',').strip('R'), 5)
                num = convert_to_bin(arr[3], 16)
                print(bcode[arr[0]] + regd + regs + num, file = file_out)
            elif arr[0] in type3:
                reg_check = convert_to_bin(arr[1].strip(',').strip('R'), 5)
                num = convert_to_bin(arr[2], 16)
                print(bcode[arr[0]] + '0'*5 + reg_check + num, file = file_out)
            elif arr[0] == 'HLT':
                print('1' * 32, file = file_out)
            elif arr[0] == 'NO_OP':
                print('0' * 32, file = file_out)
            else:
                print('Invalid instruction: ', arr[0])


# In[ ]:




