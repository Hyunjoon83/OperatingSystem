#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

extern uint ticks;
extern struct spinlock tickslock;

void printpinfo()
{
    int localTicks;
    struct proc *p = myproc();

    acquire(&tickslock);
    localTicks = ticks;
    release(&tickslock);

    while (1){
        cprintf("ticks: %d, pid = %d, name = %s\n", localTicks++, p->pid, p->name);
        yield();
    }
    exit();
}

int 
sys_printpinfo(void)
{
    printpinfo();
    return 0;
}