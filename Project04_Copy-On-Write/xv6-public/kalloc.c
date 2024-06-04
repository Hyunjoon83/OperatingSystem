#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"

void freerange(void *vstart, void *vend);
extern char end[]; // first address after kernel loaded from ELF file
                   // defined by the kernel linker script in kernel.ld

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  int use_lock;
  struct run *freelist;
  int count; // free page count
} kmem;

struct {
  struct spinlock lock;
  int count[NPHYS_PAGES]; // reference count for each page
} refcount;

void
refcount_init(void)
{
  initlock(&refcount.lock, "refcount");
  for(int i = 0; i < NPHYS_PAGES; i++) {
    refcount.count[i] = 0;
  }
}

// Initialization happens in two phases.
// 1. main() calls kinit1() while still using entrypgdir to place just
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  refcount_init();
  kmem.use_lock = 0;
  kmem.count = 0;
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
    // Initialize reference count for each page to 1 when first freed
    kfree(p);
  }
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  uint pa = V2P(v);
  uint idx = pa / PGSIZE;

  refcount.count[idx]--;

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  kmem.count++;
  if(kmem.use_lock)
    release(&kmem.lock);
}



// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = kmem.freelist;
  if(r){
    kmem.freelist = r->next;
    kmem.count--;
  }

  if(kmem.use_lock)
    release(&kmem.lock);

  if (r) {
    memset((char*)r, 0, PGSIZE); // Zero out the allocated memory
    uint pa = V2P((char*)r);
    uint idx = pa / PGSIZE;
    refcount.count[idx]++; // Initialize reference count to 1 for the new page
  }

  return (char*)r;
}


// 시스템에 존재하는 free page의 총 개수 반환
int 
countfp(void) 
{
  int count = 0;
  acquire(&kmem.lock);
  count = kmem.count;
  release(&kmem.lock);
  return count;
}

void 
incr_refc(uint pa) 
{
  uint idx = pa / PGSIZE;
  acquire(&refcount.lock);
  refcount.count[idx]++;
  release(&refcount.lock);
}


void 
decr_refc(uint pa) 
{
  uint idx = pa / PGSIZE;
  acquire(&refcount.lock);
  if (refcount.count[idx] <= 0) {
    release(&refcount.lock);
    panic("decr_refc: invalid reference count");
  }
  refcount.count[idx]--;
  release(&refcount.lock);
}

int 
get_refc(uint pa) 
{
  int count;
  uint idx = pa / PGSIZE;
  acquire(&refcount.lock);
  count = refcount.count[idx];
  release(&refcount.lock);
  return count;
}
