#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
int nexttid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){            // kstack에는 4096 byte의 메모리의 시작 주소가 저장됨
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;                // stack pointer를 kstacksize만큼 올림 (empty stack이기 때문)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;                        // Push trapframe to stack
  p->tf = (struct trapframe*)sp;              // trapframe의 주소를 stack pointer로 설정

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;                                    // 4 byte만큼 stack pointer를 내림
  *(uint*)sp = (uint)trapret;                 // trapret의 주소를 stack pointer에 저장

  sp -= sizeof *p->context;                   // Push context to stack
  p->context = (struct context*)sp;           // context의 주소를 stack pointer로 설정
  memset(p->context, 0, sizeof *p->context);  // context의 크기만큼 0으로 초기화
  p->context->eip = (uint)forkret;            // forkret의 주소를 context의 eip에 저장 (forkret은 trapret을 호출)

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();
  acquire(&ptable.lock);

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0){
      release(&ptable.lock);
      return -1;
    }
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0){
      release(&ptable.lock);
      return -1;
    }
  }
  curproc->sz = sz;

  release(&ptable.lock);
  switchuvm(curproc);
  return 0;
}


// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){ // 새로운 process에 부모 process의 page table을 복사
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd); // cwd : current working directory

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // exit() 호출 시 현재 process의 thread들을 모두 종료
  acquire(&ptable.lock);
  for (int i = 0; i < NTHREAD; i++) {
    if (curproc->threads[i] && curproc->threads[i]->state != T_UNUSED) {
      curproc->threads[i]->state = T_ZOMBIE;
    }
  }
  release(&ptable.lock);

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1; // 처음 forkret이 호출되었는지 확인
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

// 하나 이상의 thread가 kill되면 그 thread가 속한 process 내의 모든 thread가 정리되고 자원을 회수
// exec()에서 호출 - 
int
kill_threads(int pid)
{
  struct proc *p;
  struct thread *t;
  int kill_cnt = 0;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid && p->state != UNUSED){
      for(int i=0; i<NTHREAD; i++){
        t = p->threads[i];
        if(t && t->state != T_UNUSED && t->state != T_ZOMBIE){
          t->state = T_ZOMBIE;
          t->killed = 1;
          kill_cnt++;
        }
        if(kill_cnt > 0){
          p->killed = 1;
          wakeup1(p);
        }
      }
    }
  }
  release(&ptable.lock);
  return kill_cnt > 0 ? 0 : -1; // thread가 존재하면 0, 존재하지 않으면 -1 반환
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

// 새로운 thread 생성 및 시작 - fork와 비슷하지만 user stack을 별도로 할당해야 함
// 전체를 복사한 뒤, sp만 kalloc으로 할당한 stack으로 변경 - thread_exit에서 해제
// eip는 start_routine으로, esp는 sp로 설정
int
thread_create(thread_t *thread, void *(*start_routine)(void *), void *arg)
{
  struct proc *curproc = myproc();
  struct thread *t = 0;
  uint sp;

  acquire(&ptable.lock);  

  for(int i=0; i<NTHREAD; i++){
    if(curproc->threads[i]->state == T_UNUSED){
      t = curproc->threads[i];
      // Initialize thread structure
      t->state = T_UNUSED;
      t->tid = 0;
      t->tf = 0;
      t->pgdir = 0;
      // Set up new context to start executing at start_routine
      t->pgdir = curproc->pgdir;
      t->state = T_EMBRYO;
      t->tid = nexttid++;
      break;
    }
  }

  if(!t){
    cprintf("No available thread slot.\n");
    release(&ptable.lock);
    return -1;
  }

  *thread = t->tid; // 해당 주소에 thread id 저장

  // 새 thread를 위한 stack 할당
  sp = curproc->sz; // stack pointer를 process의 크기로 설정
  sp -= PGSIZE; // stack 크기만큼 stack pointer를 내림
  if(allocuvm(t->pgdir, sp, sp + PGSIZE) == 0){
    cprintf("Failed to allocate memory for thread stack.\n");
    t->state = T_UNUSED;
    release(&ptable.lock);
    return -1;
  }
  sp = sp + PGSIZE - 4;

  t->tf = (struct trapframe*)kalloc();
  if(t->tf == 0){
    cprintf("Failed to allocate trap frame.\n");
    deallocuvm(t->pgdir, sp, sp - PGSIZE);
    t->state = T_UNUSED;
    release(&ptable.lock);
    return -1;
  }

  // Prepare new context to start executing at start_routine
  t->tf->eip = (uint)start_routine; // thread가 시작할 함수 지정
  t->tf->esp = sp; // stack pointer
  t->tf->ebp = sp; // ebp는 esp와 같은 위치로 설정
  t->tf->eax = 0;  // return value

  
  sp -= 4;
  *(uint*)sp = (uint)arg; // Start_routine에 넘겨줄 인자
  sp -= 4;
  *(uint*)sp = 0xffffffff; // fake return PC
  t->tf->esp = sp; // stack pointer update

  cprintf("Thread %d created successfully.\n", t->tid);
  t->state = T_RUNNABLE;

  release(&ptable.lock);
  return 0;
}

