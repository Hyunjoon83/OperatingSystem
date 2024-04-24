#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

int
getgpid(void)
{
    struct proc *curproc = myproc(); 
    if (curproc && curproc->parent) { 
        struct proc *parent = curproc->parent; 
        if (parent->parent) {
            return parent->parent->pid;
        }
    }
    return -1; 
}

// Wrapper for my_syscall
int
sys_getgpid(void)
{
    return getgpid();
}