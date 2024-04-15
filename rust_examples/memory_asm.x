SECTIONS
{
  . = 0x0;
  .text :
  {
    KEEP(*(.text)); 
  }  
  . = 0x10000;
  .data :
  {
    KEEP(*(.data));  
  }
  . = 0x20000;
  .rodata :
  {
    KEEP(*(.rodata));
  }
}

PROVIDE(_stack_start = 0x00010500);
