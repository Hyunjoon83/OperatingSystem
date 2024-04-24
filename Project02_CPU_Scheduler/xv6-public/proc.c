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
int monopoly = 0; // CPU 독점 여부
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

// queue 구조체
struct queue{
  struct spinlock lock;
  struct proc *front;
  struct proc *rear;
  int timequantum; // 2*i+2
  int level;       // queuelevel
  int size;        // queue에 들어있는 process 개수
};

struct queue MLFQ[4];
struct queue MoQ;

void Enqueue(struct queue *q, struct proc *p)
{
  acquire(&q->lock);
  // queue가 가득 차있거나 queuelevel이 다른 경우
  if(q->size >= NPROC || p->queueLevel != q->level){
    release(&q->lock);
    return;
  }
  p->next = 0;
  if (q->front == 0) { // queue가 비어있는 경우
    q->front = q->rear = p; // queue에는 process 1개만 존재
    q->size=1;
  } else { // queue가 비어있지 않은 경우
    if(q->rear != 0){
      q->rear->next = p; // queue의 rear에 process 추가
      q->rear = p; // rear를 추가한 process로 변경
      q->size++; // q에 들어있는 process개수 증가
    }
  }
  // cprintf("Enqueue Level: L%d, pid %d\n", q->level, p->pid);
  release(&q->lock);
  return;
}

void Dequeue(struct queue *q, struct proc *p)  
{
  acquire(&q->lock);
  if (q->front == 0){ // queue가 비어있는 경우
    release(&q->lock);
    return;
  }

  struct proc *tmp = q->front;
  struct proc *prev = 0;

  while (tmp != 0){
    if (tmp == p){ // 빼낼 process를 찾은 경우
      if (prev == 0){ // p가 front인 경우
        q->front = tmp->next; // front를 다음 process로 변경
        if (q->rear == tmp){ // tmp밖에 없는 경우
          q->rear = 0; // rear를 0으로 변경
          q->size = 0;
        }
      }else{ // p가 front가 아닌 경우
        prev->next = tmp->next; // 이전 process의 next를 다음 process로 변경
        if (q->rear == tmp){ // p가 rear인 경우
          q->rear = prev; // rear를 이전 process로 변경
          q->size--; // q에 들어있는 process개수 감소
        }
      }
      tmp->next = 0; // queue에서 빼낸 process
      break;
    }
    prev = tmp; // tmp를 prev로 설정
    tmp = tmp->next; // tmp를 다음으로 이동
  }
  // cprintf("Dequeue Level: L%d, pid %d\n", q->level, p->pid);
  release(&q->lock);
  return;
}

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

  p->queueLevel = -1;  // enqueue되기 전까지는 queueLevel은 -1
  p->priority = 0; // 처음 process가 실행될 때 priority는 0
  p->timeQuantum = 0; // 처음 process가 실행될 때 timeQuantum은 0
  p->inMoQ = 0; // 처음엔 MoQ에 들어있지 않음

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

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

  // MLFQ 초기화
  for (int i = 0; i < 4; i++){
    MLFQ[i].front = MLFQ[i].rear = 0;
    MLFQ[i].timequantum = 2 * i + 2;
    MLFQ[i].level = i;
    MLFQ[i].size = 0;
  }

  p->state = RUNNABLE;

  // User process가 생성될 때, 새로운 process를 MLFQ[0]에 넣어줌
  p->queueLevel = 0;
  Enqueue(&MLFQ[0], p);

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
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
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
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
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  // fork 될 때마다 L0에 enqueue
  np->queueLevel = 0;
  Enqueue(&MLFQ[0], np);

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

// MLFQ[3]에서 최대 priority를 갖는 process return
struct proc* 
find_m_proc(void)
{
  struct proc* p = 0;
  struct proc* max_p = 0;
  int max_priority = -1;

  for(p = MLFQ[3].front; p != 0; p = p->next){
    if(p->priority > max_priority){
      max_priority = p->priority;
      max_p = p;
    }
  }
  return max_p;
}

