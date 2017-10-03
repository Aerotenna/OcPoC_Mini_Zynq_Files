kernel_addy = {
'ttyPS0':0xe0000000,
'ttyPS1':0xe0001000,
'ttyS0' :None,
'ttyS1' :None,
'ttyS2' :0x43c20000,
'ttyS3' :0x43c30000,
'ttyS4' :0x43cc0000,
'ttyS5' :0x43cd0000,
'ttyS6' :0x43ce0000,
'ttyS7' :0x43c40000,
'ttyS8' :0x43c50000,
'ttyS9' :0x43c60000,
'ttyS10':0x43c70000,
'ttyS11':0x43c80000,
'ttyS12':0x43c90000,
'ttyS13':0x43ca0000,
'ttyS14':0x43cb0000,
'ttyS15':None
}

addy_uart = {
0xe0000000 : 'PS',
0x43c10000 : 0,
0x43c20000 : 1,
0x43c30000 : 2,
0x43c40000 : 3,
0x43c60000 : 4,
0x43c70000 : 5,
0x43c80000 : 6,
0x43c90000 : 7,
}

uart_port = {
'PS':'PS1',
0:0,
1:1,
2:2,
3:3,
4:4,
5:5,
6:6,
7:7,
8:8,
9:13,
10:10,
11:11,
12:12
}

port_silk = {
'PS0':'J14',
0 :'J4 - 232',
1 :'J11',
2 :'J12',
3 :'J13',
4 :'J7 - 485',
5 :'J8 - 485',
6 :'J4 - 485',
7 :'J5 - 485',
8 :'J16 - 485',
9 :None,
10:'J5 - 232',
11:'J7 - 232',
12:'J8 - 232',
13:'J16 - 232',
}

def main():
    import csv
    Fd = open("ports.csv","w")
    fieldnames = ['Kernel Name', 'Address', 'Vivado Device Name', 'Vivado Port Name', 'Silk Screen']
    writer = csv.DictWriter(Fd, fieldnames=fieldnames, delimiter=',', lineterminator='\n')
    writer.writeheader()
    for key in kernel_addy:
        if kernel_addy.get(key) == None:
            continue
        if addy_uart.get(kernel_addy.get(key)) == None:
            continue
        if uart_port.get(addy_uart.get(kernel_addy.get(key))) == None:
            continue
        if port_silk.get(uart_port.get(addy_uart.get(kernel_addy.get(key)))) == None:
            continue
        #print('{:02X}'.format(kernel_addy[key]))
        writer.writerow({'Kernel Name':key, 'Address': '{:02X}'.format(kernel_addy.get(key)),\
        'Vivado Device Name':addy_uart.get(kernel_addy.get(key)), 'Vivado Port Name':uart_port.get(addy_uart.get(kernel_addy.get(key))),\
        'Silk Screen':port_silk.get(uart_port.get(addy_uart.get(kernel_addy.get(key))))})
    Fd.close()

if __name__=="__main__":
    main()
