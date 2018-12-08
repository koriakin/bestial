import gzip

with open('/usr/share/kbd/consolefonts/default8x16.psfu.gz', 'rb') as f:
    d = f.read()

d = gzip.decompress(d)
d = d[0x20:]
d = d[:0x800]

xlat = bytes(
    sum(1 << bit for bit in range(8) if x & 1 << (7 - bit))
    for x in range(0x100)
)

for i, x in enumerate(d):
    sx = xlat[x]
    print(f'font[{i}] = 9\'h{sx:03x}')