// thread 종료 후 retval(thread_join에서 받아갈 값) 반환
// exit()와 비슷하지만 thread에 할당된 자원만 회수
void
thread_exit(void *retval)
{
  struct proc *p, *curproc = myproc();
  struct thread *t = 0;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  acquire(&ptable.lock);
  for(int i=0; i<NTHREAD; i++){
    if(curproc->threads[i] && curproc->threads[i]->state == T_RUNNING){
      t = curproc->threads[i];
      break;
    }
  }

  if(!t)
    panic("No running thread");

  t->state = T_ZOMBIE;
  t->retval = retval;

  wakeup1(t);

  int all_zombies = 1; // 모든 thread가 종료되었는지 확인
  for(int i=0; i<NTHREAD; i++){
    if(curproc->threads[i] != t){
      if(curproc->threads[i]->state != T_ZOMBIE && curproc->threads[i]->state != T_UNUSED){
        all_zombies = 0;
        break;
      }
    }
  }

  if(all_zombies){
    for(fd = 0; fd < NOFILE; fd++){
      if(curproc->ofile[fd]){
        fileclose(curproc->ofile[fd]);
        curproc->ofile[fd] = 0;
      }
    }
    begin_op();
    iput(curproc->cwd);
    end_op();
    curproc->cwd = 0;

    for(p=ptable.proc; p<&ptable.proc[NPROC]; p++){
      if(p->parent == curproc){
        p->parent = initproc;
        if(p->state == ZOMBIE)
          wakeup1(initproc);
      }
    }
    curproc->state = ZOMBIE;
  }
  sched();
  panic("zombie exit");
}

// 지정한 thread 종료 대기, thread_exit에서 반환한 값을 받아옴
// thread가 이미 종료 되었다면 즉시 반환
// wait()과 비슷하고, thread가 종료된 후 thread에 할당된 자원 (ptable, memory, ...) 회수, 정리
int
thread_join(thread_t thread, void **retval)
{
  struct proc *curproc = myproc();
  struct thread *t;
  int found = 0;

  acquire(&ptable.lock);
  while (1) {
    found = 0;
    for (int i = 0; i < NTHREAD; i++) {
      t = curproc->threads[i];
      if (t && t->tid == thread) {
        found = 1;
        if (t->state == T_ZOMBIE) {
          if (retval) 
            *retval = t->retval;

          // 자원 회수
          t->tid = 0;
          t->state = T_UNUSED;
          t->retval = 0;

          release(&ptable.lock);
          return 0;
        }
        break;
      }
    }

    // thread를 못찾았거나 이미 종료된 thread인 경우
    if (!found || curproc->killed) {
      release(&ptable.lock);
      return -1;
    }

    sleep(t, &ptable.lock);
  }
}
