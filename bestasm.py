import sys

insns = []
labels = {}

with open(sys.argv[1]) as f:
    for l in f:
        l = l.strip()
        if not l:
            continue
        if l[-1] == ':':
            name = l[:-1]
            if name in labels:
                raise ValueError('double label def')
            labels[name] = len(insns)
        else:
            op, _, args = l.partition(' ')
            args = [a.strip() for a in args.split(',')]
            insns.append((op, args))
            print(insns[-1])

print(labels)

def parse_reg(s):
    if s[0] != 'r':
        raise ValueError(s)
    return int(s[1:])

def parse_imm(i, width, signed=False):
    i = eval(i)
    if signed:
        if i not in range(-1 << (width - 1), 1 << (width-1)):
            raise ValueError(i)
        i &= (1 << width) - 1
    else:
        if i not in range(1 << width):
            raise ValueError(i)
    return i

with open(sys.argv[2], 'w') as f:
    for op, args in insns:
        if op == 'mov':
            a, i = args
            a = parse_reg(a)
            i = parse_imm(i, 9, signed=True)
            res = 0x30000 | i << 4 | a
        elif op == 'add':
            d, a, b = args
            d = parse_reg(d)
            a = parse_reg(a)
            if b[0] == 'r':
                # XXX
                raise
            else:
                if d != a:
                    raise ValueError(d)
                i = parse_imm(b, 9, signed=True)
                res = 0x34000 | i << 4 | a
        elif op == 'cmp':
            a, i = args
            a = parse_reg(a)
            i = parse_imm(i, 9, signed=True)
            res = 0x36000 | i << 4 | a
        elif op == 'bl':
            a, l = args
            a = parse_reg(a)
            l = labels[l]
            res = 0x20000 | l << 4 | a
        elif op == 'br':
            a, l = args
            a = parse_reg(a)
            if l in labels:
                l = labels[l]
            else:
                l = parse_imm(l, 11)
            res = 0x28000 | l << 4 | a
        elif op == 'jc':
            a, = args
            a = labels[a]
            res = 0x18006 | a << 4
        elif op == 'jnz':
            a, = args
            a = labels[a]
            res = 0x18001 | a << 4
        elif op == 'jmp':
            a, = args
            a = labels[a]
            res = 0x1800e | a << 4
        elif op == 'readkbd':
            a, = args
            a = parse_reg(a)
            res = 0x3e000 | a
        elif op == 'putchar':
            a, b, c = args
            a = parse_reg(a)
            b = parse_reg(b)
            c = parse_reg(c)
            res = 0x3f000 | c << 8 | b << 4 | a
        elif op == 'and':
            d, a, b = args
            d = parse_reg(d)
            a = parse_reg(a)
            b = parse_reg(b)
            res = 0x00000 | b << 8 | a << 4 | d
        elif op == 'shr':
            d, a, b = args
            d = parse_reg(d)
            a = parse_reg(a)
            if b.startswith('r'):
                b = parse_reg(b)
                res = 0x0a000 | b << 8 | a << 4 | d
            else:
                i = parse_imm(b, 4)
                res = 0x0e000 | i << 8 | a << 4 | d
        else:
            raise ValueError(op, args)
        f.write(f'{res:05x}\n')
    for _ in range(1024 - len(insns)):
        f.write(f'{0:05x}\n')