void 
scheduling(struct cpu *c, struct proc *p)
{
  c->proc = p;
  switchuvm(p);
  p->state = RUNNING;
  swtch(&(c->scheduler), p->context);
  switchkvm();
  c->proc = 0;
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

  for (;;){
    sti();
    acquire(&ptable.lock);

    if (monopoly && MoQ.front != 0){
      for (p = MoQ.front; p != 0; p = p->next){
        if (p->state != RUNNABLE){
          if(p->state == SLEEPING || p->state == UNUSED){
            p->queueLevel = -1;
            Dequeue(&MoQ, p);
          }
        }else{
          scheduling(c, p);
          if (p->state == ZOMBIE){
            unmonopolize();
          }
        }
      }
    }

    for (int i=0; i<3; i++){
      for(p = MLFQ[i].front; p!=0; p=p->next){
        if(p->state != RUNNABLE){
          if(p->state == SLEEPING){
            Dequeue(&MLFQ[i], p);
          }else if(p->state == UNUSED){
            p->queueLevel = -1;
            Dequeue(&MLFQ[i], p);
          }
        }else{
          scheduling(c, p);
          if (p->state == ZOMBIE){
            p->queueLevel = -1;
            Dequeue(&MLFQ[i], p);
          }
        }
      }
    }

    int k = MLFQ[3].size;
    while (k--){
      if (MLFQ[3].size == 0){
        break;
      }else{
        struct proc *h_proc = find_m_proc();
        if(h_proc->state != RUNNABLE){
          if(h_proc->state == SLEEPING){
            Dequeue(&MLFQ[3], h_proc);
          }else if(h_proc->state == UNUSED){
            h_proc->priority = -1;
            Dequeue(&MLFQ[3], h_proc);
          }
        }else{
          scheduling(c, h_proc);
          if (h_proc->state == ZOMBIE){
            h_proc->queueLevel = -1;
            Dequeue(&MLFQ[3], h_proc);
          }
        }
      }
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
  yield2();
  release(&ptable.lock);
}

void
yield1(void)
{
  struct proc* p = myproc();

  p->state = RUNNABLE; 

  int level = p->queueLevel;
  p->queueLevel = -1;
  Dequeue(&MLFQ[level], p);

  if(level==0){
    if (p->pid % 2 == 0){
      p->queueLevel=2;
      Enqueue(&MLFQ[2], p); // L2 queue로 이동
    }else{
      p->queueLevel=1;
      Enqueue(&MLFQ[1], p); // L1 queue로 이동
    }
  }else if(level==3){
    if(p->priority > 0)
      p->priority--; 
    p->queueLevel = -1;
    Dequeue(&MLFQ[3], p);
    p->queueLevel = 3;
    Enqueue(&MLFQ[3], p);
  }else{
    p->queueLevel = 3;
    Enqueue(&MLFQ[3], p);
  }
  p->timeQuantum = 0;
  sched();
}

void
yield2(void) // yield without ptable lock
{
  myproc()->state = RUNNABLE;
  sched();
}

void
proc_yield(void)
{
  acquire(&ptable.lock);
  struct proc* p = myproc();
  if(monopoly){ // monopolize가 호출된 경우
    yield2(); // 먼저 들어온 순서대로 scheduling
  }else{
    p->timeQuantum++; // 1tick 마다 process의 timequantum을 늘려줌
    if(p->timeQuantum >= MLFQ[p->queueLevel].timequantum){
      //process가 timequantum 내에 끝나지 않은 경우
      yield1(); // 명세에 맞게 queue 이동
    }
  }
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
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

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == SLEEPING && p->chan == chan){
      p->state = RUNNABLE;
      if(p->inMoQ || monopoly){
        p->queueLevel = 99;
        Enqueue(&MoQ, p); // wakeup한 process가 MoQ에 속한 경우 MoQ에 넣어줌
      }else{
        Enqueue(&MLFQ[p->queueLevel], p); // wakeup한 process를 queue에 넣어줌
      }
    }
  }
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

// prevent starvation problem
// whenever global tick reaches 100 ticks, all processes are rescheduled to L0
// When priority boosting works, time quantum of every process is initialized to 2i+2
void 
priorityBoosting(void)
{
  acquire(&ptable.lock);
  // queue의 모든 process 탐색 -> 모든 process를 L0로 재조정
  for(int i=0; i<4; i++){
    for(struct proc* p = MLFQ[i].front; p!=0; p=p->next){
      p->queueLevel = -1;
      Dequeue(&MLFQ[i], p);
      p->timeQuantum = 0; // time quantum 초기화
      p->queueLevel = 0;
      Enqueue(&MLFQ[0], p);
    }
  }
  release(&ptable.lock); // Release the lock
}

// return level of queue that process belongs to
// if process which belongs to MoQ, return 99
int 
getlev(void)
{
  acquire(&ptable.lock);
  struct proc *p = myproc();
  int level;

  if (p->inMoQ){ // MoQ에 속한 프로세스인 경우 99 return
    level = 99;
  }else{
    level = p->queueLevel;
  }
  release(&ptable.lock);
  return level;
}

// set process priority that contains certain pid
// if setting pid is successfully done, return 0
// if pid is invalid, return -1
// if priority is not in range [0, 10], return -2
int 
setpriority(int pid, int priority)
{
  if (priority < 0 || priority > 10)
    return -2;

  acquire(&ptable.lock);
  struct proc *p;
  
  int found = 0;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if (p->pid == pid) {
      p->priority = priority;
      found = 1;
      break;
    }
  }
  release(&ptable.lock);
  return found ? 0 : -1;
}

