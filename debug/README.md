# Debug interface experiment

## Openocd

For use with the BSCANE2 JTAG bridge, openocd can remap the the registers:

```shell
riscv set_ir idcode 0x09
riscv set_ir dtmcs 0x22
riscv set_ir dmi 0x23
```

## Telnet

```shell
telnet 127.0.0.1 4444
```
