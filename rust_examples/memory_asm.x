SECTIONS
{
  . = 0x0;
  .text :
  {
    KEEP(*(.text)); 
  }  
  . = 0x50000000;
  .rodata :
  {
    KEEP(*(.rodata));  
  }
  . = 0x50000500;
  .data :
  {
      KEEP(*(.data));
  }
}

PROVIDE(_stack_start = 0x00010500);