// Move a process with a specific pid to the MoQ. Then receive a password (your student number(2021088304)) to prove your exclusive credentials as a factor.
// if password is correct, return size of MoQ
// if password is incorrect, return -2
// if process already exists in MoQ, return -3
// if process moves itself toward MoQ, return -4
int 
setmonopoly(int pid, int password) 
{
  acquire(&ptable.lock);          
  struct proc *curproc = myproc(); // 현재 프로세스
  if (curproc->pid == pid) { // 자기 자신을 MoQ로 이동시키는 경우
    release(&ptable.lock);
    return -4;
  }

  struct proc *p;
  int MoQSize = 0; // MoQ의 내부에 존재하는 process의 개수 (MoQ의 크기)

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if (p->pid == pid) {
      if (p->inMoQ) { // 이미 MoQ에 속한 프로세스인 경우
        release(&ptable.lock);
        return -3;
      }
      Dequeue(&MLFQ[p->queueLevel], p); // 현재 프로세스가 속한 queue에서 제거
      p->queueLevel = 99;
      p->inMoQ = 1;
      Enqueue(&MoQ, p); // MoQ로 이동
      break;
    }
  }
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if(p->inMoQ)
      MoQSize++;
  }
  release(&ptable.lock);
  
  if (password != 2021088304)
    return -2;
  else
    return MoQSize;
}

// Process in MoQ monopolizes CPU for a certain time quantum.
void 
monopolize(void)
{
  acquire(&ptable.lock);
  if (!monopoly) { // 독점 상태가 아닌 경우
    monopoly = 1; // CPU 독점
  }
  release(&ptable.lock);
}

// Stop monopolizing the CPU and return to the original MLFQ part.
void 
unmonopolize(void)
{
  acquire(&ptable.lock);
  struct proc *p = myproc();
  struct proc *tmp = MoQ.front;
  tmp->queueLevel = p->queueLevel; 

  if (p->inMoQ && monopoly) { // MoQ에 속한 CPU 독점 중인 프로세스인 경우
    monopoly = 0; // CPU 독점 해제
    while (!tmp) {
      tmp->queueLevel = -1;
      tmp->inMoQ = 0;
      Dequeue(&MoQ, tmp);
      Enqueue(&MLFQ[tmp->queueLevel], tmp);
    }
  }
  release(&ptable.lock);
}