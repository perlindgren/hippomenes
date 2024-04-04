SECTIONS
{
  . = 0x0;
  .text :
  {
    KEEP(*(.text)); 
  }  

  . = 0x50000000;
  .data :
  {
    KEEP(*(.data));  
  }
}

PROVIDE(_stack_start = 0x50000500);
