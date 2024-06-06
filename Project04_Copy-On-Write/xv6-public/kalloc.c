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
  int fp_cnt; // free page count
  int ref_cnt[NPHYS_PAGES]; // reference count
} kmem;

// Initialization happens in two phases.
// 1. main() calls kinit1() while still using entrypgdir to place just
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  kmem.fp_cnt = 0; // free page count
  for(int i = 0; i < NPHYS_PAGES; i++) {
    kmem.ref_cnt[i] = 0; // reference count
  }
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

  uint pa = V2P(v);

  if (kmem.use_lock)
    acquire(&kmem.lock);

  uint idx = pa / PGSIZE;
  if (kmem.ref_cnt[idx] > 0)
    kmem.ref_cnt[idx]--;
  if (kmem.ref_cnt[idx] > 0) {
    if (kmem.use_lock)
      release(&kmem.lock);
    return;
  }

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  kmem.fp_cnt++;

  if (kmem.use_lock)
    release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
  struct run *r;

  if (kmem.use_lock)
    acquire(&kmem.lock);

  r = kmem.freelist;
  if (r != 0) {
    kmem.freelist = r->next;
    kmem.fp_cnt--;

    uint idx = V2P((char*)r) / PGSIZE;
    kmem.ref_cnt[idx]++;
  }

  if (kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}

int 
countfp(void) 
{
  int count;
  acquire(&kmem.lock);
  count = kmem.fp_cnt;
  release(&kmem.lock);
  return count;
}

void 
incr_refc(uint pa) 
{
  uint idx = pa / PGSIZE;
  if (kmem.use_lock)
    acquire(&kmem.lock);
  kmem.ref_cnt[idx]++;
  if (kmem.use_lock)
    release(&kmem.lock);
}

void 
decr_refc(uint pa) 
{
  uint idx = pa / PGSIZE;
  if (kmem.use_lock)
    acquire(&kmem.lock);
  if (kmem.ref_cnt[idx] > 0)
    kmem.ref_cnt[idx]--;
  if (kmem.use_lock)
    release(&kmem.lock);
}

int 
get_refc(uint pa) 
{
  uint idx = pa / PGSIZE;
  int refc;
  if (kmem.use_lock)
    acquire(&kmem.lock);
  refc = kmem.ref_cnt[idx];
  if (kmem.use_lock)
    release(&kmem.lock);
  return refc;
}
