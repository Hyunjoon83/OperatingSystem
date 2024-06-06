
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 e4 14 80       	mov    $0x8014e4d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 32 10 80       	mov    $0x80103270,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 76 10 80       	push   $0x80107660
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 85 45 00 00       	call   801045e0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 76 10 80       	push   $0x80107667
80100097:	50                   	push   %eax
80100098:	e8 13 44 00 00       	call   801044b0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 c7 46 00 00       	call   801047b0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 e9 45 00 00       	call   80104750 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 43 00 00       	call   801044f0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 6e 76 10 80       	push   $0x8010766e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 cd 43 00 00       	call   80104590 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 7f 76 10 80       	push   $0x8010767f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 43 00 00       	call   80104590 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 3c 43 00 00       	call   80104550 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 90 45 00 00       	call   801047b0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 df 44 00 00       	jmp    80104750 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 86 76 10 80       	push   $0x80107686
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 0b 45 00 00       	call   801047b0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 7e 3f 00 00       	call   80104250 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 99 38 00 00       	call   80103b80 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 55 44 00 00       	call   80104750 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 ff 43 00 00       	call   80104750 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 62 27 00 00       	call   80102b00 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 8d 76 10 80       	push   $0x8010768d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 0f 80 10 80 	movl   $0x8010800f,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 33 42 00 00       	call   80104600 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 a1 76 10 80       	push   $0x801076a1
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 01 5b 00 00       	call   80105f20 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 16 5a 00 00       	call   80105f20 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 0a 5a 00 00       	call   80105f20 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 fe 59 00 00       	call   80105f20 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 ba 43 00 00       	call   80104910 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 05 43 00 00       	call   80104870 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 a5 76 10 80       	push   $0x801076a5
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 00 42 00 00       	call   801047b0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 67 41 00 00       	call   80104750 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 d0 76 10 80 	movzbl -0x7fef8930(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 c3 3f 00 00       	call   801047b0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf b8 76 10 80       	mov    $0x801076b8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 f0 3e 00 00       	call   80104750 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 bf 76 10 80       	push   $0x801076bf
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 18 3f 00 00       	call   801047b0 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 7b 3d 00 00       	call   80104750 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 dd 39 00 00       	jmp    801043f0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 c7 38 00 00       	call   80104310 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 c8 76 10 80       	push   $0x801076c8
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 6b 3b 00 00       	call   801045e0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 bf 30 00 00       	call   80103b80 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 a4 24 00 00       	call   80102f70 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 cc 24 00 00       	call   80102fe0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 77 65 00 00       	call   801070b0 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 28 63 00 00       	call   80106ed0 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 02 62 00 00       	call   80106de0 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 10 64 00 00       	call   80107030 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 8a 23 00 00       	call   80102fe0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 69 62 00 00       	call   80106ed0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 c8 64 00 00       	call   80107150 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 98 3d 00 00       	call   80104a70 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 84 3d 00 00       	call   80104a70 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 f3 65 00 00       	call   801072f0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 1a 63 00 00       	call   80107030 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 88 65 00 00       	call   801072f0 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 8a 3c 00 00       	call   80104a30 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 7e 5e 00 00       	call   80106c50 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 56 62 00 00       	call   80107030 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 f7 21 00 00       	call   80102fe0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 e1 76 10 80       	push   $0x801076e1
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 ed 76 10 80       	push   $0x801076ed
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 bb 37 00 00       	call   801045e0 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ff 10 80       	push   $0x8010ff60
80100e41:	e8 6a 39 00 00       	call   801047b0 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ff 10 80       	push   $0x8010ff60
80100e71:	e8 da 38 00 00       	call   80104750 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ff 10 80       	push   $0x8010ff60
80100e8a:	e8 c1 38 00 00       	call   80104750 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ff 10 80       	push   $0x8010ff60
80100eaf:	e8 fc 38 00 00       	call   801047b0 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ff 10 80       	push   $0x8010ff60
80100ecc:	e8 7f 38 00 00       	call   80104750 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 f4 76 10 80       	push   $0x801076f4
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 aa 38 00 00       	call   801047b0 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 0f 38 00 00       	call   80104750 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 dd 37 00 00       	jmp    80104750 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 f3 1f 00 00       	call   80102f70 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 49 20 00 00       	jmp    80102fe0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 92 27 00 00       	call   80103740 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 fc 76 10 80       	push   $0x801076fc
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 4e 28 00 00       	jmp    801038e0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 06 77 10 80       	push   $0x80107706
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 d2 1e 00 00       	call   80102fe0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 3d 1e 00 00       	call   80102f70 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 76 1e 00 00       	call   80102fe0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 0f 77 10 80       	push   $0x8010770f
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 32 26 00 00       	jmp    801037e0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 15 77 10 80       	push   $0x80107715
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 3e 1f 00 00       	call   80103150 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 1f 77 10 80       	push   $0x8010771f
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 32 77 10 80       	push   $0x80107732
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 4e 1e 00 00       	call   80103150 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 46 35 00 00       	call   80104870 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 1e 1e 00 00       	call   80103150 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 09 11 80       	push   $0x80110960
8010136a:	e8 41 34 00 00       	call   801047b0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 60 09 11 80       	push   $0x80110960
801013d7:	e8 74 33 00 00       	call   80104750 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 46 33 00 00       	call   80104750 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 48 77 10 80       	push   $0x80107748
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 86 1c 00 00       	call   80103150 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 58 77 10 80       	push   $0x80107758
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 ca 33 00 00       	call   80104910 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 6b 77 10 80       	push   $0x8010776b
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 65 30 00 00       	call   801045e0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 72 77 10 80       	push   $0x80107772
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 1c 2f 00 00       	call   801044b0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 b4 25 11 80       	push   $0x801125b4
801015bc:	e8 4f 33 00 00       	call   80104910 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 25 11 80    	push   0x801125cc
801015cf:	ff 35 c8 25 11 80    	push   0x801125c8
801015d5:	ff 35 c4 25 11 80    	push   0x801125c4
801015db:	ff 35 c0 25 11 80    	push   0x801125c0
801015e1:	ff 35 bc 25 11 80    	push   0x801125bc
801015e7:	ff 35 b8 25 11 80    	push   0x801125b8
801015ed:	ff 35 b4 25 11 80    	push   0x801125b4
801015f3:	68 d8 77 10 80       	push   $0x801077d8
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 dd 31 00 00       	call   80104870 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 ab 1a 00 00       	call   80103150 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 78 77 10 80       	push   $0x80107778
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 da 31 00 00       	call   80104910 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 12 1a 00 00       	call   80103150 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 60 09 11 80       	push   $0x80110960
8010175f:	e8 4c 30 00 00       	call   801047b0 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 dc 2f 00 00       	call   80104750 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 49 2d 00 00       	call   801044f0 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 f3 30 00 00       	call   80104910 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 90 77 10 80       	push   $0x80107790
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 8a 77 10 80       	push   $0x8010778a
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 18 2d 00 00       	call   80104590 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 bc 2c 00 00       	jmp    80104550 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 9f 77 10 80       	push   $0x8010779f
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 2b 2c 00 00       	call   801044f0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 71 2c 00 00       	call   80104550 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 c5 2e 00 00       	call   801047b0 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 4b 2e 00 00       	jmp    80104750 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 9b 2e 00 00       	call   801047b0 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 2c 2e 00 00       	call   80104750 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 68 2b 00 00       	call   80104590 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 11 2b 00 00       	call   80104550 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 9f 77 10 80       	push   $0x8010779f
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 d4 2d 00 00       	call   80104910 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 d8 2c 00 00       	call   80104910 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 10 15 00 00       	call   80103150 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 ad 2c 00 00       	call   80104980 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 4e 2c 00 00       	call   80104980 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 b9 77 10 80       	push   $0x801077b9
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 a7 77 10 80       	push   $0x801077a7
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 d1 1d 00 00       	call   80103b80 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 09 11 80       	push   $0x80110960
80101dba:	e8 f1 29 00 00       	call   801047b0 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 81 29 00 00       	call   80104750 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 e4 2a 00 00       	call   80104910 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 ff 26 00 00       	call   80104590 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 9d 26 00 00       	call   80104550 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 30 2a 00 00       	call   80104910 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 60 26 00 00       	call   80104590 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 01 26 00 00       	call   80104550 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 1e 26 00 00       	call   80104590 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 fb 25 00 00       	call   80104590 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 a4 25 00 00       	call   80104550 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 9f 77 10 80       	push   $0x8010779f
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 8e 29 00 00       	call   801049d0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 c8 77 10 80       	push   $0x801077c8
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 ae 7d 10 80       	push   $0x80107dae
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 34 78 10 80       	push   $0x80107834
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 2b 78 10 80       	push   $0x8010782b
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 46 78 10 80       	push   $0x80107846
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 0b 24 00 00       	call   801045e0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 a7 14 80       	mov    0x8014a784,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 00 26 11 80       	push   $0x80112600
8010224e:	e8 5d 25 00 00       	call   801047b0 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 5e 20 00 00       	call   80104310 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 26 11 80       	push   $0x80112600
801022cb:	e8 80 24 00 00       	call   80104750 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 9d 22 00 00       	call   80104590 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 26 11 80       	push   $0x80112600
80102328:	e8 83 24 00 00       	call   801047b0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 00 26 11 80       	push   $0x80112600
80102368:	53                   	push   %ebx
80102369:	e8 e2 1e 00 00       	call   80104250 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 c5 23 00 00       	jmp    80104750 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 75 78 10 80       	push   $0x80107875
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 60 78 10 80       	push   $0x80107860
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 4a 78 10 80       	push   $0x8010784a
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 a7 14 80 	movzbl 0x8014a780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 94 78 10 80       	push   $0x80107894
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	56                   	push   %esi
801024c4:	8b 75 08             	mov    0x8(%ebp),%esi
801024c7:	53                   	push   %ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024c8:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
801024ce:	0f 85 b9 00 00 00    	jne    8010258d <kfree+0xcd>
801024d4:	81 fe d0 e4 14 80    	cmp    $0x8014e4d0,%esi
801024da:	0f 82 ad 00 00 00    	jb     8010258d <kfree+0xcd>
801024e0:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
801024e6:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
801024ec:	0f 87 9b 00 00 00    	ja     8010258d <kfree+0xcd>
    panic("kfree");

  uint pa = V2P(v);

  if (kmem.use_lock)
801024f2:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024f8:	85 d2                	test   %edx,%edx
801024fa:	75 7c                	jne    80102578 <kfree+0xb8>
    acquire(&kmem.lock);

  uint idx = pa / PGSIZE;
801024fc:	c1 eb 0c             	shr    $0xc,%ebx
  if (kmem.ref_cnt[idx] > 0)
801024ff:	83 c3 10             	add    $0x10,%ebx
80102502:	8b 04 9d 40 26 11 80 	mov    -0x7feed9c0(,%ebx,4),%eax
80102509:	85 c0                	test   %eax,%eax
8010250b:	7e 23                	jle    80102530 <kfree+0x70>
    kmem.ref_cnt[idx]--;
8010250d:	83 e8 01             	sub    $0x1,%eax
80102510:	89 04 9d 40 26 11 80 	mov    %eax,-0x7feed9c0(,%ebx,4)
  if (kmem.ref_cnt[idx] > 0) {
80102517:	74 17                	je     80102530 <kfree+0x70>
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  kmem.fp_cnt++;

  if (kmem.use_lock)
80102519:	a1 74 26 11 80       	mov    0x80112674,%eax
8010251e:	85 c0                	test   %eax,%eax
80102520:	75 3e                	jne    80102560 <kfree+0xa0>
    release(&kmem.lock);
}
80102522:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102525:	5b                   	pop    %ebx
80102526:	5e                   	pop    %esi
80102527:	5d                   	pop    %ebp
80102528:	c3                   	ret    
80102529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  memset(v, 1, PGSIZE);
80102530:	83 ec 04             	sub    $0x4,%esp
80102533:	68 00 10 00 00       	push   $0x1000
80102538:	6a 01                	push   $0x1
8010253a:	56                   	push   %esi
8010253b:	e8 30 23 00 00       	call   80104870 <memset>
  r->next = kmem.freelist;
80102540:	a1 78 26 11 80       	mov    0x80112678,%eax
  if (kmem.use_lock)
80102545:	83 c4 10             	add    $0x10,%esp
  r->next = kmem.freelist;
80102548:	89 06                	mov    %eax,(%esi)
  if (kmem.use_lock)
8010254a:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.fp_cnt++;
8010254f:	83 05 7c 26 11 80 01 	addl   $0x1,0x8011267c
  kmem.freelist = r;
80102556:	89 35 78 26 11 80    	mov    %esi,0x80112678
  if (kmem.use_lock)
8010255c:	85 c0                	test   %eax,%eax
8010255e:	74 c2                	je     80102522 <kfree+0x62>
      release(&kmem.lock);
80102560:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102567:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010256a:	5b                   	pop    %ebx
8010256b:	5e                   	pop    %esi
8010256c:	5d                   	pop    %ebp
      release(&kmem.lock);
8010256d:	e9 de 21 00 00       	jmp    80104750 <release>
80102572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102578:	83 ec 0c             	sub    $0xc,%esp
8010257b:	68 40 26 11 80       	push   $0x80112640
80102580:	e8 2b 22 00 00       	call   801047b0 <acquire>
80102585:	83 c4 10             	add    $0x10,%esp
80102588:	e9 6f ff ff ff       	jmp    801024fc <kfree+0x3c>
    panic("kfree");
8010258d:	83 ec 0c             	sub    $0xc,%esp
80102590:	68 c6 78 10 80       	push   $0x801078c6
80102595:	e8 e6 dd ff ff       	call   80100380 <panic>
8010259a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801025a0 <freerange>:
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025a4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025a7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025aa:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
801025b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025bd:	39 de                	cmp    %ebx,%esi
801025bf:	72 23                	jb     801025e4 <freerange+0x44>
801025c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025c8:	83 ec 0c             	sub    $0xc,%esp
801025cb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
801025d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025d7:	50                   	push   %eax
801025d8:	e8 e3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
801025dd:	83 c4 10             	add    $0x10,%esp
801025e0:	39 f3                	cmp    %esi,%ebx
801025e2:	76 e4                	jbe    801025c8 <freerange+0x28>
}
801025e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025e7:	5b                   	pop    %ebx
801025e8:	5e                   	pop    %esi
801025e9:	5d                   	pop    %ebp
801025ea:	c3                   	ret    
801025eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025ef:	90                   	nop

801025f0 <kinit2>:
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025f4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025f7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025fa:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025fb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102601:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102607:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010260d:	39 de                	cmp    %ebx,%esi
8010260f:	72 23                	jb     80102634 <kinit2+0x44>
80102611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102618:	83 ec 0c             	sub    $0xc,%esp
8010261b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102621:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102627:	50                   	push   %eax
80102628:	e8 93 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
8010262d:	83 c4 10             	add    $0x10,%esp
80102630:	39 de                	cmp    %ebx,%esi
80102632:	73 e4                	jae    80102618 <kinit2+0x28>
  kmem.use_lock = 1;
80102634:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010263b:	00 00 00 
}
8010263e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102641:	5b                   	pop    %ebx
80102642:	5e                   	pop    %esi
80102643:	5d                   	pop    %ebp
80102644:	c3                   	ret    
80102645:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010264c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102650 <kinit1>:
{
80102650:	55                   	push   %ebp
80102651:	89 e5                	mov    %esp,%ebp
80102653:	56                   	push   %esi
80102654:	53                   	push   %ebx
80102655:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102658:	83 ec 08             	sub    $0x8,%esp
8010265b:	68 cc 78 10 80       	push   $0x801078cc
80102660:	68 40 26 11 80       	push   $0x80112640
80102665:	e8 76 1f 00 00       	call   801045e0 <initlock>
  kmem.fp_cnt = 0; // free page count
8010266a:	83 c4 10             	add    $0x10,%esp
  for(int i = 0; i < NPHYS_PAGES; i++) {
8010266d:	31 c0                	xor    %eax,%eax
  kmem.use_lock = 0;
8010266f:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102676:	00 00 00 
  kmem.fp_cnt = 0; // free page count
80102679:	c7 05 7c 26 11 80 00 	movl   $0x0,0x8011267c
80102680:	00 00 00 
  for(int i = 0; i < NPHYS_PAGES; i++) {
80102683:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102687:	90                   	nop
    kmem.ref_cnt[i] = 0; // reference count
80102688:	c7 04 85 80 26 11 80 	movl   $0x0,-0x7feed980(,%eax,4)
8010268f:	00 00 00 00 
  for(int i = 0; i < NPHYS_PAGES; i++) {
80102693:	83 c0 01             	add    $0x1,%eax
80102696:	3d 00 e0 00 00       	cmp    $0xe000,%eax
8010269b:	75 eb                	jne    80102688 <kinit1+0x38>
  p = (char*)PGROUNDUP((uint)vstart);
8010269d:	8b 45 08             	mov    0x8(%ebp),%eax
801026a0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026a6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
801026ac:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026b2:	39 de                	cmp    %ebx,%esi
801026b4:	72 26                	jb     801026dc <kinit1+0x8c>
801026b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026bd:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801026c0:	83 ec 0c             	sub    $0xc,%esp
801026c3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
801026c9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026cf:	50                   	push   %eax
801026d0:	e8 eb fd ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
801026d5:	83 c4 10             	add    $0x10,%esp
801026d8:	39 de                	cmp    %ebx,%esi
801026da:	73 e4                	jae    801026c0 <kinit1+0x70>
}
801026dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026df:	5b                   	pop    %ebx
801026e0:	5e                   	pop    %esi
801026e1:	5d                   	pop    %ebp
801026e2:	c3                   	ret    
801026e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801026f0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801026f0:	55                   	push   %ebp
801026f1:	89 e5                	mov    %esp,%ebp
801026f3:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if (kmem.use_lock)
801026f6:	8b 0d 74 26 11 80    	mov    0x80112674,%ecx
801026fc:	85 c9                	test   %ecx,%ecx
801026fe:	75 50                	jne    80102750 <kalloc+0x60>
    acquire(&kmem.lock);

  r = kmem.freelist;
80102700:	a1 78 26 11 80       	mov    0x80112678,%eax
  if (r != 0) {
80102705:	85 c0                	test   %eax,%eax
80102707:	74 24                	je     8010272d <kalloc+0x3d>
    kmem.freelist = r->next;
80102709:	8b 10                	mov    (%eax),%edx
    kmem.fp_cnt--;
8010270b:	83 2d 7c 26 11 80 01 	subl   $0x1,0x8011267c
    kmem.freelist = r->next;
80102712:	89 15 78 26 11 80    	mov    %edx,0x80112678

    uint idx = V2P((char*)r) / PGSIZE;
80102718:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
8010271e:	c1 ea 0c             	shr    $0xc,%edx
    kmem.ref_cnt[idx]++;
80102721:	83 04 95 80 26 11 80 	addl   $0x1,-0x7feed980(,%edx,4)
80102728:	01 
  }

  if (kmem.use_lock)
80102729:	85 c9                	test   %ecx,%ecx
8010272b:	75 03                	jne    80102730 <kalloc+0x40>
    release(&kmem.lock);
  return (char*)r;
}
8010272d:	c9                   	leave  
8010272e:	c3                   	ret    
8010272f:	90                   	nop
    release(&kmem.lock);
80102730:	83 ec 0c             	sub    $0xc,%esp
80102733:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102736:	68 40 26 11 80       	push   $0x80112640
8010273b:	e8 10 20 00 00       	call   80104750 <release>
  return (char*)r;
80102740:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102743:	83 c4 10             	add    $0x10,%esp
}
80102746:	c9                   	leave  
80102747:	c3                   	ret    
80102748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010274f:	90                   	nop
    acquire(&kmem.lock);
80102750:	83 ec 0c             	sub    $0xc,%esp
80102753:	68 40 26 11 80       	push   $0x80112640
80102758:	e8 53 20 00 00       	call   801047b0 <acquire>
  r = kmem.freelist;
8010275d:	a1 78 26 11 80       	mov    0x80112678,%eax
  if (kmem.use_lock)
80102762:	8b 0d 74 26 11 80    	mov    0x80112674,%ecx
  if (r != 0) {
80102768:	83 c4 10             	add    $0x10,%esp
8010276b:	85 c0                	test   %eax,%eax
8010276d:	75 9a                	jne    80102709 <kalloc+0x19>
8010276f:	eb b8                	jmp    80102729 <kalloc+0x39>
80102771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277f:	90                   	nop

80102780 <countfp>:

int 
countfp(void) 
{
80102780:	55                   	push   %ebp
80102781:	89 e5                	mov    %esp,%ebp
80102783:	53                   	push   %ebx
80102784:	83 ec 10             	sub    $0x10,%esp
  int count;
  acquire(&kmem.lock);
80102787:	68 40 26 11 80       	push   $0x80112640
8010278c:	e8 1f 20 00 00       	call   801047b0 <acquire>
  count = kmem.fp_cnt;
80102791:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  release(&kmem.lock);
80102797:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010279e:	e8 ad 1f 00 00       	call   80104750 <release>
  return count;
}
801027a3:	89 d8                	mov    %ebx,%eax
801027a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027a8:	c9                   	leave  
801027a9:	c3                   	ret    
801027aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801027b0 <incr_refc>:

void 
incr_refc(uint pa) 
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
801027b3:	53                   	push   %ebx
801027b4:	83 ec 04             	sub    $0x4,%esp
  uint idx = pa / PGSIZE;
801027b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (kmem.use_lock)
801027ba:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  uint idx = pa / PGSIZE;
801027c0:	c1 eb 0c             	shr    $0xc,%ebx
  if (kmem.use_lock)
801027c3:	85 d2                	test   %edx,%edx
801027c5:	75 11                	jne    801027d8 <incr_refc+0x28>
    acquire(&kmem.lock);
  kmem.ref_cnt[idx]++;
801027c7:	83 04 9d 80 26 11 80 	addl   $0x1,-0x7feed980(,%ebx,4)
801027ce:	01 
  if (kmem.use_lock)
    release(&kmem.lock);
}
801027cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027d2:	c9                   	leave  
801027d3:	c3                   	ret    
801027d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
801027d8:	83 ec 0c             	sub    $0xc,%esp
801027db:	68 40 26 11 80       	push   $0x80112640
801027e0:	e8 cb 1f 00 00       	call   801047b0 <acquire>
  if (kmem.use_lock)
801027e5:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.ref_cnt[idx]++;
801027ea:	83 04 9d 80 26 11 80 	addl   $0x1,-0x7feed980(,%ebx,4)
801027f1:	01 
  if (kmem.use_lock)
801027f2:	83 c4 10             	add    $0x10,%esp
801027f5:	85 c0                	test   %eax,%eax
801027f7:	74 d6                	je     801027cf <incr_refc+0x1f>
    release(&kmem.lock);
801027f9:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102800:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102803:	c9                   	leave  
    release(&kmem.lock);
80102804:	e9 47 1f 00 00       	jmp    80104750 <release>
80102809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102810 <decr_refc>:

void 
decr_refc(uint pa) 
{
80102810:	55                   	push   %ebp
80102811:	89 e5                	mov    %esp,%ebp
80102813:	53                   	push   %ebx
80102814:	83 ec 04             	sub    $0x4,%esp
  uint idx = pa / PGSIZE;
80102817:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (kmem.use_lock)
8010281a:	a1 74 26 11 80       	mov    0x80112674,%eax
  uint idx = pa / PGSIZE;
8010281f:	c1 eb 0c             	shr    $0xc,%ebx
  if (kmem.use_lock)
80102822:	85 c0                	test   %eax,%eax
80102824:	75 22                	jne    80102848 <decr_refc+0x38>
    acquire(&kmem.lock);
  if (kmem.ref_cnt[idx] > 0)
80102826:	83 c3 10             	add    $0x10,%ebx
80102829:	8b 04 9d 40 26 11 80 	mov    -0x7feed9c0(,%ebx,4),%eax
80102830:	85 c0                	test   %eax,%eax
80102832:	7e 0a                	jle    8010283e <decr_refc+0x2e>
    kmem.ref_cnt[idx]--;
80102834:	83 e8 01             	sub    $0x1,%eax
80102837:	89 04 9d 40 26 11 80 	mov    %eax,-0x7feed9c0(,%ebx,4)
  if (kmem.use_lock)
    release(&kmem.lock);
}
8010283e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102841:	c9                   	leave  
80102842:	c3                   	ret    
80102843:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102847:	90                   	nop
    acquire(&kmem.lock);
80102848:	83 ec 0c             	sub    $0xc,%esp
  if (kmem.ref_cnt[idx] > 0)
8010284b:	83 c3 10             	add    $0x10,%ebx
    acquire(&kmem.lock);
8010284e:	68 40 26 11 80       	push   $0x80112640
80102853:	e8 58 1f 00 00       	call   801047b0 <acquire>
  if (kmem.ref_cnt[idx] > 0)
80102858:	8b 04 9d 40 26 11 80 	mov    -0x7feed9c0(,%ebx,4),%eax
  if (kmem.use_lock)
8010285f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if (kmem.ref_cnt[idx] > 0)
80102865:	83 c4 10             	add    $0x10,%esp
80102868:	85 c0                	test   %eax,%eax
8010286a:	7e 0a                	jle    80102876 <decr_refc+0x66>
    kmem.ref_cnt[idx]--;
8010286c:	83 e8 01             	sub    $0x1,%eax
8010286f:	89 04 9d 40 26 11 80 	mov    %eax,-0x7feed9c0(,%ebx,4)
  if (kmem.use_lock)
80102876:	85 d2                	test   %edx,%edx
80102878:	74 c4                	je     8010283e <decr_refc+0x2e>
    release(&kmem.lock);
8010287a:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102881:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102884:	c9                   	leave  
    release(&kmem.lock);
80102885:	e9 c6 1e 00 00       	jmp    80104750 <release>
8010288a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102890 <get_refc>:

int 
get_refc(uint pa) 
{
80102890:	55                   	push   %ebp
80102891:	89 e5                	mov    %esp,%ebp
80102893:	53                   	push   %ebx
80102894:	83 ec 14             	sub    $0x14,%esp
  uint idx = pa / PGSIZE;
80102897:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int refc;
  if (kmem.use_lock)
8010289a:	8b 0d 74 26 11 80    	mov    0x80112674,%ecx
  uint idx = pa / PGSIZE;
801028a0:	c1 eb 0c             	shr    $0xc,%ebx
  if (kmem.use_lock)
801028a3:	85 c9                	test   %ecx,%ecx
801028a5:	75 11                	jne    801028b8 <get_refc+0x28>
    acquire(&kmem.lock);
  refc = kmem.ref_cnt[idx];
801028a7:	8b 04 9d 80 26 11 80 	mov    -0x7feed980(,%ebx,4),%eax
  if (kmem.use_lock)
    release(&kmem.lock);
  return refc;
}
801028ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028b1:	c9                   	leave  
801028b2:	c3                   	ret    
801028b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028b7:	90                   	nop
    acquire(&kmem.lock);
801028b8:	83 ec 0c             	sub    $0xc,%esp
801028bb:	68 40 26 11 80       	push   $0x80112640
801028c0:	e8 eb 1e 00 00       	call   801047b0 <acquire>
  if (kmem.use_lock)
801028c5:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  refc = kmem.ref_cnt[idx];
801028cb:	8b 04 9d 80 26 11 80 	mov    -0x7feed980(,%ebx,4),%eax
  if (kmem.use_lock)
801028d2:	83 c4 10             	add    $0x10,%esp
801028d5:	85 d2                	test   %edx,%edx
801028d7:	74 d5                	je     801028ae <get_refc+0x1e>
    release(&kmem.lock);
801028d9:	83 ec 0c             	sub    $0xc,%esp
801028dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028df:	68 40 26 11 80       	push   $0x80112640
801028e4:	e8 67 1e 00 00       	call   80104750 <release>
  return refc;
801028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801028ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    release(&kmem.lock);
801028ef:	83 c4 10             	add    $0x10,%esp
}
801028f2:	c9                   	leave  
801028f3:	c3                   	ret    
801028f4:	66 90                	xchg   %ax,%ax
801028f6:	66 90                	xchg   %ax,%ax
801028f8:	66 90                	xchg   %ax,%ax
801028fa:	66 90                	xchg   %ax,%ax
801028fc:	66 90                	xchg   %ax,%ax
801028fe:	66 90                	xchg   %ax,%ax

80102900 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102900:	ba 64 00 00 00       	mov    $0x64,%edx
80102905:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102906:	a8 01                	test   $0x1,%al
80102908:	0f 84 c2 00 00 00    	je     801029d0 <kbdgetc+0xd0>
{
8010290e:	55                   	push   %ebp
8010290f:	ba 60 00 00 00       	mov    $0x60,%edx
80102914:	89 e5                	mov    %esp,%ebp
80102916:	53                   	push   %ebx
80102917:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102918:	8b 1d 80 a6 14 80    	mov    0x8014a680,%ebx
  data = inb(KBDATAP);
8010291e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102921:	3c e0                	cmp    $0xe0,%al
80102923:	74 5b                	je     80102980 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102925:	89 da                	mov    %ebx,%edx
80102927:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010292a:	84 c0                	test   %al,%al
8010292c:	78 62                	js     80102990 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010292e:	85 d2                	test   %edx,%edx
80102930:	74 09                	je     8010293b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102932:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102935:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102938:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010293b:	0f b6 91 00 7a 10 80 	movzbl -0x7fef8600(%ecx),%edx
  shift ^= togglecode[data];
80102942:	0f b6 81 00 79 10 80 	movzbl -0x7fef8700(%ecx),%eax
  shift |= shiftcode[data];
80102949:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010294b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010294d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010294f:	89 15 80 a6 14 80    	mov    %edx,0x8014a680
  c = charcode[shift & (CTL | SHIFT)][data];
80102955:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102958:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010295b:	8b 04 85 e0 78 10 80 	mov    -0x7fef8720(,%eax,4),%eax
80102962:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102966:	74 0b                	je     80102973 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102968:	8d 50 9f             	lea    -0x61(%eax),%edx
8010296b:	83 fa 19             	cmp    $0x19,%edx
8010296e:	77 48                	ja     801029b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102970:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102973:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102976:	c9                   	leave  
80102977:	c3                   	ret    
80102978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010297f:	90                   	nop
    shift |= E0ESC;
80102980:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102983:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102985:	89 1d 80 a6 14 80    	mov    %ebx,0x8014a680
}
8010298b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010298e:	c9                   	leave  
8010298f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102990:	83 e0 7f             	and    $0x7f,%eax
80102993:	85 d2                	test   %edx,%edx
80102995:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102998:	0f b6 81 00 7a 10 80 	movzbl -0x7fef8600(%ecx),%eax
8010299f:	83 c8 40             	or     $0x40,%eax
801029a2:	0f b6 c0             	movzbl %al,%eax
801029a5:	f7 d0                	not    %eax
801029a7:	21 d8                	and    %ebx,%eax
}
801029a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801029ac:	a3 80 a6 14 80       	mov    %eax,0x8014a680
    return 0;
801029b1:	31 c0                	xor    %eax,%eax
}
801029b3:	c9                   	leave  
801029b4:	c3                   	ret    
801029b5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801029b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801029bb:	8d 50 20             	lea    0x20(%eax),%edx
}
801029be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029c1:	c9                   	leave  
      c += 'a' - 'A';
801029c2:	83 f9 1a             	cmp    $0x1a,%ecx
801029c5:	0f 42 c2             	cmovb  %edx,%eax
}
801029c8:	c3                   	ret    
801029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801029d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801029d5:	c3                   	ret    
801029d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029dd:	8d 76 00             	lea    0x0(%esi),%esi

801029e0 <kbdintr>:

void
kbdintr(void)
{
801029e0:	55                   	push   %ebp
801029e1:	89 e5                	mov    %esp,%ebp
801029e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801029e6:	68 00 29 10 80       	push   $0x80102900
801029eb:	e8 90 de ff ff       	call   80100880 <consoleintr>
}
801029f0:	83 c4 10             	add    $0x10,%esp
801029f3:	c9                   	leave  
801029f4:	c3                   	ret    
801029f5:	66 90                	xchg   %ax,%ax
801029f7:	66 90                	xchg   %ax,%ax
801029f9:	66 90                	xchg   %ax,%ax
801029fb:	66 90                	xchg   %ax,%ax
801029fd:	66 90                	xchg   %ax,%ax
801029ff:	90                   	nop

80102a00 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102a00:	a1 84 a6 14 80       	mov    0x8014a684,%eax
80102a05:	85 c0                	test   %eax,%eax
80102a07:	0f 84 cb 00 00 00    	je     80102ad8 <lapicinit+0xd8>
  lapic[index] = value;
80102a0d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102a14:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a17:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a1a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102a21:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a24:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a27:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102a2e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a31:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a34:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a3b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a3e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a41:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a48:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a4b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a4e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a55:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a58:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a5b:	8b 50 30             	mov    0x30(%eax),%edx
80102a5e:	c1 ea 10             	shr    $0x10,%edx
80102a61:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102a67:	75 77                	jne    80102ae0 <lapicinit+0xe0>
  lapic[index] = value;
80102a69:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a70:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a73:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a76:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a7d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a80:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a83:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a8a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a8d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a90:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a97:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a9a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a9d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102aa4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aaa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102ab1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab4:	8b 50 20             	mov    0x20(%eax),%edx
80102ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102abe:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102ac0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102ac6:	80 e6 10             	and    $0x10,%dh
80102ac9:	75 f5                	jne    80102ac0 <lapicinit+0xc0>
  lapic[index] = value;
80102acb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102ad2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ad5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102ad8:	c3                   	ret    
80102ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102ae0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102ae7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102aea:	8b 50 20             	mov    0x20(%eax),%edx
}
80102aed:	e9 77 ff ff ff       	jmp    80102a69 <lapicinit+0x69>
80102af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102b00 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102b00:	a1 84 a6 14 80       	mov    0x8014a684,%eax
80102b05:	85 c0                	test   %eax,%eax
80102b07:	74 07                	je     80102b10 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102b09:	8b 40 20             	mov    0x20(%eax),%eax
80102b0c:	c1 e8 18             	shr    $0x18,%eax
80102b0f:	c3                   	ret    
    return 0;
80102b10:	31 c0                	xor    %eax,%eax
}
80102b12:	c3                   	ret    
80102b13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b20 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102b20:	a1 84 a6 14 80       	mov    0x8014a684,%eax
80102b25:	85 c0                	test   %eax,%eax
80102b27:	74 0d                	je     80102b36 <lapiceoi+0x16>
  lapic[index] = value;
80102b29:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b30:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b33:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102b36:	c3                   	ret    
80102b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b3e:	66 90                	xchg   %ax,%ax

80102b40 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102b40:	c3                   	ret    
80102b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b4f:	90                   	nop

80102b50 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b51:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b56:	ba 70 00 00 00       	mov    $0x70,%edx
80102b5b:	89 e5                	mov    %esp,%ebp
80102b5d:	53                   	push   %ebx
80102b5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b61:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b64:	ee                   	out    %al,(%dx)
80102b65:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b6a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b6f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b70:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b72:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b75:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b7b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b7d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102b80:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102b82:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b85:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b88:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b8e:	a1 84 a6 14 80       	mov    0x8014a684,%eax
80102b93:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b99:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b9c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102ba3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ba6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ba9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102bb0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bb6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bbc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bbf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bc5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bc8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bd1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bd7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102bda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bdd:	c9                   	leave  
80102bde:	c3                   	ret    
80102bdf:	90                   	nop

80102be0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102be0:	55                   	push   %ebp
80102be1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102be6:	ba 70 00 00 00       	mov    $0x70,%edx
80102beb:	89 e5                	mov    %esp,%ebp
80102bed:	57                   	push   %edi
80102bee:	56                   	push   %esi
80102bef:	53                   	push   %ebx
80102bf0:	83 ec 4c             	sub    $0x4c,%esp
80102bf3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf4:	ba 71 00 00 00       	mov    $0x71,%edx
80102bf9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102bfa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bfd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102c02:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102c05:	8d 76 00             	lea    0x0(%esi),%esi
80102c08:	31 c0                	xor    %eax,%eax
80102c0a:	89 da                	mov    %ebx,%edx
80102c0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102c12:	89 ca                	mov    %ecx,%edx
80102c14:	ec                   	in     (%dx),%al
80102c15:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c18:	89 da                	mov    %ebx,%edx
80102c1a:	b8 02 00 00 00       	mov    $0x2,%eax
80102c1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c20:	89 ca                	mov    %ecx,%edx
80102c22:	ec                   	in     (%dx),%al
80102c23:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c26:	89 da                	mov    %ebx,%edx
80102c28:	b8 04 00 00 00       	mov    $0x4,%eax
80102c2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c2e:	89 ca                	mov    %ecx,%edx
80102c30:	ec                   	in     (%dx),%al
80102c31:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c34:	89 da                	mov    %ebx,%edx
80102c36:	b8 07 00 00 00       	mov    $0x7,%eax
80102c3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3c:	89 ca                	mov    %ecx,%edx
80102c3e:	ec                   	in     (%dx),%al
80102c3f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c42:	89 da                	mov    %ebx,%edx
80102c44:	b8 08 00 00 00       	mov    $0x8,%eax
80102c49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c4a:	89 ca                	mov    %ecx,%edx
80102c4c:	ec                   	in     (%dx),%al
80102c4d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c4f:	89 da                	mov    %ebx,%edx
80102c51:	b8 09 00 00 00       	mov    $0x9,%eax
80102c56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c57:	89 ca                	mov    %ecx,%edx
80102c59:	ec                   	in     (%dx),%al
80102c5a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c5c:	89 da                	mov    %ebx,%edx
80102c5e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c64:	89 ca                	mov    %ecx,%edx
80102c66:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c67:	84 c0                	test   %al,%al
80102c69:	78 9d                	js     80102c08 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c6b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c6f:	89 fa                	mov    %edi,%edx
80102c71:	0f b6 fa             	movzbl %dl,%edi
80102c74:	89 f2                	mov    %esi,%edx
80102c76:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c79:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c7d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c80:	89 da                	mov    %ebx,%edx
80102c82:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102c85:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c88:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c8c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102c8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c92:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c96:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c99:	31 c0                	xor    %eax,%eax
80102c9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9c:	89 ca                	mov    %ecx,%edx
80102c9e:	ec                   	in     (%dx),%al
80102c9f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca2:	89 da                	mov    %ebx,%edx
80102ca4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ca7:	b8 02 00 00 00       	mov    $0x2,%eax
80102cac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cad:	89 ca                	mov    %ecx,%edx
80102caf:	ec                   	in     (%dx),%al
80102cb0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb3:	89 da                	mov    %ebx,%edx
80102cb5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102cb8:	b8 04 00 00 00       	mov    $0x4,%eax
80102cbd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cbe:	89 ca                	mov    %ecx,%edx
80102cc0:	ec                   	in     (%dx),%al
80102cc1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cc4:	89 da                	mov    %ebx,%edx
80102cc6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102cc9:	b8 07 00 00 00       	mov    $0x7,%eax
80102cce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ccf:	89 ca                	mov    %ecx,%edx
80102cd1:	ec                   	in     (%dx),%al
80102cd2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd5:	89 da                	mov    %ebx,%edx
80102cd7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102cda:	b8 08 00 00 00       	mov    $0x8,%eax
80102cdf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ce0:	89 ca                	mov    %ecx,%edx
80102ce2:	ec                   	in     (%dx),%al
80102ce3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ce6:	89 da                	mov    %ebx,%edx
80102ce8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ceb:	b8 09 00 00 00       	mov    $0x9,%eax
80102cf0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cf1:	89 ca                	mov    %ecx,%edx
80102cf3:	ec                   	in     (%dx),%al
80102cf4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cf7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102cfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cfd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102d00:	6a 18                	push   $0x18
80102d02:	50                   	push   %eax
80102d03:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102d06:	50                   	push   %eax
80102d07:	e8 b4 1b 00 00       	call   801048c0 <memcmp>
80102d0c:	83 c4 10             	add    $0x10,%esp
80102d0f:	85 c0                	test   %eax,%eax
80102d11:	0f 85 f1 fe ff ff    	jne    80102c08 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102d17:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102d1b:	75 78                	jne    80102d95 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d20:	89 c2                	mov    %eax,%edx
80102d22:	83 e0 0f             	and    $0xf,%eax
80102d25:	c1 ea 04             	shr    $0x4,%edx
80102d28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d31:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d34:	89 c2                	mov    %eax,%edx
80102d36:	83 e0 0f             	and    $0xf,%eax
80102d39:	c1 ea 04             	shr    $0x4,%edx
80102d3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d42:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d45:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d48:	89 c2                	mov    %eax,%edx
80102d4a:	83 e0 0f             	and    $0xf,%eax
80102d4d:	c1 ea 04             	shr    $0x4,%edx
80102d50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d56:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d5c:	89 c2                	mov    %eax,%edx
80102d5e:	83 e0 0f             	and    $0xf,%eax
80102d61:	c1 ea 04             	shr    $0x4,%edx
80102d64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d70:	89 c2                	mov    %eax,%edx
80102d72:	83 e0 0f             	and    $0xf,%eax
80102d75:	c1 ea 04             	shr    $0x4,%edx
80102d78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d81:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d84:	89 c2                	mov    %eax,%edx
80102d86:	83 e0 0f             	and    $0xf,%eax
80102d89:	c1 ea 04             	shr    $0x4,%edx
80102d8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d92:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d95:	8b 75 08             	mov    0x8(%ebp),%esi
80102d98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d9b:	89 06                	mov    %eax,(%esi)
80102d9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102da0:	89 46 04             	mov    %eax,0x4(%esi)
80102da3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102da6:	89 46 08             	mov    %eax,0x8(%esi)
80102da9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102dac:	89 46 0c             	mov    %eax,0xc(%esi)
80102daf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102db2:	89 46 10             	mov    %eax,0x10(%esi)
80102db5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102db8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102dbb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102dc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dc5:	5b                   	pop    %ebx
80102dc6:	5e                   	pop    %esi
80102dc7:	5f                   	pop    %edi
80102dc8:	5d                   	pop    %ebp
80102dc9:	c3                   	ret    
80102dca:	66 90                	xchg   %ax,%ax
80102dcc:	66 90                	xchg   %ax,%ax
80102dce:	66 90                	xchg   %ax,%ax

80102dd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102dd0:	8b 0d e8 a6 14 80    	mov    0x8014a6e8,%ecx
80102dd6:	85 c9                	test   %ecx,%ecx
80102dd8:	0f 8e 8a 00 00 00    	jle    80102e68 <install_trans+0x98>
{
80102dde:	55                   	push   %ebp
80102ddf:	89 e5                	mov    %esp,%ebp
80102de1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102de2:	31 ff                	xor    %edi,%edi
{
80102de4:	56                   	push   %esi
80102de5:	53                   	push   %ebx
80102de6:	83 ec 0c             	sub    $0xc,%esp
80102de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102df0:	a1 d4 a6 14 80       	mov    0x8014a6d4,%eax
80102df5:	83 ec 08             	sub    $0x8,%esp
80102df8:	01 f8                	add    %edi,%eax
80102dfa:	83 c0 01             	add    $0x1,%eax
80102dfd:	50                   	push   %eax
80102dfe:	ff 35 e4 a6 14 80    	push   0x8014a6e4
80102e04:	e8 c7 d2 ff ff       	call   801000d0 <bread>
80102e09:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e0b:	58                   	pop    %eax
80102e0c:	5a                   	pop    %edx
80102e0d:	ff 34 bd ec a6 14 80 	push   -0x7feb5914(,%edi,4)
80102e14:	ff 35 e4 a6 14 80    	push   0x8014a6e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e1a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e1d:	e8 ae d2 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e22:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e25:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e27:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e2a:	68 00 02 00 00       	push   $0x200
80102e2f:	50                   	push   %eax
80102e30:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102e33:	50                   	push   %eax
80102e34:	e8 d7 1a 00 00       	call   80104910 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e39:	89 1c 24             	mov    %ebx,(%esp)
80102e3c:	e8 6f d3 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102e41:	89 34 24             	mov    %esi,(%esp)
80102e44:	e8 a7 d3 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102e49:	89 1c 24             	mov    %ebx,(%esp)
80102e4c:	e8 9f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e51:	83 c4 10             	add    $0x10,%esp
80102e54:	39 3d e8 a6 14 80    	cmp    %edi,0x8014a6e8
80102e5a:	7f 94                	jg     80102df0 <install_trans+0x20>
  }
}
80102e5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e5f:	5b                   	pop    %ebx
80102e60:	5e                   	pop    %esi
80102e61:	5f                   	pop    %edi
80102e62:	5d                   	pop    %ebp
80102e63:	c3                   	ret    
80102e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e68:	c3                   	ret    
80102e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	53                   	push   %ebx
80102e74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e77:	ff 35 d4 a6 14 80    	push   0x8014a6d4
80102e7d:	ff 35 e4 a6 14 80    	push   0x8014a6e4
80102e83:	e8 48 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e88:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e8b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102e8d:	a1 e8 a6 14 80       	mov    0x8014a6e8,%eax
80102e92:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102e95:	85 c0                	test   %eax,%eax
80102e97:	7e 19                	jle    80102eb2 <write_head+0x42>
80102e99:	31 d2                	xor    %edx,%edx
80102e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e9f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102ea0:	8b 0c 95 ec a6 14 80 	mov    -0x7feb5914(,%edx,4),%ecx
80102ea7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102eab:	83 c2 01             	add    $0x1,%edx
80102eae:	39 d0                	cmp    %edx,%eax
80102eb0:	75 ee                	jne    80102ea0 <write_head+0x30>
  }
  bwrite(buf);
80102eb2:	83 ec 0c             	sub    $0xc,%esp
80102eb5:	53                   	push   %ebx
80102eb6:	e8 f5 d2 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102ebb:	89 1c 24             	mov    %ebx,(%esp)
80102ebe:	e8 2d d3 ff ff       	call   801001f0 <brelse>
}
80102ec3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ec6:	83 c4 10             	add    $0x10,%esp
80102ec9:	c9                   	leave  
80102eca:	c3                   	ret    
80102ecb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ecf:	90                   	nop

80102ed0 <initlog>:
{
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
80102ed3:	53                   	push   %ebx
80102ed4:	83 ec 2c             	sub    $0x2c,%esp
80102ed7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102eda:	68 00 7b 10 80       	push   $0x80107b00
80102edf:	68 a0 a6 14 80       	push   $0x8014a6a0
80102ee4:	e8 f7 16 00 00       	call   801045e0 <initlock>
  readsb(dev, &sb);
80102ee9:	58                   	pop    %eax
80102eea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102eed:	5a                   	pop    %edx
80102eee:	50                   	push   %eax
80102eef:	53                   	push   %ebx
80102ef0:	e8 2b e6 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102ef5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ef8:	59                   	pop    %ecx
  log.dev = dev;
80102ef9:	89 1d e4 a6 14 80    	mov    %ebx,0x8014a6e4
  log.size = sb.nlog;
80102eff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102f02:	a3 d4 a6 14 80       	mov    %eax,0x8014a6d4
  log.size = sb.nlog;
80102f07:	89 15 d8 a6 14 80    	mov    %edx,0x8014a6d8
  struct buf *buf = bread(log.dev, log.start);
80102f0d:	5a                   	pop    %edx
80102f0e:	50                   	push   %eax
80102f0f:	53                   	push   %ebx
80102f10:	e8 bb d1 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102f15:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102f18:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102f1b:	89 1d e8 a6 14 80    	mov    %ebx,0x8014a6e8
  for (i = 0; i < log.lh.n; i++) {
80102f21:	85 db                	test   %ebx,%ebx
80102f23:	7e 1d                	jle    80102f42 <initlog+0x72>
80102f25:	31 d2                	xor    %edx,%edx
80102f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f2e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102f30:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102f34:	89 0c 95 ec a6 14 80 	mov    %ecx,-0x7feb5914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102f3b:	83 c2 01             	add    $0x1,%edx
80102f3e:	39 d3                	cmp    %edx,%ebx
80102f40:	75 ee                	jne    80102f30 <initlog+0x60>
  brelse(buf);
80102f42:	83 ec 0c             	sub    $0xc,%esp
80102f45:	50                   	push   %eax
80102f46:	e8 a5 d2 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f4b:	e8 80 fe ff ff       	call   80102dd0 <install_trans>
  log.lh.n = 0;
80102f50:	c7 05 e8 a6 14 80 00 	movl   $0x0,0x8014a6e8
80102f57:	00 00 00 
  write_head(); // clear the log
80102f5a:	e8 11 ff ff ff       	call   80102e70 <write_head>
}
80102f5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f62:	83 c4 10             	add    $0x10,%esp
80102f65:	c9                   	leave  
80102f66:	c3                   	ret    
80102f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f6e:	66 90                	xchg   %ax,%ax

80102f70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f76:	68 a0 a6 14 80       	push   $0x8014a6a0
80102f7b:	e8 30 18 00 00       	call   801047b0 <acquire>
80102f80:	83 c4 10             	add    $0x10,%esp
80102f83:	eb 18                	jmp    80102f9d <begin_op+0x2d>
80102f85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f88:	83 ec 08             	sub    $0x8,%esp
80102f8b:	68 a0 a6 14 80       	push   $0x8014a6a0
80102f90:	68 a0 a6 14 80       	push   $0x8014a6a0
80102f95:	e8 b6 12 00 00       	call   80104250 <sleep>
80102f9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f9d:	a1 e0 a6 14 80       	mov    0x8014a6e0,%eax
80102fa2:	85 c0                	test   %eax,%eax
80102fa4:	75 e2                	jne    80102f88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102fa6:	a1 dc a6 14 80       	mov    0x8014a6dc,%eax
80102fab:	8b 15 e8 a6 14 80    	mov    0x8014a6e8,%edx
80102fb1:	83 c0 01             	add    $0x1,%eax
80102fb4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102fb7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102fba:	83 fa 1e             	cmp    $0x1e,%edx
80102fbd:	7f c9                	jg     80102f88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102fbf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102fc2:	a3 dc a6 14 80       	mov    %eax,0x8014a6dc
      release(&log.lock);
80102fc7:	68 a0 a6 14 80       	push   $0x8014a6a0
80102fcc:	e8 7f 17 00 00       	call   80104750 <release>
      break;
    }
  }
}
80102fd1:	83 c4 10             	add    $0x10,%esp
80102fd4:	c9                   	leave  
80102fd5:	c3                   	ret    
80102fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fdd:	8d 76 00             	lea    0x0(%esi),%esi

80102fe0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	57                   	push   %edi
80102fe4:	56                   	push   %esi
80102fe5:	53                   	push   %ebx
80102fe6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102fe9:	68 a0 a6 14 80       	push   $0x8014a6a0
80102fee:	e8 bd 17 00 00       	call   801047b0 <acquire>
  log.outstanding -= 1;
80102ff3:	a1 dc a6 14 80       	mov    0x8014a6dc,%eax
  if(log.committing)
80102ff8:	8b 35 e0 a6 14 80    	mov    0x8014a6e0,%esi
80102ffe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103001:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103004:	89 1d dc a6 14 80    	mov    %ebx,0x8014a6dc
  if(log.committing)
8010300a:	85 f6                	test   %esi,%esi
8010300c:	0f 85 22 01 00 00    	jne    80103134 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103012:	85 db                	test   %ebx,%ebx
80103014:	0f 85 f6 00 00 00    	jne    80103110 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010301a:	c7 05 e0 a6 14 80 01 	movl   $0x1,0x8014a6e0
80103021:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103024:	83 ec 0c             	sub    $0xc,%esp
80103027:	68 a0 a6 14 80       	push   $0x8014a6a0
8010302c:	e8 1f 17 00 00       	call   80104750 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103031:	8b 0d e8 a6 14 80    	mov    0x8014a6e8,%ecx
80103037:	83 c4 10             	add    $0x10,%esp
8010303a:	85 c9                	test   %ecx,%ecx
8010303c:	7f 42                	jg     80103080 <end_op+0xa0>
    acquire(&log.lock);
8010303e:	83 ec 0c             	sub    $0xc,%esp
80103041:	68 a0 a6 14 80       	push   $0x8014a6a0
80103046:	e8 65 17 00 00       	call   801047b0 <acquire>
    wakeup(&log);
8010304b:	c7 04 24 a0 a6 14 80 	movl   $0x8014a6a0,(%esp)
    log.committing = 0;
80103052:	c7 05 e0 a6 14 80 00 	movl   $0x0,0x8014a6e0
80103059:	00 00 00 
    wakeup(&log);
8010305c:	e8 af 12 00 00       	call   80104310 <wakeup>
    release(&log.lock);
80103061:	c7 04 24 a0 a6 14 80 	movl   $0x8014a6a0,(%esp)
80103068:	e8 e3 16 00 00       	call   80104750 <release>
8010306d:	83 c4 10             	add    $0x10,%esp
}
80103070:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103073:	5b                   	pop    %ebx
80103074:	5e                   	pop    %esi
80103075:	5f                   	pop    %edi
80103076:	5d                   	pop    %ebp
80103077:	c3                   	ret    
80103078:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010307f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103080:	a1 d4 a6 14 80       	mov    0x8014a6d4,%eax
80103085:	83 ec 08             	sub    $0x8,%esp
80103088:	01 d8                	add    %ebx,%eax
8010308a:	83 c0 01             	add    $0x1,%eax
8010308d:	50                   	push   %eax
8010308e:	ff 35 e4 a6 14 80    	push   0x8014a6e4
80103094:	e8 37 d0 ff ff       	call   801000d0 <bread>
80103099:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010309b:	58                   	pop    %eax
8010309c:	5a                   	pop    %edx
8010309d:	ff 34 9d ec a6 14 80 	push   -0x7feb5914(,%ebx,4)
801030a4:	ff 35 e4 a6 14 80    	push   0x8014a6e4
  for (tail = 0; tail < log.lh.n; tail++) {
801030aa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030ad:	e8 1e d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801030b2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030b5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801030b7:	8d 40 5c             	lea    0x5c(%eax),%eax
801030ba:	68 00 02 00 00       	push   $0x200
801030bf:	50                   	push   %eax
801030c0:	8d 46 5c             	lea    0x5c(%esi),%eax
801030c3:	50                   	push   %eax
801030c4:	e8 47 18 00 00       	call   80104910 <memmove>
    bwrite(to);  // write the log
801030c9:	89 34 24             	mov    %esi,(%esp)
801030cc:	e8 df d0 ff ff       	call   801001b0 <bwrite>
    brelse(from);
801030d1:	89 3c 24             	mov    %edi,(%esp)
801030d4:	e8 17 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
801030d9:	89 34 24             	mov    %esi,(%esp)
801030dc:	e8 0f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030e1:	83 c4 10             	add    $0x10,%esp
801030e4:	3b 1d e8 a6 14 80    	cmp    0x8014a6e8,%ebx
801030ea:	7c 94                	jl     80103080 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801030ec:	e8 7f fd ff ff       	call   80102e70 <write_head>
    install_trans(); // Now install writes to home locations
801030f1:	e8 da fc ff ff       	call   80102dd0 <install_trans>
    log.lh.n = 0;
801030f6:	c7 05 e8 a6 14 80 00 	movl   $0x0,0x8014a6e8
801030fd:	00 00 00 
    write_head();    // Erase the transaction from the log
80103100:	e8 6b fd ff ff       	call   80102e70 <write_head>
80103105:	e9 34 ff ff ff       	jmp    8010303e <end_op+0x5e>
8010310a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103110:	83 ec 0c             	sub    $0xc,%esp
80103113:	68 a0 a6 14 80       	push   $0x8014a6a0
80103118:	e8 f3 11 00 00       	call   80104310 <wakeup>
  release(&log.lock);
8010311d:	c7 04 24 a0 a6 14 80 	movl   $0x8014a6a0,(%esp)
80103124:	e8 27 16 00 00       	call   80104750 <release>
80103129:	83 c4 10             	add    $0x10,%esp
}
8010312c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010312f:	5b                   	pop    %ebx
80103130:	5e                   	pop    %esi
80103131:	5f                   	pop    %edi
80103132:	5d                   	pop    %ebp
80103133:	c3                   	ret    
    panic("log.committing");
80103134:	83 ec 0c             	sub    $0xc,%esp
80103137:	68 04 7b 10 80       	push   $0x80107b04
8010313c:	e8 3f d2 ff ff       	call   80100380 <panic>
80103141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103148:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010314f:	90                   	nop

80103150 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103150:	55                   	push   %ebp
80103151:	89 e5                	mov    %esp,%ebp
80103153:	53                   	push   %ebx
80103154:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103157:	8b 15 e8 a6 14 80    	mov    0x8014a6e8,%edx
{
8010315d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103160:	83 fa 1d             	cmp    $0x1d,%edx
80103163:	0f 8f 85 00 00 00    	jg     801031ee <log_write+0x9e>
80103169:	a1 d8 a6 14 80       	mov    0x8014a6d8,%eax
8010316e:	83 e8 01             	sub    $0x1,%eax
80103171:	39 c2                	cmp    %eax,%edx
80103173:	7d 79                	jge    801031ee <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103175:	a1 dc a6 14 80       	mov    0x8014a6dc,%eax
8010317a:	85 c0                	test   %eax,%eax
8010317c:	7e 7d                	jle    801031fb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010317e:	83 ec 0c             	sub    $0xc,%esp
80103181:	68 a0 a6 14 80       	push   $0x8014a6a0
80103186:	e8 25 16 00 00       	call   801047b0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010318b:	8b 15 e8 a6 14 80    	mov    0x8014a6e8,%edx
80103191:	83 c4 10             	add    $0x10,%esp
80103194:	85 d2                	test   %edx,%edx
80103196:	7e 4a                	jle    801031e2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103198:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010319b:	31 c0                	xor    %eax,%eax
8010319d:	eb 08                	jmp    801031a7 <log_write+0x57>
8010319f:	90                   	nop
801031a0:	83 c0 01             	add    $0x1,%eax
801031a3:	39 c2                	cmp    %eax,%edx
801031a5:	74 29                	je     801031d0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031a7:	39 0c 85 ec a6 14 80 	cmp    %ecx,-0x7feb5914(,%eax,4)
801031ae:	75 f0                	jne    801031a0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801031b0:	89 0c 85 ec a6 14 80 	mov    %ecx,-0x7feb5914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801031b7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801031ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801031bd:	c7 45 08 a0 a6 14 80 	movl   $0x8014a6a0,0x8(%ebp)
}
801031c4:	c9                   	leave  
  release(&log.lock);
801031c5:	e9 86 15 00 00       	jmp    80104750 <release>
801031ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801031d0:	89 0c 95 ec a6 14 80 	mov    %ecx,-0x7feb5914(,%edx,4)
    log.lh.n++;
801031d7:	83 c2 01             	add    $0x1,%edx
801031da:	89 15 e8 a6 14 80    	mov    %edx,0x8014a6e8
801031e0:	eb d5                	jmp    801031b7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
801031e2:	8b 43 08             	mov    0x8(%ebx),%eax
801031e5:	a3 ec a6 14 80       	mov    %eax,0x8014a6ec
  if (i == log.lh.n)
801031ea:	75 cb                	jne    801031b7 <log_write+0x67>
801031ec:	eb e9                	jmp    801031d7 <log_write+0x87>
    panic("too big a transaction");
801031ee:	83 ec 0c             	sub    $0xc,%esp
801031f1:	68 13 7b 10 80       	push   $0x80107b13
801031f6:	e8 85 d1 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801031fb:	83 ec 0c             	sub    $0xc,%esp
801031fe:	68 29 7b 10 80       	push   $0x80107b29
80103203:	e8 78 d1 ff ff       	call   80100380 <panic>
80103208:	66 90                	xchg   %ax,%ax
8010320a:	66 90                	xchg   %ax,%ax
8010320c:	66 90                	xchg   %ax,%ax
8010320e:	66 90                	xchg   %ax,%ax

80103210 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	53                   	push   %ebx
80103214:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103217:	e8 44 09 00 00       	call   80103b60 <cpuid>
8010321c:	89 c3                	mov    %eax,%ebx
8010321e:	e8 3d 09 00 00       	call   80103b60 <cpuid>
80103223:	83 ec 04             	sub    $0x4,%esp
80103226:	53                   	push   %ebx
80103227:	50                   	push   %eax
80103228:	68 44 7b 10 80       	push   $0x80107b44
8010322d:	e8 6e d4 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103232:	e8 f9 28 00 00       	call   80105b30 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103237:	e8 c4 08 00 00       	call   80103b00 <mycpu>
8010323c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010323e:	b8 01 00 00 00       	mov    $0x1,%eax
80103243:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010324a:	e8 f1 0b 00 00       	call   80103e40 <scheduler>
8010324f:	90                   	nop

80103250 <mpenter>:
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103256:	e8 e5 39 00 00       	call   80106c40 <switchkvm>
  seginit();
8010325b:	e8 50 39 00 00       	call   80106bb0 <seginit>
  lapicinit();
80103260:	e8 9b f7 ff ff       	call   80102a00 <lapicinit>
  mpmain();
80103265:	e8 a6 ff ff ff       	call   80103210 <mpmain>
8010326a:	66 90                	xchg   %ax,%ax
8010326c:	66 90                	xchg   %ax,%ax
8010326e:	66 90                	xchg   %ax,%ax

80103270 <main>:
{
80103270:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103274:	83 e4 f0             	and    $0xfffffff0,%esp
80103277:	ff 71 fc             	push   -0x4(%ecx)
8010327a:	55                   	push   %ebp
8010327b:	89 e5                	mov    %esp,%ebp
8010327d:	53                   	push   %ebx
8010327e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010327f:	83 ec 08             	sub    $0x8,%esp
80103282:	68 00 00 40 80       	push   $0x80400000
80103287:	68 d0 e4 14 80       	push   $0x8014e4d0
8010328c:	e8 bf f3 ff ff       	call   80102650 <kinit1>
  kvmalloc();      // kernel page table
80103291:	e8 9a 3e 00 00       	call   80107130 <kvmalloc>
  mpinit();        // detect other processors
80103296:	e8 85 01 00 00       	call   80103420 <mpinit>
  lapicinit();     // interrupt controller
8010329b:	e8 60 f7 ff ff       	call   80102a00 <lapicinit>
  seginit();       // segment descriptors
801032a0:	e8 0b 39 00 00       	call   80106bb0 <seginit>
  picinit();       // disable pic
801032a5:	e8 76 03 00 00       	call   80103620 <picinit>
  ioapicinit();    // another interrupt controller
801032aa:	e8 21 f1 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
801032af:	e8 ac d7 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801032b4:	e8 87 2b 00 00       	call   80105e40 <uartinit>
  pinit();         // process table
801032b9:	e8 22 08 00 00       	call   80103ae0 <pinit>
  tvinit();        // trap vectors
801032be:	e8 ed 27 00 00       	call   80105ab0 <tvinit>
  binit();         // buffer cache
801032c3:	e8 78 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
801032c8:	e8 43 db ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801032cd:	e8 ee ee ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801032d2:	83 c4 0c             	add    $0xc,%esp
801032d5:	68 8a 00 00 00       	push   $0x8a
801032da:	68 8c b4 10 80       	push   $0x8010b48c
801032df:	68 00 70 00 80       	push   $0x80007000
801032e4:	e8 27 16 00 00       	call   80104910 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032e9:	83 c4 10             	add    $0x10,%esp
801032ec:	69 05 84 a7 14 80 b0 	imul   $0xb0,0x8014a784,%eax
801032f3:	00 00 00 
801032f6:	05 a0 a7 14 80       	add    $0x8014a7a0,%eax
801032fb:	3d a0 a7 14 80       	cmp    $0x8014a7a0,%eax
80103300:	76 7e                	jbe    80103380 <main+0x110>
80103302:	bb a0 a7 14 80       	mov    $0x8014a7a0,%ebx
80103307:	eb 20                	jmp    80103329 <main+0xb9>
80103309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103310:	69 05 84 a7 14 80 b0 	imul   $0xb0,0x8014a784,%eax
80103317:	00 00 00 
8010331a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103320:	05 a0 a7 14 80       	add    $0x8014a7a0,%eax
80103325:	39 c3                	cmp    %eax,%ebx
80103327:	73 57                	jae    80103380 <main+0x110>
    if(c == mycpu())  // We've started already.
80103329:	e8 d2 07 00 00       	call   80103b00 <mycpu>
8010332e:	39 c3                	cmp    %eax,%ebx
80103330:	74 de                	je     80103310 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103332:	e8 b9 f3 ff ff       	call   801026f0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103337:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010333a:	c7 05 f8 6f 00 80 50 	movl   $0x80103250,0x80006ff8
80103341:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103344:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010334b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010334e:	05 00 10 00 00       	add    $0x1000,%eax
80103353:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103358:	0f b6 03             	movzbl (%ebx),%eax
8010335b:	68 00 70 00 00       	push   $0x7000
80103360:	50                   	push   %eax
80103361:	e8 ea f7 ff ff       	call   80102b50 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103366:	83 c4 10             	add    $0x10,%esp
80103369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103370:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103376:	85 c0                	test   %eax,%eax
80103378:	74 f6                	je     80103370 <main+0x100>
8010337a:	eb 94                	jmp    80103310 <main+0xa0>
8010337c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103380:	83 ec 08             	sub    $0x8,%esp
80103383:	68 00 00 00 8e       	push   $0x8e000000
80103388:	68 00 00 40 80       	push   $0x80400000
8010338d:	e8 5e f2 ff ff       	call   801025f0 <kinit2>
  userinit();      // first user process
80103392:	e8 19 08 00 00       	call   80103bb0 <userinit>
  mpmain();        // finish this processor's setup
80103397:	e8 74 fe ff ff       	call   80103210 <mpmain>
8010339c:	66 90                	xchg   %ax,%ax
8010339e:	66 90                	xchg   %ax,%ax

801033a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	57                   	push   %edi
801033a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801033a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801033ab:	53                   	push   %ebx
  e = addr+len;
801033ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801033af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801033b2:	39 de                	cmp    %ebx,%esi
801033b4:	72 10                	jb     801033c6 <mpsearch1+0x26>
801033b6:	eb 50                	jmp    80103408 <mpsearch1+0x68>
801033b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033bf:	90                   	nop
801033c0:	89 fe                	mov    %edi,%esi
801033c2:	39 fb                	cmp    %edi,%ebx
801033c4:	76 42                	jbe    80103408 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033c6:	83 ec 04             	sub    $0x4,%esp
801033c9:	8d 7e 10             	lea    0x10(%esi),%edi
801033cc:	6a 04                	push   $0x4
801033ce:	68 58 7b 10 80       	push   $0x80107b58
801033d3:	56                   	push   %esi
801033d4:	e8 e7 14 00 00       	call   801048c0 <memcmp>
801033d9:	83 c4 10             	add    $0x10,%esp
801033dc:	85 c0                	test   %eax,%eax
801033de:	75 e0                	jne    801033c0 <mpsearch1+0x20>
801033e0:	89 f2                	mov    %esi,%edx
801033e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801033e8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033eb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033ee:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033f0:	39 fa                	cmp    %edi,%edx
801033f2:	75 f4                	jne    801033e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033f4:	84 c0                	test   %al,%al
801033f6:	75 c8                	jne    801033c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801033f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033fb:	89 f0                	mov    %esi,%eax
801033fd:	5b                   	pop    %ebx
801033fe:	5e                   	pop    %esi
801033ff:	5f                   	pop    %edi
80103400:	5d                   	pop    %ebp
80103401:	c3                   	ret    
80103402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103408:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010340b:	31 f6                	xor    %esi,%esi
}
8010340d:	5b                   	pop    %ebx
8010340e:	89 f0                	mov    %esi,%eax
80103410:	5e                   	pop    %esi
80103411:	5f                   	pop    %edi
80103412:	5d                   	pop    %ebp
80103413:	c3                   	ret    
80103414:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010341b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010341f:	90                   	nop

80103420 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103420:	55                   	push   %ebp
80103421:	89 e5                	mov    %esp,%ebp
80103423:	57                   	push   %edi
80103424:	56                   	push   %esi
80103425:	53                   	push   %ebx
80103426:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103429:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103430:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103437:	c1 e0 08             	shl    $0x8,%eax
8010343a:	09 d0                	or     %edx,%eax
8010343c:	c1 e0 04             	shl    $0x4,%eax
8010343f:	75 1b                	jne    8010345c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103441:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103448:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010344f:	c1 e0 08             	shl    $0x8,%eax
80103452:	09 d0                	or     %edx,%eax
80103454:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103457:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010345c:	ba 00 04 00 00       	mov    $0x400,%edx
80103461:	e8 3a ff ff ff       	call   801033a0 <mpsearch1>
80103466:	89 c3                	mov    %eax,%ebx
80103468:	85 c0                	test   %eax,%eax
8010346a:	0f 84 40 01 00 00    	je     801035b0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103470:	8b 73 04             	mov    0x4(%ebx),%esi
80103473:	85 f6                	test   %esi,%esi
80103475:	0f 84 25 01 00 00    	je     801035a0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010347b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010347e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103484:	6a 04                	push   $0x4
80103486:	68 5d 7b 10 80       	push   $0x80107b5d
8010348b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010348c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010348f:	e8 2c 14 00 00       	call   801048c0 <memcmp>
80103494:	83 c4 10             	add    $0x10,%esp
80103497:	85 c0                	test   %eax,%eax
80103499:	0f 85 01 01 00 00    	jne    801035a0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010349f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801034a6:	3c 01                	cmp    $0x1,%al
801034a8:	74 08                	je     801034b2 <mpinit+0x92>
801034aa:	3c 04                	cmp    $0x4,%al
801034ac:	0f 85 ee 00 00 00    	jne    801035a0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801034b2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801034b9:	66 85 d2             	test   %dx,%dx
801034bc:	74 22                	je     801034e0 <mpinit+0xc0>
801034be:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801034c1:	89 f0                	mov    %esi,%eax
  sum = 0;
801034c3:	31 d2                	xor    %edx,%edx
801034c5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801034c8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801034cf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801034d2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801034d4:	39 c7                	cmp    %eax,%edi
801034d6:	75 f0                	jne    801034c8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801034d8:	84 d2                	test   %dl,%dl
801034da:	0f 85 c0 00 00 00    	jne    801035a0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801034e0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801034e6:	a3 84 a6 14 80       	mov    %eax,0x8014a684
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034eb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801034f2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801034f8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034fd:	03 55 e4             	add    -0x1c(%ebp),%edx
80103500:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103503:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103507:	90                   	nop
80103508:	39 d0                	cmp    %edx,%eax
8010350a:	73 15                	jae    80103521 <mpinit+0x101>
    switch(*p){
8010350c:	0f b6 08             	movzbl (%eax),%ecx
8010350f:	80 f9 02             	cmp    $0x2,%cl
80103512:	74 4c                	je     80103560 <mpinit+0x140>
80103514:	77 3a                	ja     80103550 <mpinit+0x130>
80103516:	84 c9                	test   %cl,%cl
80103518:	74 56                	je     80103570 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010351a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010351d:	39 d0                	cmp    %edx,%eax
8010351f:	72 eb                	jb     8010350c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103521:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103524:	85 f6                	test   %esi,%esi
80103526:	0f 84 d9 00 00 00    	je     80103605 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010352c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103530:	74 15                	je     80103547 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103532:	b8 70 00 00 00       	mov    $0x70,%eax
80103537:	ba 22 00 00 00       	mov    $0x22,%edx
8010353c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010353d:	ba 23 00 00 00       	mov    $0x23,%edx
80103542:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103543:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103546:	ee                   	out    %al,(%dx)
  }
}
80103547:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010354a:	5b                   	pop    %ebx
8010354b:	5e                   	pop    %esi
8010354c:	5f                   	pop    %edi
8010354d:	5d                   	pop    %ebp
8010354e:	c3                   	ret    
8010354f:	90                   	nop
    switch(*p){
80103550:	83 e9 03             	sub    $0x3,%ecx
80103553:	80 f9 01             	cmp    $0x1,%cl
80103556:	76 c2                	jbe    8010351a <mpinit+0xfa>
80103558:	31 f6                	xor    %esi,%esi
8010355a:	eb ac                	jmp    80103508 <mpinit+0xe8>
8010355c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103560:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103564:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103567:	88 0d 80 a7 14 80    	mov    %cl,0x8014a780
      continue;
8010356d:	eb 99                	jmp    80103508 <mpinit+0xe8>
8010356f:	90                   	nop
      if(ncpu < NCPU) {
80103570:	8b 0d 84 a7 14 80    	mov    0x8014a784,%ecx
80103576:	83 f9 07             	cmp    $0x7,%ecx
80103579:	7f 19                	jg     80103594 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010357b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103581:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103585:	83 c1 01             	add    $0x1,%ecx
80103588:	89 0d 84 a7 14 80    	mov    %ecx,0x8014a784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010358e:	88 9f a0 a7 14 80    	mov    %bl,-0x7feb5860(%edi)
      p += sizeof(struct mpproc);
80103594:	83 c0 14             	add    $0x14,%eax
      continue;
80103597:	e9 6c ff ff ff       	jmp    80103508 <mpinit+0xe8>
8010359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801035a0:	83 ec 0c             	sub    $0xc,%esp
801035a3:	68 62 7b 10 80       	push   $0x80107b62
801035a8:	e8 d3 cd ff ff       	call   80100380 <panic>
801035ad:	8d 76 00             	lea    0x0(%esi),%esi
{
801035b0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801035b5:	eb 13                	jmp    801035ca <mpinit+0x1aa>
801035b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035be:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801035c0:	89 f3                	mov    %esi,%ebx
801035c2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801035c8:	74 d6                	je     801035a0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035ca:	83 ec 04             	sub    $0x4,%esp
801035cd:	8d 73 10             	lea    0x10(%ebx),%esi
801035d0:	6a 04                	push   $0x4
801035d2:	68 58 7b 10 80       	push   $0x80107b58
801035d7:	53                   	push   %ebx
801035d8:	e8 e3 12 00 00       	call   801048c0 <memcmp>
801035dd:	83 c4 10             	add    $0x10,%esp
801035e0:	85 c0                	test   %eax,%eax
801035e2:	75 dc                	jne    801035c0 <mpinit+0x1a0>
801035e4:	89 da                	mov    %ebx,%edx
801035e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801035f0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801035f3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801035f6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801035f8:	39 d6                	cmp    %edx,%esi
801035fa:	75 f4                	jne    801035f0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035fc:	84 c0                	test   %al,%al
801035fe:	75 c0                	jne    801035c0 <mpinit+0x1a0>
80103600:	e9 6b fe ff ff       	jmp    80103470 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103605:	83 ec 0c             	sub    $0xc,%esp
80103608:	68 7c 7b 10 80       	push   $0x80107b7c
8010360d:	e8 6e cd ff ff       	call   80100380 <panic>
80103612:	66 90                	xchg   %ax,%ax
80103614:	66 90                	xchg   %ax,%ax
80103616:	66 90                	xchg   %ax,%ax
80103618:	66 90                	xchg   %ax,%ax
8010361a:	66 90                	xchg   %ax,%ax
8010361c:	66 90                	xchg   %ax,%ax
8010361e:	66 90                	xchg   %ax,%ax

80103620 <picinit>:
80103620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103625:	ba 21 00 00 00       	mov    $0x21,%edx
8010362a:	ee                   	out    %al,(%dx)
8010362b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103630:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103631:	c3                   	ret    
80103632:	66 90                	xchg   %ax,%ax
80103634:	66 90                	xchg   %ax,%ax
80103636:	66 90                	xchg   %ax,%ax
80103638:	66 90                	xchg   %ax,%ax
8010363a:	66 90                	xchg   %ax,%ax
8010363c:	66 90                	xchg   %ax,%ax
8010363e:	66 90                	xchg   %ax,%ax

80103640 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	57                   	push   %edi
80103644:	56                   	push   %esi
80103645:	53                   	push   %ebx
80103646:	83 ec 0c             	sub    $0xc,%esp
80103649:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010364c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010364f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103655:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010365b:	e8 d0 d7 ff ff       	call   80100e30 <filealloc>
80103660:	89 03                	mov    %eax,(%ebx)
80103662:	85 c0                	test   %eax,%eax
80103664:	0f 84 a8 00 00 00    	je     80103712 <pipealloc+0xd2>
8010366a:	e8 c1 d7 ff ff       	call   80100e30 <filealloc>
8010366f:	89 06                	mov    %eax,(%esi)
80103671:	85 c0                	test   %eax,%eax
80103673:	0f 84 87 00 00 00    	je     80103700 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103679:	e8 72 f0 ff ff       	call   801026f0 <kalloc>
8010367e:	89 c7                	mov    %eax,%edi
80103680:	85 c0                	test   %eax,%eax
80103682:	0f 84 b0 00 00 00    	je     80103738 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103688:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010368f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103692:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103695:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010369c:	00 00 00 
  p->nwrite = 0;
8010369f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801036a6:	00 00 00 
  p->nread = 0;
801036a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801036b0:	00 00 00 
  initlock(&p->lock, "pipe");
801036b3:	68 9b 7b 10 80       	push   $0x80107b9b
801036b8:	50                   	push   %eax
801036b9:	e8 22 0f 00 00       	call   801045e0 <initlock>
  (*f0)->type = FD_PIPE;
801036be:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801036c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801036c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801036c9:	8b 03                	mov    (%ebx),%eax
801036cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801036cf:	8b 03                	mov    (%ebx),%eax
801036d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036d5:	8b 03                	mov    (%ebx),%eax
801036d7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036da:	8b 06                	mov    (%esi),%eax
801036dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036e2:	8b 06                	mov    (%esi),%eax
801036e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036e8:	8b 06                	mov    (%esi),%eax
801036ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036ee:	8b 06                	mov    (%esi),%eax
801036f0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801036f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036f6:	31 c0                	xor    %eax,%eax
}
801036f8:	5b                   	pop    %ebx
801036f9:	5e                   	pop    %esi
801036fa:	5f                   	pop    %edi
801036fb:	5d                   	pop    %ebp
801036fc:	c3                   	ret    
801036fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103700:	8b 03                	mov    (%ebx),%eax
80103702:	85 c0                	test   %eax,%eax
80103704:	74 1e                	je     80103724 <pipealloc+0xe4>
    fileclose(*f0);
80103706:	83 ec 0c             	sub    $0xc,%esp
80103709:	50                   	push   %eax
8010370a:	e8 e1 d7 ff ff       	call   80100ef0 <fileclose>
8010370f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103712:	8b 06                	mov    (%esi),%eax
80103714:	85 c0                	test   %eax,%eax
80103716:	74 0c                	je     80103724 <pipealloc+0xe4>
    fileclose(*f1);
80103718:	83 ec 0c             	sub    $0xc,%esp
8010371b:	50                   	push   %eax
8010371c:	e8 cf d7 ff ff       	call   80100ef0 <fileclose>
80103721:	83 c4 10             	add    $0x10,%esp
}
80103724:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103727:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010372c:	5b                   	pop    %ebx
8010372d:	5e                   	pop    %esi
8010372e:	5f                   	pop    %edi
8010372f:	5d                   	pop    %ebp
80103730:	c3                   	ret    
80103731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103738:	8b 03                	mov    (%ebx),%eax
8010373a:	85 c0                	test   %eax,%eax
8010373c:	75 c8                	jne    80103706 <pipealloc+0xc6>
8010373e:	eb d2                	jmp    80103712 <pipealloc+0xd2>

80103740 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	56                   	push   %esi
80103744:	53                   	push   %ebx
80103745:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103748:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010374b:	83 ec 0c             	sub    $0xc,%esp
8010374e:	53                   	push   %ebx
8010374f:	e8 5c 10 00 00       	call   801047b0 <acquire>
  if(writable){
80103754:	83 c4 10             	add    $0x10,%esp
80103757:	85 f6                	test   %esi,%esi
80103759:	74 65                	je     801037c0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010375b:	83 ec 0c             	sub    $0xc,%esp
8010375e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103764:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010376b:	00 00 00 
    wakeup(&p->nread);
8010376e:	50                   	push   %eax
8010376f:	e8 9c 0b 00 00       	call   80104310 <wakeup>
80103774:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103777:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010377d:	85 d2                	test   %edx,%edx
8010377f:	75 0a                	jne    8010378b <pipeclose+0x4b>
80103781:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103787:	85 c0                	test   %eax,%eax
80103789:	74 15                	je     801037a0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010378b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010378e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103791:	5b                   	pop    %ebx
80103792:	5e                   	pop    %esi
80103793:	5d                   	pop    %ebp
    release(&p->lock);
80103794:	e9 b7 0f 00 00       	jmp    80104750 <release>
80103799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801037a0:	83 ec 0c             	sub    $0xc,%esp
801037a3:	53                   	push   %ebx
801037a4:	e8 a7 0f 00 00       	call   80104750 <release>
    kfree((char*)p);
801037a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801037ac:	83 c4 10             	add    $0x10,%esp
}
801037af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037b2:	5b                   	pop    %ebx
801037b3:	5e                   	pop    %esi
801037b4:	5d                   	pop    %ebp
    kfree((char*)p);
801037b5:	e9 06 ed ff ff       	jmp    801024c0 <kfree>
801037ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801037c0:	83 ec 0c             	sub    $0xc,%esp
801037c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801037c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801037d0:	00 00 00 
    wakeup(&p->nwrite);
801037d3:	50                   	push   %eax
801037d4:	e8 37 0b 00 00       	call   80104310 <wakeup>
801037d9:	83 c4 10             	add    $0x10,%esp
801037dc:	eb 99                	jmp    80103777 <pipeclose+0x37>
801037de:	66 90                	xchg   %ax,%ax

801037e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	57                   	push   %edi
801037e4:	56                   	push   %esi
801037e5:	53                   	push   %ebx
801037e6:	83 ec 28             	sub    $0x28,%esp
801037e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801037ec:	53                   	push   %ebx
801037ed:	e8 be 0f 00 00       	call   801047b0 <acquire>
  for(i = 0; i < n; i++){
801037f2:	8b 45 10             	mov    0x10(%ebp),%eax
801037f5:	83 c4 10             	add    $0x10,%esp
801037f8:	85 c0                	test   %eax,%eax
801037fa:	0f 8e c0 00 00 00    	jle    801038c0 <pipewrite+0xe0>
80103800:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103803:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103809:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010380f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103812:	03 45 10             	add    0x10(%ebp),%eax
80103815:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103818:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010381e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103824:	89 ca                	mov    %ecx,%edx
80103826:	05 00 02 00 00       	add    $0x200,%eax
8010382b:	39 c1                	cmp    %eax,%ecx
8010382d:	74 3f                	je     8010386e <pipewrite+0x8e>
8010382f:	eb 67                	jmp    80103898 <pipewrite+0xb8>
80103831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103838:	e8 43 03 00 00       	call   80103b80 <myproc>
8010383d:	8b 48 24             	mov    0x24(%eax),%ecx
80103840:	85 c9                	test   %ecx,%ecx
80103842:	75 34                	jne    80103878 <pipewrite+0x98>
      wakeup(&p->nread);
80103844:	83 ec 0c             	sub    $0xc,%esp
80103847:	57                   	push   %edi
80103848:	e8 c3 0a 00 00       	call   80104310 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010384d:	58                   	pop    %eax
8010384e:	5a                   	pop    %edx
8010384f:	53                   	push   %ebx
80103850:	56                   	push   %esi
80103851:	e8 fa 09 00 00       	call   80104250 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103856:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010385c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103862:	83 c4 10             	add    $0x10,%esp
80103865:	05 00 02 00 00       	add    $0x200,%eax
8010386a:	39 c2                	cmp    %eax,%edx
8010386c:	75 2a                	jne    80103898 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010386e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103874:	85 c0                	test   %eax,%eax
80103876:	75 c0                	jne    80103838 <pipewrite+0x58>
        release(&p->lock);
80103878:	83 ec 0c             	sub    $0xc,%esp
8010387b:	53                   	push   %ebx
8010387c:	e8 cf 0e 00 00       	call   80104750 <release>
        return -1;
80103881:	83 c4 10             	add    $0x10,%esp
80103884:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103889:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010388c:	5b                   	pop    %ebx
8010388d:	5e                   	pop    %esi
8010388e:	5f                   	pop    %edi
8010388f:	5d                   	pop    %ebp
80103890:	c3                   	ret    
80103891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103898:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010389b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010389e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801038a4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801038aa:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801038ad:	83 c6 01             	add    $0x1,%esi
801038b0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801038b3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801038b7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801038ba:	0f 85 58 ff ff ff    	jne    80103818 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801038c0:	83 ec 0c             	sub    $0xc,%esp
801038c3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801038c9:	50                   	push   %eax
801038ca:	e8 41 0a 00 00       	call   80104310 <wakeup>
  release(&p->lock);
801038cf:	89 1c 24             	mov    %ebx,(%esp)
801038d2:	e8 79 0e 00 00       	call   80104750 <release>
  return n;
801038d7:	8b 45 10             	mov    0x10(%ebp),%eax
801038da:	83 c4 10             	add    $0x10,%esp
801038dd:	eb aa                	jmp    80103889 <pipewrite+0xa9>
801038df:	90                   	nop

801038e0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	57                   	push   %edi
801038e4:	56                   	push   %esi
801038e5:	53                   	push   %ebx
801038e6:	83 ec 18             	sub    $0x18,%esp
801038e9:	8b 75 08             	mov    0x8(%ebp),%esi
801038ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038ef:	56                   	push   %esi
801038f0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801038f6:	e8 b5 0e 00 00       	call   801047b0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038fb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103901:	83 c4 10             	add    $0x10,%esp
80103904:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010390a:	74 2f                	je     8010393b <piperead+0x5b>
8010390c:	eb 37                	jmp    80103945 <piperead+0x65>
8010390e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103910:	e8 6b 02 00 00       	call   80103b80 <myproc>
80103915:	8b 48 24             	mov    0x24(%eax),%ecx
80103918:	85 c9                	test   %ecx,%ecx
8010391a:	0f 85 80 00 00 00    	jne    801039a0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103920:	83 ec 08             	sub    $0x8,%esp
80103923:	56                   	push   %esi
80103924:	53                   	push   %ebx
80103925:	e8 26 09 00 00       	call   80104250 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010392a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103930:	83 c4 10             	add    $0x10,%esp
80103933:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103939:	75 0a                	jne    80103945 <piperead+0x65>
8010393b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103941:	85 c0                	test   %eax,%eax
80103943:	75 cb                	jne    80103910 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103945:	8b 55 10             	mov    0x10(%ebp),%edx
80103948:	31 db                	xor    %ebx,%ebx
8010394a:	85 d2                	test   %edx,%edx
8010394c:	7f 20                	jg     8010396e <piperead+0x8e>
8010394e:	eb 2c                	jmp    8010397c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103950:	8d 48 01             	lea    0x1(%eax),%ecx
80103953:	25 ff 01 00 00       	and    $0x1ff,%eax
80103958:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010395e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103963:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103966:	83 c3 01             	add    $0x1,%ebx
80103969:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010396c:	74 0e                	je     8010397c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010396e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103974:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010397a:	75 d4                	jne    80103950 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010397c:	83 ec 0c             	sub    $0xc,%esp
8010397f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103985:	50                   	push   %eax
80103986:	e8 85 09 00 00       	call   80104310 <wakeup>
  release(&p->lock);
8010398b:	89 34 24             	mov    %esi,(%esp)
8010398e:	e8 bd 0d 00 00       	call   80104750 <release>
  return i;
80103993:	83 c4 10             	add    $0x10,%esp
}
80103996:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103999:	89 d8                	mov    %ebx,%eax
8010399b:	5b                   	pop    %ebx
8010399c:	5e                   	pop    %esi
8010399d:	5f                   	pop    %edi
8010399e:	5d                   	pop    %ebp
8010399f:	c3                   	ret    
      release(&p->lock);
801039a0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801039a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801039a8:	56                   	push   %esi
801039a9:	e8 a2 0d 00 00       	call   80104750 <release>
      return -1;
801039ae:	83 c4 10             	add    $0x10,%esp
}
801039b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039b4:	89 d8                	mov    %ebx,%eax
801039b6:	5b                   	pop    %ebx
801039b7:	5e                   	pop    %esi
801039b8:	5f                   	pop    %edi
801039b9:	5d                   	pop    %ebp
801039ba:	c3                   	ret    
801039bb:	66 90                	xchg   %ax,%ax
801039bd:	66 90                	xchg   %ax,%ax
801039bf:	90                   	nop

801039c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039c4:	bb 54 ad 14 80       	mov    $0x8014ad54,%ebx
{
801039c9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801039cc:	68 20 ad 14 80       	push   $0x8014ad20
801039d1:	e8 da 0d 00 00       	call   801047b0 <acquire>
801039d6:	83 c4 10             	add    $0x10,%esp
801039d9:	eb 10                	jmp    801039eb <allocproc+0x2b>
801039db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039df:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039e0:	83 c3 7c             	add    $0x7c,%ebx
801039e3:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
801039e9:	74 75                	je     80103a60 <allocproc+0xa0>
    if(p->state == UNUSED)
801039eb:	8b 43 0c             	mov    0xc(%ebx),%eax
801039ee:	85 c0                	test   %eax,%eax
801039f0:	75 ee                	jne    801039e0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039f2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801039f7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039fa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103a01:	89 43 10             	mov    %eax,0x10(%ebx)
80103a04:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103a07:	68 20 ad 14 80       	push   $0x8014ad20
  p->pid = nextpid++;
80103a0c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103a12:	e8 39 0d 00 00       	call   80104750 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103a17:	e8 d4 ec ff ff       	call   801026f0 <kalloc>
80103a1c:	83 c4 10             	add    $0x10,%esp
80103a1f:	89 43 08             	mov    %eax,0x8(%ebx)
80103a22:	85 c0                	test   %eax,%eax
80103a24:	74 53                	je     80103a79 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a26:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a2c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103a2f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a34:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103a37:	c7 40 14 9d 5a 10 80 	movl   $0x80105a9d,0x14(%eax)
  p->context = (struct context*)sp;
80103a3e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a41:	6a 14                	push   $0x14
80103a43:	6a 00                	push   $0x0
80103a45:	50                   	push   %eax
80103a46:	e8 25 0e 00 00       	call   80104870 <memset>
  p->context->eip = (uint)forkret;
80103a4b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103a4e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a51:	c7 40 10 90 3a 10 80 	movl   $0x80103a90,0x10(%eax)
}
80103a58:	89 d8                	mov    %ebx,%eax
80103a5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a5d:	c9                   	leave  
80103a5e:	c3                   	ret    
80103a5f:	90                   	nop
  release(&ptable.lock);
80103a60:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a63:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a65:	68 20 ad 14 80       	push   $0x8014ad20
80103a6a:	e8 e1 0c 00 00       	call   80104750 <release>
}
80103a6f:	89 d8                	mov    %ebx,%eax
  return 0;
80103a71:	83 c4 10             	add    $0x10,%esp
}
80103a74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a77:	c9                   	leave  
80103a78:	c3                   	ret    
    p->state = UNUSED;
80103a79:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103a80:	31 db                	xor    %ebx,%ebx
}
80103a82:	89 d8                	mov    %ebx,%eax
80103a84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a87:	c9                   	leave  
80103a88:	c3                   	ret    
80103a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a90 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a96:	68 20 ad 14 80       	push   $0x8014ad20
80103a9b:	e8 b0 0c 00 00       	call   80104750 <release>

  if (first) {
80103aa0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103aa5:	83 c4 10             	add    $0x10,%esp
80103aa8:	85 c0                	test   %eax,%eax
80103aaa:	75 04                	jne    80103ab0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103aac:	c9                   	leave  
80103aad:	c3                   	ret    
80103aae:	66 90                	xchg   %ax,%ax
    first = 0;
80103ab0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103ab7:	00 00 00 
    iinit(ROOTDEV);
80103aba:	83 ec 0c             	sub    $0xc,%esp
80103abd:	6a 01                	push   $0x1
80103abf:	e8 9c da ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103ac4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103acb:	e8 00 f4 ff ff       	call   80102ed0 <initlog>
}
80103ad0:	83 c4 10             	add    $0x10,%esp
80103ad3:	c9                   	leave  
80103ad4:	c3                   	ret    
80103ad5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ae0 <pinit>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ae6:	68 a0 7b 10 80       	push   $0x80107ba0
80103aeb:	68 20 ad 14 80       	push   $0x8014ad20
80103af0:	e8 eb 0a 00 00       	call   801045e0 <initlock>
}
80103af5:	83 c4 10             	add    $0x10,%esp
80103af8:	c9                   	leave  
80103af9:	c3                   	ret    
80103afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b00 <mycpu>:
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	56                   	push   %esi
80103b04:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b05:	9c                   	pushf  
80103b06:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b07:	f6 c4 02             	test   $0x2,%ah
80103b0a:	75 46                	jne    80103b52 <mycpu+0x52>
  apicid = lapicid();
80103b0c:	e8 ef ef ff ff       	call   80102b00 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103b11:	8b 35 84 a7 14 80    	mov    0x8014a784,%esi
80103b17:	85 f6                	test   %esi,%esi
80103b19:	7e 2a                	jle    80103b45 <mycpu+0x45>
80103b1b:	31 d2                	xor    %edx,%edx
80103b1d:	eb 08                	jmp    80103b27 <mycpu+0x27>
80103b1f:	90                   	nop
80103b20:	83 c2 01             	add    $0x1,%edx
80103b23:	39 f2                	cmp    %esi,%edx
80103b25:	74 1e                	je     80103b45 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103b27:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103b2d:	0f b6 99 a0 a7 14 80 	movzbl -0x7feb5860(%ecx),%ebx
80103b34:	39 c3                	cmp    %eax,%ebx
80103b36:	75 e8                	jne    80103b20 <mycpu+0x20>
}
80103b38:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103b3b:	8d 81 a0 a7 14 80    	lea    -0x7feb5860(%ecx),%eax
}
80103b41:	5b                   	pop    %ebx
80103b42:	5e                   	pop    %esi
80103b43:	5d                   	pop    %ebp
80103b44:	c3                   	ret    
  panic("unknown apicid\n");
80103b45:	83 ec 0c             	sub    $0xc,%esp
80103b48:	68 a7 7b 10 80       	push   $0x80107ba7
80103b4d:	e8 2e c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b52:	83 ec 0c             	sub    $0xc,%esp
80103b55:	68 84 7c 10 80       	push   $0x80107c84
80103b5a:	e8 21 c8 ff ff       	call   80100380 <panic>
80103b5f:	90                   	nop

80103b60 <cpuid>:
cpuid() {
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b66:	e8 95 ff ff ff       	call   80103b00 <mycpu>
}
80103b6b:	c9                   	leave  
  return mycpu()-cpus;
80103b6c:	2d a0 a7 14 80       	sub    $0x8014a7a0,%eax
80103b71:	c1 f8 04             	sar    $0x4,%eax
80103b74:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b7a:	c3                   	ret    
80103b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b7f:	90                   	nop

80103b80 <myproc>:
myproc(void) {
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	53                   	push   %ebx
80103b84:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b87:	e8 d4 0a 00 00       	call   80104660 <pushcli>
  c = mycpu();
80103b8c:	e8 6f ff ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80103b91:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b97:	e8 14 0b 00 00       	call   801046b0 <popcli>
}
80103b9c:	89 d8                	mov    %ebx,%eax
80103b9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ba1:	c9                   	leave  
80103ba2:	c3                   	ret    
80103ba3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bb0 <userinit>:
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	53                   	push   %ebx
80103bb4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103bb7:	e8 04 fe ff ff       	call   801039c0 <allocproc>
80103bbc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103bbe:	a3 54 cc 14 80       	mov    %eax,0x8014cc54
  if((p->pgdir = setupkvm()) == 0)
80103bc3:	e8 e8 34 00 00       	call   801070b0 <setupkvm>
80103bc8:	89 43 04             	mov    %eax,0x4(%ebx)
80103bcb:	85 c0                	test   %eax,%eax
80103bcd:	0f 84 bd 00 00 00    	je     80103c90 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103bd3:	83 ec 04             	sub    $0x4,%esp
80103bd6:	68 2c 00 00 00       	push   $0x2c
80103bdb:	68 60 b4 10 80       	push   $0x8010b460
80103be0:	50                   	push   %eax
80103be1:	e8 7a 31 00 00       	call   80106d60 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103be6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103be9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103bef:	6a 4c                	push   $0x4c
80103bf1:	6a 00                	push   $0x0
80103bf3:	ff 73 18             	push   0x18(%ebx)
80103bf6:	e8 75 0c 00 00       	call   80104870 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bfb:	8b 43 18             	mov    0x18(%ebx),%eax
80103bfe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c03:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c06:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c0b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c0f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c12:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c16:	8b 43 18             	mov    0x18(%ebx),%eax
80103c19:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c1d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c21:	8b 43 18             	mov    0x18(%ebx),%eax
80103c24:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c28:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c2c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c2f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c36:	8b 43 18             	mov    0x18(%ebx),%eax
80103c39:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c40:	8b 43 18             	mov    0x18(%ebx),%eax
80103c43:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c4a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c4d:	6a 10                	push   $0x10
80103c4f:	68 d0 7b 10 80       	push   $0x80107bd0
80103c54:	50                   	push   %eax
80103c55:	e8 d6 0d 00 00       	call   80104a30 <safestrcpy>
  p->cwd = namei("/");
80103c5a:	c7 04 24 d9 7b 10 80 	movl   $0x80107bd9,(%esp)
80103c61:	e8 3a e4 ff ff       	call   801020a0 <namei>
80103c66:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c69:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103c70:	e8 3b 0b 00 00       	call   801047b0 <acquire>
  p->state = RUNNABLE;
80103c75:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c7c:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103c83:	e8 c8 0a 00 00       	call   80104750 <release>
}
80103c88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c8b:	83 c4 10             	add    $0x10,%esp
80103c8e:	c9                   	leave  
80103c8f:	c3                   	ret    
    panic("userinit: out of memory?");
80103c90:	83 ec 0c             	sub    $0xc,%esp
80103c93:	68 b7 7b 10 80       	push   $0x80107bb7
80103c98:	e8 e3 c6 ff ff       	call   80100380 <panic>
80103c9d:	8d 76 00             	lea    0x0(%esi),%esi

80103ca0 <growproc>:
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	56                   	push   %esi
80103ca4:	53                   	push   %ebx
80103ca5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ca8:	e8 b3 09 00 00       	call   80104660 <pushcli>
  c = mycpu();
80103cad:	e8 4e fe ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80103cb2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cb8:	e8 f3 09 00 00       	call   801046b0 <popcli>
  sz = curproc->sz;
80103cbd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103cbf:	85 f6                	test   %esi,%esi
80103cc1:	7f 1d                	jg     80103ce0 <growproc+0x40>
  } else if(n < 0){
80103cc3:	75 3b                	jne    80103d00 <growproc+0x60>
  switchuvm(curproc);
80103cc5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103cc8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103cca:	53                   	push   %ebx
80103ccb:	e8 80 2f 00 00       	call   80106c50 <switchuvm>
  return 0;
80103cd0:	83 c4 10             	add    $0x10,%esp
80103cd3:	31 c0                	xor    %eax,%eax
}
80103cd5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cd8:	5b                   	pop    %ebx
80103cd9:	5e                   	pop    %esi
80103cda:	5d                   	pop    %ebp
80103cdb:	c3                   	ret    
80103cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ce0:	83 ec 04             	sub    $0x4,%esp
80103ce3:	01 c6                	add    %eax,%esi
80103ce5:	56                   	push   %esi
80103ce6:	50                   	push   %eax
80103ce7:	ff 73 04             	push   0x4(%ebx)
80103cea:	e8 e1 31 00 00       	call   80106ed0 <allocuvm>
80103cef:	83 c4 10             	add    $0x10,%esp
80103cf2:	85 c0                	test   %eax,%eax
80103cf4:	75 cf                	jne    80103cc5 <growproc+0x25>
      return -1;
80103cf6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cfb:	eb d8                	jmp    80103cd5 <growproc+0x35>
80103cfd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d00:	83 ec 04             	sub    $0x4,%esp
80103d03:	01 c6                	add    %eax,%esi
80103d05:	56                   	push   %esi
80103d06:	50                   	push   %eax
80103d07:	ff 73 04             	push   0x4(%ebx)
80103d0a:	e8 f1 32 00 00       	call   80107000 <deallocuvm>
80103d0f:	83 c4 10             	add    $0x10,%esp
80103d12:	85 c0                	test   %eax,%eax
80103d14:	75 af                	jne    80103cc5 <growproc+0x25>
80103d16:	eb de                	jmp    80103cf6 <growproc+0x56>
80103d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d1f:	90                   	nop

80103d20 <fork>:
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	57                   	push   %edi
80103d24:	56                   	push   %esi
80103d25:	53                   	push   %ebx
80103d26:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d29:	e8 32 09 00 00       	call   80104660 <pushcli>
  c = mycpu();
80103d2e:	e8 cd fd ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80103d33:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d39:	e8 72 09 00 00       	call   801046b0 <popcli>
  if((np = allocproc()) == 0){
80103d3e:	e8 7d fc ff ff       	call   801039c0 <allocproc>
80103d43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d46:	85 c0                	test   %eax,%eax
80103d48:	0f 84 b7 00 00 00    	je     80103e05 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d4e:	83 ec 08             	sub    $0x8,%esp
80103d51:	ff 33                	push   (%ebx)
80103d53:	89 c7                	mov    %eax,%edi
80103d55:	ff 73 04             	push   0x4(%ebx)
80103d58:	e8 43 34 00 00       	call   801071a0 <copyuvm>
80103d5d:	83 c4 10             	add    $0x10,%esp
80103d60:	89 47 04             	mov    %eax,0x4(%edi)
80103d63:	85 c0                	test   %eax,%eax
80103d65:	0f 84 a1 00 00 00    	je     80103e0c <fork+0xec>
  np->sz = curproc->sz;
80103d6b:	8b 03                	mov    (%ebx),%eax
80103d6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d70:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d72:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103d75:	89 c8                	mov    %ecx,%eax
80103d77:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103d7a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d7f:	8b 73 18             	mov    0x18(%ebx),%esi
80103d82:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d84:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d86:	8b 40 18             	mov    0x18(%eax),%eax
80103d89:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103d90:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d94:	85 c0                	test   %eax,%eax
80103d96:	74 13                	je     80103dab <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d98:	83 ec 0c             	sub    $0xc,%esp
80103d9b:	50                   	push   %eax
80103d9c:	e8 ff d0 ff ff       	call   80100ea0 <filedup>
80103da1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103da4:	83 c4 10             	add    $0x10,%esp
80103da7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103dab:	83 c6 01             	add    $0x1,%esi
80103dae:	83 fe 10             	cmp    $0x10,%esi
80103db1:	75 dd                	jne    80103d90 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103db3:	83 ec 0c             	sub    $0xc,%esp
80103db6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103db9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103dbc:	e8 8f d9 ff ff       	call   80101750 <idup>
80103dc1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dc4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103dc7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dca:	8d 47 6c             	lea    0x6c(%edi),%eax
80103dcd:	6a 10                	push   $0x10
80103dcf:	53                   	push   %ebx
80103dd0:	50                   	push   %eax
80103dd1:	e8 5a 0c 00 00       	call   80104a30 <safestrcpy>
  pid = np->pid;
80103dd6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103dd9:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103de0:	e8 cb 09 00 00       	call   801047b0 <acquire>
  np->state = RUNNABLE;
80103de5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103dec:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103df3:	e8 58 09 00 00       	call   80104750 <release>
  return pid;
80103df8:	83 c4 10             	add    $0x10,%esp
}
80103dfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dfe:	89 d8                	mov    %ebx,%eax
80103e00:	5b                   	pop    %ebx
80103e01:	5e                   	pop    %esi
80103e02:	5f                   	pop    %edi
80103e03:	5d                   	pop    %ebp
80103e04:	c3                   	ret    
    return -1;
80103e05:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e0a:	eb ef                	jmp    80103dfb <fork+0xdb>
    kfree(np->kstack);
80103e0c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e0f:	83 ec 0c             	sub    $0xc,%esp
80103e12:	ff 73 08             	push   0x8(%ebx)
80103e15:	e8 a6 e6 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103e1a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103e21:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED; 
80103e24:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e2b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e30:	eb c9                	jmp    80103dfb <fork+0xdb>
80103e32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e40 <scheduler>:
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	57                   	push   %edi
80103e44:	56                   	push   %esi
80103e45:	53                   	push   %ebx
80103e46:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e49:	e8 b2 fc ff ff       	call   80103b00 <mycpu>
  c->proc = 0;
80103e4e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e55:	00 00 00 
  struct cpu *c = mycpu();
80103e58:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e5a:	8d 78 04             	lea    0x4(%eax),%edi
80103e5d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103e60:	fb                   	sti    
    acquire(&ptable.lock);
80103e61:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e64:	bb 54 ad 14 80       	mov    $0x8014ad54,%ebx
    acquire(&ptable.lock);
80103e69:	68 20 ad 14 80       	push   $0x8014ad20
80103e6e:	e8 3d 09 00 00       	call   801047b0 <acquire>
80103e73:	83 c4 10             	add    $0x10,%esp
80103e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e7d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103e80:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e84:	75 33                	jne    80103eb9 <scheduler+0x79>
      switchuvm(p);
80103e86:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e89:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103e8f:	53                   	push   %ebx
80103e90:	e8 bb 2d 00 00       	call   80106c50 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103e95:	58                   	pop    %eax
80103e96:	5a                   	pop    %edx
80103e97:	ff 73 1c             	push   0x1c(%ebx)
80103e9a:	57                   	push   %edi
      p->state = RUNNING;
80103e9b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103ea2:	e8 e4 0b 00 00       	call   80104a8b <swtch>
      switchkvm();
80103ea7:	e8 94 2d 00 00       	call   80106c40 <switchkvm>
      c->proc = 0;
80103eac:	83 c4 10             	add    $0x10,%esp
80103eaf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103eb6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eb9:	83 c3 7c             	add    $0x7c,%ebx
80103ebc:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
80103ec2:	75 bc                	jne    80103e80 <scheduler+0x40>
    release(&ptable.lock);
80103ec4:	83 ec 0c             	sub    $0xc,%esp
80103ec7:	68 20 ad 14 80       	push   $0x8014ad20
80103ecc:	e8 7f 08 00 00       	call   80104750 <release>
    sti();
80103ed1:	83 c4 10             	add    $0x10,%esp
80103ed4:	eb 8a                	jmp    80103e60 <scheduler+0x20>
80103ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103edd:	8d 76 00             	lea    0x0(%esi),%esi

80103ee0 <sched>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	56                   	push   %esi
80103ee4:	53                   	push   %ebx
  pushcli();
80103ee5:	e8 76 07 00 00       	call   80104660 <pushcli>
  c = mycpu();
80103eea:	e8 11 fc ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80103eef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ef5:	e8 b6 07 00 00       	call   801046b0 <popcli>
  if(!holding(&ptable.lock))
80103efa:	83 ec 0c             	sub    $0xc,%esp
80103efd:	68 20 ad 14 80       	push   $0x8014ad20
80103f02:	e8 09 08 00 00       	call   80104710 <holding>
80103f07:	83 c4 10             	add    $0x10,%esp
80103f0a:	85 c0                	test   %eax,%eax
80103f0c:	74 4f                	je     80103f5d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103f0e:	e8 ed fb ff ff       	call   80103b00 <mycpu>
80103f13:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f1a:	75 68                	jne    80103f84 <sched+0xa4>
  if(p->state == RUNNING)
80103f1c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f20:	74 55                	je     80103f77 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f22:	9c                   	pushf  
80103f23:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f24:	f6 c4 02             	test   $0x2,%ah
80103f27:	75 41                	jne    80103f6a <sched+0x8a>
  intena = mycpu()->intena;
80103f29:	e8 d2 fb ff ff       	call   80103b00 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f2e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103f31:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f37:	e8 c4 fb ff ff       	call   80103b00 <mycpu>
80103f3c:	83 ec 08             	sub    $0x8,%esp
80103f3f:	ff 70 04             	push   0x4(%eax)
80103f42:	53                   	push   %ebx
80103f43:	e8 43 0b 00 00       	call   80104a8b <swtch>
  mycpu()->intena = intena;
80103f48:	e8 b3 fb ff ff       	call   80103b00 <mycpu>
}
80103f4d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f50:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f56:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f59:	5b                   	pop    %ebx
80103f5a:	5e                   	pop    %esi
80103f5b:	5d                   	pop    %ebp
80103f5c:	c3                   	ret    
    panic("sched ptable.lock");
80103f5d:	83 ec 0c             	sub    $0xc,%esp
80103f60:	68 db 7b 10 80       	push   $0x80107bdb
80103f65:	e8 16 c4 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103f6a:	83 ec 0c             	sub    $0xc,%esp
80103f6d:	68 07 7c 10 80       	push   $0x80107c07
80103f72:	e8 09 c4 ff ff       	call   80100380 <panic>
    panic("sched running");
80103f77:	83 ec 0c             	sub    $0xc,%esp
80103f7a:	68 f9 7b 10 80       	push   $0x80107bf9
80103f7f:	e8 fc c3 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103f84:	83 ec 0c             	sub    $0xc,%esp
80103f87:	68 ed 7b 10 80       	push   $0x80107bed
80103f8c:	e8 ef c3 ff ff       	call   80100380 <panic>
80103f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f9f:	90                   	nop

80103fa0 <exit>:
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	57                   	push   %edi
80103fa4:	56                   	push   %esi
80103fa5:	53                   	push   %ebx
80103fa6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103fa9:	e8 d2 fb ff ff       	call   80103b80 <myproc>
  if(curproc == initproc)
80103fae:	39 05 54 cc 14 80    	cmp    %eax,0x8014cc54
80103fb4:	0f 84 fd 00 00 00    	je     801040b7 <exit+0x117>
80103fba:	89 c3                	mov    %eax,%ebx
80103fbc:	8d 70 28             	lea    0x28(%eax),%esi
80103fbf:	8d 78 68             	lea    0x68(%eax),%edi
80103fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103fc8:	8b 06                	mov    (%esi),%eax
80103fca:	85 c0                	test   %eax,%eax
80103fcc:	74 12                	je     80103fe0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103fce:	83 ec 0c             	sub    $0xc,%esp
80103fd1:	50                   	push   %eax
80103fd2:	e8 19 cf ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103fd7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103fdd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103fe0:	83 c6 04             	add    $0x4,%esi
80103fe3:	39 f7                	cmp    %esi,%edi
80103fe5:	75 e1                	jne    80103fc8 <exit+0x28>
  begin_op();
80103fe7:	e8 84 ef ff ff       	call   80102f70 <begin_op>
  iput(curproc->cwd);
80103fec:	83 ec 0c             	sub    $0xc,%esp
80103fef:	ff 73 68             	push   0x68(%ebx)
80103ff2:	e8 b9 d8 ff ff       	call   801018b0 <iput>
  end_op();
80103ff7:	e8 e4 ef ff ff       	call   80102fe0 <end_op>
  curproc->cwd = 0;
80103ffc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104003:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
8010400a:	e8 a1 07 00 00       	call   801047b0 <acquire>
  wakeup1(curproc->parent);
8010400f:	8b 53 14             	mov    0x14(%ebx),%edx
80104012:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104015:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
8010401a:	eb 0e                	jmp    8010402a <exit+0x8a>
8010401c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104020:	83 c0 7c             	add    $0x7c,%eax
80104023:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104028:	74 1c                	je     80104046 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010402a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010402e:	75 f0                	jne    80104020 <exit+0x80>
80104030:	3b 50 20             	cmp    0x20(%eax),%edx
80104033:	75 eb                	jne    80104020 <exit+0x80>
      p->state = RUNNABLE;
80104035:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010403c:	83 c0 7c             	add    $0x7c,%eax
8010403f:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104044:	75 e4                	jne    8010402a <exit+0x8a>
      p->parent = initproc;
80104046:	8b 0d 54 cc 14 80    	mov    0x8014cc54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010404c:	ba 54 ad 14 80       	mov    $0x8014ad54,%edx
80104051:	eb 10                	jmp    80104063 <exit+0xc3>
80104053:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104057:	90                   	nop
80104058:	83 c2 7c             	add    $0x7c,%edx
8010405b:	81 fa 54 cc 14 80    	cmp    $0x8014cc54,%edx
80104061:	74 3b                	je     8010409e <exit+0xfe>
    if(p->parent == curproc){
80104063:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104066:	75 f0                	jne    80104058 <exit+0xb8>
      if(p->state == ZOMBIE)
80104068:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010406c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010406f:	75 e7                	jne    80104058 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104071:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
80104076:	eb 12                	jmp    8010408a <exit+0xea>
80104078:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010407f:	90                   	nop
80104080:	83 c0 7c             	add    $0x7c,%eax
80104083:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104088:	74 ce                	je     80104058 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010408a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010408e:	75 f0                	jne    80104080 <exit+0xe0>
80104090:	3b 48 20             	cmp    0x20(%eax),%ecx
80104093:	75 eb                	jne    80104080 <exit+0xe0>
      p->state = RUNNABLE;
80104095:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010409c:	eb e2                	jmp    80104080 <exit+0xe0>
  curproc->state = ZOMBIE;
8010409e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801040a5:	e8 36 fe ff ff       	call   80103ee0 <sched>
  panic("zombie exit");
801040aa:	83 ec 0c             	sub    $0xc,%esp
801040ad:	68 28 7c 10 80       	push   $0x80107c28
801040b2:	e8 c9 c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
801040b7:	83 ec 0c             	sub    $0xc,%esp
801040ba:	68 1b 7c 10 80       	push   $0x80107c1b
801040bf:	e8 bc c2 ff ff       	call   80100380 <panic>
801040c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040cf:	90                   	nop

801040d0 <wait>:
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	56                   	push   %esi
801040d4:	53                   	push   %ebx
  pushcli();
801040d5:	e8 86 05 00 00       	call   80104660 <pushcli>
  c = mycpu();
801040da:	e8 21 fa ff ff       	call   80103b00 <mycpu>
  p = c->proc;
801040df:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040e5:	e8 c6 05 00 00       	call   801046b0 <popcli>
  acquire(&ptable.lock);
801040ea:	83 ec 0c             	sub    $0xc,%esp
801040ed:	68 20 ad 14 80       	push   $0x8014ad20
801040f2:	e8 b9 06 00 00       	call   801047b0 <acquire>
801040f7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801040fa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040fc:	bb 54 ad 14 80       	mov    $0x8014ad54,%ebx
80104101:	eb 10                	jmp    80104113 <wait+0x43>
80104103:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104107:	90                   	nop
80104108:	83 c3 7c             	add    $0x7c,%ebx
8010410b:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
80104111:	74 1b                	je     8010412e <wait+0x5e>
      if(p->parent != curproc)
80104113:	39 73 14             	cmp    %esi,0x14(%ebx)
80104116:	75 f0                	jne    80104108 <wait+0x38>
      if(p->state == ZOMBIE){
80104118:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010411c:	74 62                	je     80104180 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010411e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104121:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104126:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
8010412c:	75 e5                	jne    80104113 <wait+0x43>
    if(!havekids || curproc->killed){
8010412e:	85 c0                	test   %eax,%eax
80104130:	0f 84 a0 00 00 00    	je     801041d6 <wait+0x106>
80104136:	8b 46 24             	mov    0x24(%esi),%eax
80104139:	85 c0                	test   %eax,%eax
8010413b:	0f 85 95 00 00 00    	jne    801041d6 <wait+0x106>
  pushcli();
80104141:	e8 1a 05 00 00       	call   80104660 <pushcli>
  c = mycpu();
80104146:	e8 b5 f9 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
8010414b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104151:	e8 5a 05 00 00       	call   801046b0 <popcli>
  if(p == 0)
80104156:	85 db                	test   %ebx,%ebx
80104158:	0f 84 8f 00 00 00    	je     801041ed <wait+0x11d>
  p->chan = chan;
8010415e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104161:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104168:	e8 73 fd ff ff       	call   80103ee0 <sched>
  p->chan = 0;
8010416d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104174:	eb 84                	jmp    801040fa <wait+0x2a>
80104176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010417d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104180:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104183:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104186:	ff 73 08             	push   0x8(%ebx)
80104189:	e8 32 e3 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
8010418e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104195:	5a                   	pop    %edx
80104196:	ff 73 04             	push   0x4(%ebx)
80104199:	e8 92 2e 00 00       	call   80107030 <freevm>
        p->pid = 0;
8010419e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801041a5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801041ac:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801041b0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801041b7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801041be:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
801041c5:	e8 86 05 00 00       	call   80104750 <release>
        return pid;
801041ca:	83 c4 10             	add    $0x10,%esp
}
801041cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041d0:	89 f0                	mov    %esi,%eax
801041d2:	5b                   	pop    %ebx
801041d3:	5e                   	pop    %esi
801041d4:	5d                   	pop    %ebp
801041d5:	c3                   	ret    
      release(&ptable.lock);
801041d6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041d9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041de:	68 20 ad 14 80       	push   $0x8014ad20
801041e3:	e8 68 05 00 00       	call   80104750 <release>
      return -1;
801041e8:	83 c4 10             	add    $0x10,%esp
801041eb:	eb e0                	jmp    801041cd <wait+0xfd>
    panic("sleep");
801041ed:	83 ec 0c             	sub    $0xc,%esp
801041f0:	68 34 7c 10 80       	push   $0x80107c34
801041f5:	e8 86 c1 ff ff       	call   80100380 <panic>
801041fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104200 <yield>:
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	53                   	push   %ebx
80104204:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104207:	68 20 ad 14 80       	push   $0x8014ad20
8010420c:	e8 9f 05 00 00       	call   801047b0 <acquire>
  pushcli();
80104211:	e8 4a 04 00 00       	call   80104660 <pushcli>
  c = mycpu();
80104216:	e8 e5 f8 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
8010421b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104221:	e8 8a 04 00 00       	call   801046b0 <popcli>
  myproc()->state = RUNNABLE;
80104226:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010422d:	e8 ae fc ff ff       	call   80103ee0 <sched>
  release(&ptable.lock);
80104232:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80104239:	e8 12 05 00 00       	call   80104750 <release>
}
8010423e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104241:	83 c4 10             	add    $0x10,%esp
80104244:	c9                   	leave  
80104245:	c3                   	ret    
80104246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010424d:	8d 76 00             	lea    0x0(%esi),%esi

80104250 <sleep>:
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	57                   	push   %edi
80104254:	56                   	push   %esi
80104255:	53                   	push   %ebx
80104256:	83 ec 0c             	sub    $0xc,%esp
80104259:	8b 7d 08             	mov    0x8(%ebp),%edi
8010425c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010425f:	e8 fc 03 00 00       	call   80104660 <pushcli>
  c = mycpu();
80104264:	e8 97 f8 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80104269:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010426f:	e8 3c 04 00 00       	call   801046b0 <popcli>
  if(p == 0)
80104274:	85 db                	test   %ebx,%ebx
80104276:	0f 84 87 00 00 00    	je     80104303 <sleep+0xb3>
  if(lk == 0)
8010427c:	85 f6                	test   %esi,%esi
8010427e:	74 76                	je     801042f6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104280:	81 fe 20 ad 14 80    	cmp    $0x8014ad20,%esi
80104286:	74 50                	je     801042d8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104288:	83 ec 0c             	sub    $0xc,%esp
8010428b:	68 20 ad 14 80       	push   $0x8014ad20
80104290:	e8 1b 05 00 00       	call   801047b0 <acquire>
    release(lk);
80104295:	89 34 24             	mov    %esi,(%esp)
80104298:	e8 b3 04 00 00       	call   80104750 <release>
  p->chan = chan;
8010429d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042a0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042a7:	e8 34 fc ff ff       	call   80103ee0 <sched>
  p->chan = 0;
801042ac:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801042b3:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
801042ba:	e8 91 04 00 00       	call   80104750 <release>
    acquire(lk);
801042bf:	89 75 08             	mov    %esi,0x8(%ebp)
801042c2:	83 c4 10             	add    $0x10,%esp
}
801042c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042c8:	5b                   	pop    %ebx
801042c9:	5e                   	pop    %esi
801042ca:	5f                   	pop    %edi
801042cb:	5d                   	pop    %ebp
    acquire(lk);
801042cc:	e9 df 04 00 00       	jmp    801047b0 <acquire>
801042d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801042d8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042db:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042e2:	e8 f9 fb ff ff       	call   80103ee0 <sched>
  p->chan = 0;
801042e7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801042ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042f1:	5b                   	pop    %ebx
801042f2:	5e                   	pop    %esi
801042f3:	5f                   	pop    %edi
801042f4:	5d                   	pop    %ebp
801042f5:	c3                   	ret    
    panic("sleep without lk");
801042f6:	83 ec 0c             	sub    $0xc,%esp
801042f9:	68 3a 7c 10 80       	push   $0x80107c3a
801042fe:	e8 7d c0 ff ff       	call   80100380 <panic>
    panic("sleep");
80104303:	83 ec 0c             	sub    $0xc,%esp
80104306:	68 34 7c 10 80       	push   $0x80107c34
8010430b:	e8 70 c0 ff ff       	call   80100380 <panic>

80104310 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	53                   	push   %ebx
80104314:	83 ec 10             	sub    $0x10,%esp
80104317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010431a:	68 20 ad 14 80       	push   $0x8014ad20
8010431f:	e8 8c 04 00 00       	call   801047b0 <acquire>
80104324:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104327:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
8010432c:	eb 0c                	jmp    8010433a <wakeup+0x2a>
8010432e:	66 90                	xchg   %ax,%ax
80104330:	83 c0 7c             	add    $0x7c,%eax
80104333:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104338:	74 1c                	je     80104356 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010433a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010433e:	75 f0                	jne    80104330 <wakeup+0x20>
80104340:	3b 58 20             	cmp    0x20(%eax),%ebx
80104343:	75 eb                	jne    80104330 <wakeup+0x20>
      p->state = RUNNABLE;
80104345:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010434c:	83 c0 7c             	add    $0x7c,%eax
8010434f:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104354:	75 e4                	jne    8010433a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104356:	c7 45 08 20 ad 14 80 	movl   $0x8014ad20,0x8(%ebp)
}
8010435d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104360:	c9                   	leave  
  release(&ptable.lock);
80104361:	e9 ea 03 00 00       	jmp    80104750 <release>
80104366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010436d:	8d 76 00             	lea    0x0(%esi),%esi

80104370 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	53                   	push   %ebx
80104374:	83 ec 10             	sub    $0x10,%esp
80104377:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010437a:	68 20 ad 14 80       	push   $0x8014ad20
8010437f:	e8 2c 04 00 00       	call   801047b0 <acquire>
80104384:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104387:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
8010438c:	eb 0c                	jmp    8010439a <kill+0x2a>
8010438e:	66 90                	xchg   %ax,%ax
80104390:	83 c0 7c             	add    $0x7c,%eax
80104393:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104398:	74 36                	je     801043d0 <kill+0x60>
    if(p->pid == pid){
8010439a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010439d:	75 f1                	jne    80104390 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010439f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801043a3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801043aa:	75 07                	jne    801043b3 <kill+0x43>
        p->state = RUNNABLE;
801043ac:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801043b3:	83 ec 0c             	sub    $0xc,%esp
801043b6:	68 20 ad 14 80       	push   $0x8014ad20
801043bb:	e8 90 03 00 00       	call   80104750 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801043c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801043c3:	83 c4 10             	add    $0x10,%esp
801043c6:	31 c0                	xor    %eax,%eax
}
801043c8:	c9                   	leave  
801043c9:	c3                   	ret    
801043ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801043d0:	83 ec 0c             	sub    $0xc,%esp
801043d3:	68 20 ad 14 80       	push   $0x8014ad20
801043d8:	e8 73 03 00 00       	call   80104750 <release>
}
801043dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801043e0:	83 c4 10             	add    $0x10,%esp
801043e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043e8:	c9                   	leave  
801043e9:	c3                   	ret    
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043f0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	57                   	push   %edi
801043f4:	56                   	push   %esi
801043f5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801043f8:	53                   	push   %ebx
801043f9:	bb c0 ad 14 80       	mov    $0x8014adc0,%ebx
801043fe:	83 ec 3c             	sub    $0x3c,%esp
80104401:	eb 24                	jmp    80104427 <procdump+0x37>
80104403:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104407:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104408:	83 ec 0c             	sub    $0xc,%esp
8010440b:	68 0f 80 10 80       	push   $0x8010800f
80104410:	e8 8b c2 ff ff       	call   801006a0 <cprintf>
80104415:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104418:	83 c3 7c             	add    $0x7c,%ebx
8010441b:	81 fb c0 cc 14 80    	cmp    $0x8014ccc0,%ebx
80104421:	0f 84 81 00 00 00    	je     801044a8 <procdump+0xb8>
    if(p->state == UNUSED)
80104427:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010442a:	85 c0                	test   %eax,%eax
8010442c:	74 ea                	je     80104418 <procdump+0x28>
      state = "???";
8010442e:	ba 4b 7c 10 80       	mov    $0x80107c4b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104433:	83 f8 05             	cmp    $0x5,%eax
80104436:	77 11                	ja     80104449 <procdump+0x59>
80104438:	8b 14 85 ac 7c 10 80 	mov    -0x7fef8354(,%eax,4),%edx
      state = "???";
8010443f:	b8 4b 7c 10 80       	mov    $0x80107c4b,%eax
80104444:	85 d2                	test   %edx,%edx
80104446:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104449:	53                   	push   %ebx
8010444a:	52                   	push   %edx
8010444b:	ff 73 a4             	push   -0x5c(%ebx)
8010444e:	68 4f 7c 10 80       	push   $0x80107c4f
80104453:	e8 48 c2 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104458:	83 c4 10             	add    $0x10,%esp
8010445b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010445f:	75 a7                	jne    80104408 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104461:	83 ec 08             	sub    $0x8,%esp
80104464:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104467:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010446a:	50                   	push   %eax
8010446b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010446e:	8b 40 0c             	mov    0xc(%eax),%eax
80104471:	83 c0 08             	add    $0x8,%eax
80104474:	50                   	push   %eax
80104475:	e8 86 01 00 00       	call   80104600 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010447a:	83 c4 10             	add    $0x10,%esp
8010447d:	8d 76 00             	lea    0x0(%esi),%esi
80104480:	8b 17                	mov    (%edi),%edx
80104482:	85 d2                	test   %edx,%edx
80104484:	74 82                	je     80104408 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104486:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104489:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010448c:	52                   	push   %edx
8010448d:	68 a1 76 10 80       	push   $0x801076a1
80104492:	e8 09 c2 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104497:	83 c4 10             	add    $0x10,%esp
8010449a:	39 fe                	cmp    %edi,%esi
8010449c:	75 e2                	jne    80104480 <procdump+0x90>
8010449e:	e9 65 ff ff ff       	jmp    80104408 <procdump+0x18>
801044a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044a7:	90                   	nop
  }
801044a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044ab:	5b                   	pop    %ebx
801044ac:	5e                   	pop    %esi
801044ad:	5f                   	pop    %edi
801044ae:	5d                   	pop    %ebp
801044af:	c3                   	ret    

801044b0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	53                   	push   %ebx
801044b4:	83 ec 0c             	sub    $0xc,%esp
801044b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801044ba:	68 c4 7c 10 80       	push   $0x80107cc4
801044bf:	8d 43 04             	lea    0x4(%ebx),%eax
801044c2:	50                   	push   %eax
801044c3:	e8 18 01 00 00       	call   801045e0 <initlock>
  lk->name = name;
801044c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801044cb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801044d1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801044d4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801044db:	89 43 38             	mov    %eax,0x38(%ebx)
}
801044de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044e1:	c9                   	leave  
801044e2:	c3                   	ret    
801044e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044f0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	56                   	push   %esi
801044f4:	53                   	push   %ebx
801044f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044f8:	8d 73 04             	lea    0x4(%ebx),%esi
801044fb:	83 ec 0c             	sub    $0xc,%esp
801044fe:	56                   	push   %esi
801044ff:	e8 ac 02 00 00       	call   801047b0 <acquire>
  while (lk->locked) {
80104504:	8b 13                	mov    (%ebx),%edx
80104506:	83 c4 10             	add    $0x10,%esp
80104509:	85 d2                	test   %edx,%edx
8010450b:	74 16                	je     80104523 <acquiresleep+0x33>
8010450d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104510:	83 ec 08             	sub    $0x8,%esp
80104513:	56                   	push   %esi
80104514:	53                   	push   %ebx
80104515:	e8 36 fd ff ff       	call   80104250 <sleep>
  while (lk->locked) {
8010451a:	8b 03                	mov    (%ebx),%eax
8010451c:	83 c4 10             	add    $0x10,%esp
8010451f:	85 c0                	test   %eax,%eax
80104521:	75 ed                	jne    80104510 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104523:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104529:	e8 52 f6 ff ff       	call   80103b80 <myproc>
8010452e:	8b 40 10             	mov    0x10(%eax),%eax
80104531:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104534:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104537:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010453a:	5b                   	pop    %ebx
8010453b:	5e                   	pop    %esi
8010453c:	5d                   	pop    %ebp
  release(&lk->lk);
8010453d:	e9 0e 02 00 00       	jmp    80104750 <release>
80104542:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104550 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	56                   	push   %esi
80104554:	53                   	push   %ebx
80104555:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104558:	8d 73 04             	lea    0x4(%ebx),%esi
8010455b:	83 ec 0c             	sub    $0xc,%esp
8010455e:	56                   	push   %esi
8010455f:	e8 4c 02 00 00       	call   801047b0 <acquire>
  lk->locked = 0;
80104564:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010456a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104571:	89 1c 24             	mov    %ebx,(%esp)
80104574:	e8 97 fd ff ff       	call   80104310 <wakeup>
  release(&lk->lk);
80104579:	89 75 08             	mov    %esi,0x8(%ebp)
8010457c:	83 c4 10             	add    $0x10,%esp
}
8010457f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104582:	5b                   	pop    %ebx
80104583:	5e                   	pop    %esi
80104584:	5d                   	pop    %ebp
  release(&lk->lk);
80104585:	e9 c6 01 00 00       	jmp    80104750 <release>
8010458a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104590 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	57                   	push   %edi
80104594:	31 ff                	xor    %edi,%edi
80104596:	56                   	push   %esi
80104597:	53                   	push   %ebx
80104598:	83 ec 18             	sub    $0x18,%esp
8010459b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010459e:	8d 73 04             	lea    0x4(%ebx),%esi
801045a1:	56                   	push   %esi
801045a2:	e8 09 02 00 00       	call   801047b0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801045a7:	8b 03                	mov    (%ebx),%eax
801045a9:	83 c4 10             	add    $0x10,%esp
801045ac:	85 c0                	test   %eax,%eax
801045ae:	75 18                	jne    801045c8 <holdingsleep+0x38>
  release(&lk->lk);
801045b0:	83 ec 0c             	sub    $0xc,%esp
801045b3:	56                   	push   %esi
801045b4:	e8 97 01 00 00       	call   80104750 <release>
  return r;
}
801045b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045bc:	89 f8                	mov    %edi,%eax
801045be:	5b                   	pop    %ebx
801045bf:	5e                   	pop    %esi
801045c0:	5f                   	pop    %edi
801045c1:	5d                   	pop    %ebp
801045c2:	c3                   	ret    
801045c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045c7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801045c8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801045cb:	e8 b0 f5 ff ff       	call   80103b80 <myproc>
801045d0:	39 58 10             	cmp    %ebx,0x10(%eax)
801045d3:	0f 94 c0             	sete   %al
801045d6:	0f b6 c0             	movzbl %al,%eax
801045d9:	89 c7                	mov    %eax,%edi
801045db:	eb d3                	jmp    801045b0 <holdingsleep+0x20>
801045dd:	66 90                	xchg   %ax,%ax
801045df:	90                   	nop

801045e0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801045e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801045e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801045ef:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801045f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801045f9:	5d                   	pop    %ebp
801045fa:	c3                   	ret    
801045fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045ff:	90                   	nop

80104600 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104600:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104601:	31 d2                	xor    %edx,%edx
{
80104603:	89 e5                	mov    %esp,%ebp
80104605:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104606:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104609:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010460c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010460f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104610:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104616:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010461c:	77 1a                	ja     80104638 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010461e:	8b 58 04             	mov    0x4(%eax),%ebx
80104621:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104624:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104627:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104629:	83 fa 0a             	cmp    $0xa,%edx
8010462c:	75 e2                	jne    80104610 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010462e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104631:	c9                   	leave  
80104632:	c3                   	ret    
80104633:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104637:	90                   	nop
  for(; i < 10; i++)
80104638:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010463b:	8d 51 28             	lea    0x28(%ecx),%edx
8010463e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104640:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104646:	83 c0 04             	add    $0x4,%eax
80104649:	39 d0                	cmp    %edx,%eax
8010464b:	75 f3                	jne    80104640 <getcallerpcs+0x40>
}
8010464d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104650:	c9                   	leave  
80104651:	c3                   	ret    
80104652:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104660 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	53                   	push   %ebx
80104664:	83 ec 04             	sub    $0x4,%esp
80104667:	9c                   	pushf  
80104668:	5b                   	pop    %ebx
  asm volatile("cli");
80104669:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010466a:	e8 91 f4 ff ff       	call   80103b00 <mycpu>
8010466f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104675:	85 c0                	test   %eax,%eax
80104677:	74 17                	je     80104690 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104679:	e8 82 f4 ff ff       	call   80103b00 <mycpu>
8010467e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104685:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104688:	c9                   	leave  
80104689:	c3                   	ret    
8010468a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104690:	e8 6b f4 ff ff       	call   80103b00 <mycpu>
80104695:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010469b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801046a1:	eb d6                	jmp    80104679 <pushcli+0x19>
801046a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046b0 <popcli>:

void
popcli(void)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046b6:	9c                   	pushf  
801046b7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801046b8:	f6 c4 02             	test   $0x2,%ah
801046bb:	75 35                	jne    801046f2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801046bd:	e8 3e f4 ff ff       	call   80103b00 <mycpu>
801046c2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801046c9:	78 34                	js     801046ff <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046cb:	e8 30 f4 ff ff       	call   80103b00 <mycpu>
801046d0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801046d6:	85 d2                	test   %edx,%edx
801046d8:	74 06                	je     801046e0 <popcli+0x30>
    sti();
}
801046da:	c9                   	leave  
801046db:	c3                   	ret    
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046e0:	e8 1b f4 ff ff       	call   80103b00 <mycpu>
801046e5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801046eb:	85 c0                	test   %eax,%eax
801046ed:	74 eb                	je     801046da <popcli+0x2a>
  asm volatile("sti");
801046ef:	fb                   	sti    
}
801046f0:	c9                   	leave  
801046f1:	c3                   	ret    
    panic("popcli - interruptible");
801046f2:	83 ec 0c             	sub    $0xc,%esp
801046f5:	68 cf 7c 10 80       	push   $0x80107ccf
801046fa:	e8 81 bc ff ff       	call   80100380 <panic>
    panic("popcli");
801046ff:	83 ec 0c             	sub    $0xc,%esp
80104702:	68 e6 7c 10 80       	push   $0x80107ce6
80104707:	e8 74 bc ff ff       	call   80100380 <panic>
8010470c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104710 <holding>:
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	56                   	push   %esi
80104714:	53                   	push   %ebx
80104715:	8b 75 08             	mov    0x8(%ebp),%esi
80104718:	31 db                	xor    %ebx,%ebx
  pushcli();
8010471a:	e8 41 ff ff ff       	call   80104660 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010471f:	8b 06                	mov    (%esi),%eax
80104721:	85 c0                	test   %eax,%eax
80104723:	75 0b                	jne    80104730 <holding+0x20>
  popcli();
80104725:	e8 86 ff ff ff       	call   801046b0 <popcli>
}
8010472a:	89 d8                	mov    %ebx,%eax
8010472c:	5b                   	pop    %ebx
8010472d:	5e                   	pop    %esi
8010472e:	5d                   	pop    %ebp
8010472f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104730:	8b 5e 08             	mov    0x8(%esi),%ebx
80104733:	e8 c8 f3 ff ff       	call   80103b00 <mycpu>
80104738:	39 c3                	cmp    %eax,%ebx
8010473a:	0f 94 c3             	sete   %bl
  popcli();
8010473d:	e8 6e ff ff ff       	call   801046b0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104742:	0f b6 db             	movzbl %bl,%ebx
}
80104745:	89 d8                	mov    %ebx,%eax
80104747:	5b                   	pop    %ebx
80104748:	5e                   	pop    %esi
80104749:	5d                   	pop    %ebp
8010474a:	c3                   	ret    
8010474b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010474f:	90                   	nop

80104750 <release>:
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	56                   	push   %esi
80104754:	53                   	push   %ebx
80104755:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104758:	e8 03 ff ff ff       	call   80104660 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010475d:	8b 03                	mov    (%ebx),%eax
8010475f:	85 c0                	test   %eax,%eax
80104761:	75 15                	jne    80104778 <release+0x28>
  popcli();
80104763:	e8 48 ff ff ff       	call   801046b0 <popcli>
    panic("release");
80104768:	83 ec 0c             	sub    $0xc,%esp
8010476b:	68 ed 7c 10 80       	push   $0x80107ced
80104770:	e8 0b bc ff ff       	call   80100380 <panic>
80104775:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104778:	8b 73 08             	mov    0x8(%ebx),%esi
8010477b:	e8 80 f3 ff ff       	call   80103b00 <mycpu>
80104780:	39 c6                	cmp    %eax,%esi
80104782:	75 df                	jne    80104763 <release+0x13>
  popcli();
80104784:	e8 27 ff ff ff       	call   801046b0 <popcli>
  lk->pcs[0] = 0;
80104789:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104790:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104797:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010479c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801047a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047a5:	5b                   	pop    %ebx
801047a6:	5e                   	pop    %esi
801047a7:	5d                   	pop    %ebp
  popcli();
801047a8:	e9 03 ff ff ff       	jmp    801046b0 <popcli>
801047ad:	8d 76 00             	lea    0x0(%esi),%esi

801047b0 <acquire>:
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	53                   	push   %ebx
801047b4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801047b7:	e8 a4 fe ff ff       	call   80104660 <pushcli>
  if(holding(lk))
801047bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801047bf:	e8 9c fe ff ff       	call   80104660 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047c4:	8b 03                	mov    (%ebx),%eax
801047c6:	85 c0                	test   %eax,%eax
801047c8:	75 7e                	jne    80104848 <acquire+0x98>
  popcli();
801047ca:	e8 e1 fe ff ff       	call   801046b0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801047cf:	b9 01 00 00 00       	mov    $0x1,%ecx
801047d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801047d8:	8b 55 08             	mov    0x8(%ebp),%edx
801047db:	89 c8                	mov    %ecx,%eax
801047dd:	f0 87 02             	lock xchg %eax,(%edx)
801047e0:	85 c0                	test   %eax,%eax
801047e2:	75 f4                	jne    801047d8 <acquire+0x28>
  __sync_synchronize();
801047e4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801047e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047ec:	e8 0f f3 ff ff       	call   80103b00 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801047f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801047f4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801047f6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801047f9:	31 c0                	xor    %eax,%eax
801047fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104800:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104806:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010480c:	77 1a                	ja     80104828 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010480e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104811:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104815:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104818:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010481a:	83 f8 0a             	cmp    $0xa,%eax
8010481d:	75 e1                	jne    80104800 <acquire+0x50>
}
8010481f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104822:	c9                   	leave  
80104823:	c3                   	ret    
80104824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104828:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010482c:	8d 51 34             	lea    0x34(%ecx),%edx
8010482f:	90                   	nop
    pcs[i] = 0;
80104830:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104836:	83 c0 04             	add    $0x4,%eax
80104839:	39 c2                	cmp    %eax,%edx
8010483b:	75 f3                	jne    80104830 <acquire+0x80>
}
8010483d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104840:	c9                   	leave  
80104841:	c3                   	ret    
80104842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104848:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010484b:	e8 b0 f2 ff ff       	call   80103b00 <mycpu>
80104850:	39 c3                	cmp    %eax,%ebx
80104852:	0f 85 72 ff ff ff    	jne    801047ca <acquire+0x1a>
  popcli();
80104858:	e8 53 fe ff ff       	call   801046b0 <popcli>
    panic("acquire");
8010485d:	83 ec 0c             	sub    $0xc,%esp
80104860:	68 f5 7c 10 80       	push   $0x80107cf5
80104865:	e8 16 bb ff ff       	call   80100380 <panic>
8010486a:	66 90                	xchg   %ax,%ax
8010486c:	66 90                	xchg   %ax,%ax
8010486e:	66 90                	xchg   %ax,%ax

80104870 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	57                   	push   %edi
80104874:	8b 55 08             	mov    0x8(%ebp),%edx
80104877:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010487a:	53                   	push   %ebx
8010487b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010487e:	89 d7                	mov    %edx,%edi
80104880:	09 cf                	or     %ecx,%edi
80104882:	83 e7 03             	and    $0x3,%edi
80104885:	75 29                	jne    801048b0 <memset+0x40>
    c &= 0xFF;
80104887:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010488a:	c1 e0 18             	shl    $0x18,%eax
8010488d:	89 fb                	mov    %edi,%ebx
8010488f:	c1 e9 02             	shr    $0x2,%ecx
80104892:	c1 e3 10             	shl    $0x10,%ebx
80104895:	09 d8                	or     %ebx,%eax
80104897:	09 f8                	or     %edi,%eax
80104899:	c1 e7 08             	shl    $0x8,%edi
8010489c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010489e:	89 d7                	mov    %edx,%edi
801048a0:	fc                   	cld    
801048a1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801048a3:	5b                   	pop    %ebx
801048a4:	89 d0                	mov    %edx,%eax
801048a6:	5f                   	pop    %edi
801048a7:	5d                   	pop    %ebp
801048a8:	c3                   	ret    
801048a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801048b0:	89 d7                	mov    %edx,%edi
801048b2:	fc                   	cld    
801048b3:	f3 aa                	rep stos %al,%es:(%edi)
801048b5:	5b                   	pop    %ebx
801048b6:	89 d0                	mov    %edx,%eax
801048b8:	5f                   	pop    %edi
801048b9:	5d                   	pop    %ebp
801048ba:	c3                   	ret    
801048bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048bf:	90                   	nop

801048c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	56                   	push   %esi
801048c4:	8b 75 10             	mov    0x10(%ebp),%esi
801048c7:	8b 55 08             	mov    0x8(%ebp),%edx
801048ca:	53                   	push   %ebx
801048cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801048ce:	85 f6                	test   %esi,%esi
801048d0:	74 2e                	je     80104900 <memcmp+0x40>
801048d2:	01 c6                	add    %eax,%esi
801048d4:	eb 14                	jmp    801048ea <memcmp+0x2a>
801048d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048dd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801048e0:	83 c0 01             	add    $0x1,%eax
801048e3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801048e6:	39 f0                	cmp    %esi,%eax
801048e8:	74 16                	je     80104900 <memcmp+0x40>
    if(*s1 != *s2)
801048ea:	0f b6 0a             	movzbl (%edx),%ecx
801048ed:	0f b6 18             	movzbl (%eax),%ebx
801048f0:	38 d9                	cmp    %bl,%cl
801048f2:	74 ec                	je     801048e0 <memcmp+0x20>
      return *s1 - *s2;
801048f4:	0f b6 c1             	movzbl %cl,%eax
801048f7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801048f9:	5b                   	pop    %ebx
801048fa:	5e                   	pop    %esi
801048fb:	5d                   	pop    %ebp
801048fc:	c3                   	ret    
801048fd:	8d 76 00             	lea    0x0(%esi),%esi
80104900:	5b                   	pop    %ebx
  return 0;
80104901:	31 c0                	xor    %eax,%eax
}
80104903:	5e                   	pop    %esi
80104904:	5d                   	pop    %ebp
80104905:	c3                   	ret    
80104906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010490d:	8d 76 00             	lea    0x0(%esi),%esi

80104910 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	57                   	push   %edi
80104914:	8b 55 08             	mov    0x8(%ebp),%edx
80104917:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010491a:	56                   	push   %esi
8010491b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010491e:	39 d6                	cmp    %edx,%esi
80104920:	73 26                	jae    80104948 <memmove+0x38>
80104922:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104925:	39 fa                	cmp    %edi,%edx
80104927:	73 1f                	jae    80104948 <memmove+0x38>
80104929:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010492c:	85 c9                	test   %ecx,%ecx
8010492e:	74 0c                	je     8010493c <memmove+0x2c>
      *--d = *--s;
80104930:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104934:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104937:	83 e8 01             	sub    $0x1,%eax
8010493a:	73 f4                	jae    80104930 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010493c:	5e                   	pop    %esi
8010493d:	89 d0                	mov    %edx,%eax
8010493f:	5f                   	pop    %edi
80104940:	5d                   	pop    %ebp
80104941:	c3                   	ret    
80104942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104948:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010494b:	89 d7                	mov    %edx,%edi
8010494d:	85 c9                	test   %ecx,%ecx
8010494f:	74 eb                	je     8010493c <memmove+0x2c>
80104951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104958:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104959:	39 c6                	cmp    %eax,%esi
8010495b:	75 fb                	jne    80104958 <memmove+0x48>
}
8010495d:	5e                   	pop    %esi
8010495e:	89 d0                	mov    %edx,%eax
80104960:	5f                   	pop    %edi
80104961:	5d                   	pop    %ebp
80104962:	c3                   	ret    
80104963:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104970 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104970:	eb 9e                	jmp    80104910 <memmove>
80104972:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104980 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	8b 75 10             	mov    0x10(%ebp),%esi
80104987:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010498a:	53                   	push   %ebx
8010498b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010498e:	85 f6                	test   %esi,%esi
80104990:	74 2e                	je     801049c0 <strncmp+0x40>
80104992:	01 d6                	add    %edx,%esi
80104994:	eb 18                	jmp    801049ae <strncmp+0x2e>
80104996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010499d:	8d 76 00             	lea    0x0(%esi),%esi
801049a0:	38 d8                	cmp    %bl,%al
801049a2:	75 14                	jne    801049b8 <strncmp+0x38>
    n--, p++, q++;
801049a4:	83 c2 01             	add    $0x1,%edx
801049a7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801049aa:	39 f2                	cmp    %esi,%edx
801049ac:	74 12                	je     801049c0 <strncmp+0x40>
801049ae:	0f b6 01             	movzbl (%ecx),%eax
801049b1:	0f b6 1a             	movzbl (%edx),%ebx
801049b4:	84 c0                	test   %al,%al
801049b6:	75 e8                	jne    801049a0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801049b8:	29 d8                	sub    %ebx,%eax
}
801049ba:	5b                   	pop    %ebx
801049bb:	5e                   	pop    %esi
801049bc:	5d                   	pop    %ebp
801049bd:	c3                   	ret    
801049be:	66 90                	xchg   %ax,%ax
801049c0:	5b                   	pop    %ebx
    return 0;
801049c1:	31 c0                	xor    %eax,%eax
}
801049c3:	5e                   	pop    %esi
801049c4:	5d                   	pop    %ebp
801049c5:	c3                   	ret    
801049c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049cd:	8d 76 00             	lea    0x0(%esi),%esi

801049d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	57                   	push   %edi
801049d4:	56                   	push   %esi
801049d5:	8b 75 08             	mov    0x8(%ebp),%esi
801049d8:	53                   	push   %ebx
801049d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801049dc:	89 f0                	mov    %esi,%eax
801049de:	eb 15                	jmp    801049f5 <strncpy+0x25>
801049e0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801049e4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801049e7:	83 c0 01             	add    $0x1,%eax
801049ea:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
801049ee:	88 50 ff             	mov    %dl,-0x1(%eax)
801049f1:	84 d2                	test   %dl,%dl
801049f3:	74 09                	je     801049fe <strncpy+0x2e>
801049f5:	89 cb                	mov    %ecx,%ebx
801049f7:	83 e9 01             	sub    $0x1,%ecx
801049fa:	85 db                	test   %ebx,%ebx
801049fc:	7f e2                	jg     801049e0 <strncpy+0x10>
    ;
  while(n-- > 0)
801049fe:	89 c2                	mov    %eax,%edx
80104a00:	85 c9                	test   %ecx,%ecx
80104a02:	7e 17                	jle    80104a1b <strncpy+0x4b>
80104a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104a08:	83 c2 01             	add    $0x1,%edx
80104a0b:	89 c1                	mov    %eax,%ecx
80104a0d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104a11:	29 d1                	sub    %edx,%ecx
80104a13:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104a17:	85 c9                	test   %ecx,%ecx
80104a19:	7f ed                	jg     80104a08 <strncpy+0x38>
  return os;
}
80104a1b:	5b                   	pop    %ebx
80104a1c:	89 f0                	mov    %esi,%eax
80104a1e:	5e                   	pop    %esi
80104a1f:	5f                   	pop    %edi
80104a20:	5d                   	pop    %ebp
80104a21:	c3                   	ret    
80104a22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a30 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	56                   	push   %esi
80104a34:	8b 55 10             	mov    0x10(%ebp),%edx
80104a37:	8b 75 08             	mov    0x8(%ebp),%esi
80104a3a:	53                   	push   %ebx
80104a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104a3e:	85 d2                	test   %edx,%edx
80104a40:	7e 25                	jle    80104a67 <safestrcpy+0x37>
80104a42:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a46:	89 f2                	mov    %esi,%edx
80104a48:	eb 16                	jmp    80104a60 <safestrcpy+0x30>
80104a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a50:	0f b6 08             	movzbl (%eax),%ecx
80104a53:	83 c0 01             	add    $0x1,%eax
80104a56:	83 c2 01             	add    $0x1,%edx
80104a59:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a5c:	84 c9                	test   %cl,%cl
80104a5e:	74 04                	je     80104a64 <safestrcpy+0x34>
80104a60:	39 d8                	cmp    %ebx,%eax
80104a62:	75 ec                	jne    80104a50 <safestrcpy+0x20>
    ;
  *s = 0;
80104a64:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a67:	89 f0                	mov    %esi,%eax
80104a69:	5b                   	pop    %ebx
80104a6a:	5e                   	pop    %esi
80104a6b:	5d                   	pop    %ebp
80104a6c:	c3                   	ret    
80104a6d:	8d 76 00             	lea    0x0(%esi),%esi

80104a70 <strlen>:

int
strlen(const char *s)
{
80104a70:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a71:	31 c0                	xor    %eax,%eax
{
80104a73:	89 e5                	mov    %esp,%ebp
80104a75:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a78:	80 3a 00             	cmpb   $0x0,(%edx)
80104a7b:	74 0c                	je     80104a89 <strlen+0x19>
80104a7d:	8d 76 00             	lea    0x0(%esi),%esi
80104a80:	83 c0 01             	add    $0x1,%eax
80104a83:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a87:	75 f7                	jne    80104a80 <strlen+0x10>
    ;
  return n;
}
80104a89:	5d                   	pop    %ebp
80104a8a:	c3                   	ret    

80104a8b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a8b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a8f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a93:	55                   	push   %ebp
  pushl %ebx
80104a94:	53                   	push   %ebx
  pushl %esi
80104a95:	56                   	push   %esi
  pushl %edi
80104a96:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a97:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a99:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a9b:	5f                   	pop    %edi
  popl %esi
80104a9c:	5e                   	pop    %esi
  popl %ebx
80104a9d:	5b                   	pop    %ebx
  popl %ebp
80104a9e:	5d                   	pop    %ebp
  ret
80104a9f:	c3                   	ret    

80104aa0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	53                   	push   %ebx
80104aa4:	83 ec 04             	sub    $0x4,%esp
80104aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104aaa:	e8 d1 f0 ff ff       	call   80103b80 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104aaf:	8b 00                	mov    (%eax),%eax
80104ab1:	39 d8                	cmp    %ebx,%eax
80104ab3:	76 1b                	jbe    80104ad0 <fetchint+0x30>
80104ab5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ab8:	39 d0                	cmp    %edx,%eax
80104aba:	72 14                	jb     80104ad0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104abc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104abf:	8b 13                	mov    (%ebx),%edx
80104ac1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ac3:	31 c0                	xor    %eax,%eax
}
80104ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ac8:	c9                   	leave  
80104ac9:	c3                   	ret    
80104aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ad5:	eb ee                	jmp    80104ac5 <fetchint+0x25>
80104ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ade:	66 90                	xchg   %ax,%ax

80104ae0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	53                   	push   %ebx
80104ae4:	83 ec 04             	sub    $0x4,%esp
80104ae7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104aea:	e8 91 f0 ff ff       	call   80103b80 <myproc>

  if(addr >= curproc->sz)
80104aef:	39 18                	cmp    %ebx,(%eax)
80104af1:	76 2d                	jbe    80104b20 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104af3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104af6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104af8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104afa:	39 d3                	cmp    %edx,%ebx
80104afc:	73 22                	jae    80104b20 <fetchstr+0x40>
80104afe:	89 d8                	mov    %ebx,%eax
80104b00:	eb 0d                	jmp    80104b0f <fetchstr+0x2f>
80104b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b08:	83 c0 01             	add    $0x1,%eax
80104b0b:	39 c2                	cmp    %eax,%edx
80104b0d:	76 11                	jbe    80104b20 <fetchstr+0x40>
    if(*s == 0)
80104b0f:	80 38 00             	cmpb   $0x0,(%eax)
80104b12:	75 f4                	jne    80104b08 <fetchstr+0x28>
      return s - *pp;
80104b14:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104b16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b19:	c9                   	leave  
80104b1a:	c3                   	ret    
80104b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b1f:	90                   	nop
80104b20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104b23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b28:	c9                   	leave  
80104b29:	c3                   	ret    
80104b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b30 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	56                   	push   %esi
80104b34:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b35:	e8 46 f0 ff ff       	call   80103b80 <myproc>
80104b3a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b3d:	8b 40 18             	mov    0x18(%eax),%eax
80104b40:	8b 40 44             	mov    0x44(%eax),%eax
80104b43:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b46:	e8 35 f0 ff ff       	call   80103b80 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b4b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b4e:	8b 00                	mov    (%eax),%eax
80104b50:	39 c6                	cmp    %eax,%esi
80104b52:	73 1c                	jae    80104b70 <argint+0x40>
80104b54:	8d 53 08             	lea    0x8(%ebx),%edx
80104b57:	39 d0                	cmp    %edx,%eax
80104b59:	72 15                	jb     80104b70 <argint+0x40>
  *ip = *(int*)(addr);
80104b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b5e:	8b 53 04             	mov    0x4(%ebx),%edx
80104b61:	89 10                	mov    %edx,(%eax)
  return 0;
80104b63:	31 c0                	xor    %eax,%eax
}
80104b65:	5b                   	pop    %ebx
80104b66:	5e                   	pop    %esi
80104b67:	5d                   	pop    %ebp
80104b68:	c3                   	ret    
80104b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b75:	eb ee                	jmp    80104b65 <argint+0x35>
80104b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7e:	66 90                	xchg   %ax,%ax

80104b80 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	57                   	push   %edi
80104b84:	56                   	push   %esi
80104b85:	53                   	push   %ebx
80104b86:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104b89:	e8 f2 ef ff ff       	call   80103b80 <myproc>
80104b8e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b90:	e8 eb ef ff ff       	call   80103b80 <myproc>
80104b95:	8b 55 08             	mov    0x8(%ebp),%edx
80104b98:	8b 40 18             	mov    0x18(%eax),%eax
80104b9b:	8b 40 44             	mov    0x44(%eax),%eax
80104b9e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ba1:	e8 da ef ff ff       	call   80103b80 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ba6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ba9:	8b 00                	mov    (%eax),%eax
80104bab:	39 c7                	cmp    %eax,%edi
80104bad:	73 31                	jae    80104be0 <argptr+0x60>
80104baf:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104bb2:	39 c8                	cmp    %ecx,%eax
80104bb4:	72 2a                	jb     80104be0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bb6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104bb9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bbc:	85 d2                	test   %edx,%edx
80104bbe:	78 20                	js     80104be0 <argptr+0x60>
80104bc0:	8b 16                	mov    (%esi),%edx
80104bc2:	39 c2                	cmp    %eax,%edx
80104bc4:	76 1a                	jbe    80104be0 <argptr+0x60>
80104bc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104bc9:	01 c3                	add    %eax,%ebx
80104bcb:	39 da                	cmp    %ebx,%edx
80104bcd:	72 11                	jb     80104be0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bd2:	89 02                	mov    %eax,(%edx)
  return 0;
80104bd4:	31 c0                	xor    %eax,%eax
}
80104bd6:	83 c4 0c             	add    $0xc,%esp
80104bd9:	5b                   	pop    %ebx
80104bda:	5e                   	pop    %esi
80104bdb:	5f                   	pop    %edi
80104bdc:	5d                   	pop    %ebp
80104bdd:	c3                   	ret    
80104bde:	66 90                	xchg   %ax,%ax
    return -1;
80104be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104be5:	eb ef                	jmp    80104bd6 <argptr+0x56>
80104be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bee:	66 90                	xchg   %ax,%ax

80104bf0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	56                   	push   %esi
80104bf4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bf5:	e8 86 ef ff ff       	call   80103b80 <myproc>
80104bfa:	8b 55 08             	mov    0x8(%ebp),%edx
80104bfd:	8b 40 18             	mov    0x18(%eax),%eax
80104c00:	8b 40 44             	mov    0x44(%eax),%eax
80104c03:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c06:	e8 75 ef ff ff       	call   80103b80 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c0b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c0e:	8b 00                	mov    (%eax),%eax
80104c10:	39 c6                	cmp    %eax,%esi
80104c12:	73 44                	jae    80104c58 <argstr+0x68>
80104c14:	8d 53 08             	lea    0x8(%ebx),%edx
80104c17:	39 d0                	cmp    %edx,%eax
80104c19:	72 3d                	jb     80104c58 <argstr+0x68>
  *ip = *(int*)(addr);
80104c1b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104c1e:	e8 5d ef ff ff       	call   80103b80 <myproc>
  if(addr >= curproc->sz)
80104c23:	3b 18                	cmp    (%eax),%ebx
80104c25:	73 31                	jae    80104c58 <argstr+0x68>
  *pp = (char*)addr;
80104c27:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c2a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c2c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c2e:	39 d3                	cmp    %edx,%ebx
80104c30:	73 26                	jae    80104c58 <argstr+0x68>
80104c32:	89 d8                	mov    %ebx,%eax
80104c34:	eb 11                	jmp    80104c47 <argstr+0x57>
80104c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3d:	8d 76 00             	lea    0x0(%esi),%esi
80104c40:	83 c0 01             	add    $0x1,%eax
80104c43:	39 c2                	cmp    %eax,%edx
80104c45:	76 11                	jbe    80104c58 <argstr+0x68>
    if(*s == 0)
80104c47:	80 38 00             	cmpb   $0x0,(%eax)
80104c4a:	75 f4                	jne    80104c40 <argstr+0x50>
      return s - *pp;
80104c4c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c4e:	5b                   	pop    %ebx
80104c4f:	5e                   	pop    %esi
80104c50:	5d                   	pop    %ebp
80104c51:	c3                   	ret    
80104c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c58:	5b                   	pop    %ebx
    return -1;
80104c59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c5e:	5e                   	pop    %esi
80104c5f:	5d                   	pop    %ebp
80104c60:	c3                   	ret    
80104c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6f:	90                   	nop

80104c70 <syscall>:
[SYS_countptp] sys_countptp,
};

void
syscall(void)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	53                   	push   %ebx
80104c74:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c77:	e8 04 ef ff ff       	call   80103b80 <myproc>
80104c7c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c7e:	8b 40 18             	mov    0x18(%eax),%eax
80104c81:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c84:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c87:	83 fa 18             	cmp    $0x18,%edx
80104c8a:	77 24                	ja     80104cb0 <syscall+0x40>
80104c8c:	8b 14 85 20 7d 10 80 	mov    -0x7fef82e0(,%eax,4),%edx
80104c93:	85 d2                	test   %edx,%edx
80104c95:	74 19                	je     80104cb0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104c97:	ff d2                	call   *%edx
80104c99:	89 c2                	mov    %eax,%edx
80104c9b:	8b 43 18             	mov    0x18(%ebx),%eax
80104c9e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104ca1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ca4:	c9                   	leave  
80104ca5:	c3                   	ret    
80104ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cad:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104cb0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104cb1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104cb4:	50                   	push   %eax
80104cb5:	ff 73 10             	push   0x10(%ebx)
80104cb8:	68 fd 7c 10 80       	push   $0x80107cfd
80104cbd:	e8 de b9 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104cc2:	8b 43 18             	mov    0x18(%ebx),%eax
80104cc5:	83 c4 10             	add    $0x10,%esp
80104cc8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104ccf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cd2:	c9                   	leave  
80104cd3:	c3                   	ret    
80104cd4:	66 90                	xchg   %ax,%ax
80104cd6:	66 90                	xchg   %ax,%ax
80104cd8:	66 90                	xchg   %ax,%ax
80104cda:	66 90                	xchg   %ax,%ax
80104cdc:	66 90                	xchg   %ax,%ax
80104cde:	66 90                	xchg   %ax,%ax

80104ce0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	57                   	push   %edi
80104ce4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ce5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104ce8:	53                   	push   %ebx
80104ce9:	83 ec 34             	sub    $0x34,%esp
80104cec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104cef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104cf2:	57                   	push   %edi
80104cf3:	50                   	push   %eax
{
80104cf4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104cf7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104cfa:	e8 c1 d3 ff ff       	call   801020c0 <nameiparent>
80104cff:	83 c4 10             	add    $0x10,%esp
80104d02:	85 c0                	test   %eax,%eax
80104d04:	0f 84 46 01 00 00    	je     80104e50 <create+0x170>
    return 0;
  ilock(dp);
80104d0a:	83 ec 0c             	sub    $0xc,%esp
80104d0d:	89 c3                	mov    %eax,%ebx
80104d0f:	50                   	push   %eax
80104d10:	e8 6b ca ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104d15:	83 c4 0c             	add    $0xc,%esp
80104d18:	6a 00                	push   $0x0
80104d1a:	57                   	push   %edi
80104d1b:	53                   	push   %ebx
80104d1c:	e8 bf cf ff ff       	call   80101ce0 <dirlookup>
80104d21:	83 c4 10             	add    $0x10,%esp
80104d24:	89 c6                	mov    %eax,%esi
80104d26:	85 c0                	test   %eax,%eax
80104d28:	74 56                	je     80104d80 <create+0xa0>
    iunlockput(dp);
80104d2a:	83 ec 0c             	sub    $0xc,%esp
80104d2d:	53                   	push   %ebx
80104d2e:	e8 dd cc ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104d33:	89 34 24             	mov    %esi,(%esp)
80104d36:	e8 45 ca ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d3b:	83 c4 10             	add    $0x10,%esp
80104d3e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104d43:	75 1b                	jne    80104d60 <create+0x80>
80104d45:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104d4a:	75 14                	jne    80104d60 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d4f:	89 f0                	mov    %esi,%eax
80104d51:	5b                   	pop    %ebx
80104d52:	5e                   	pop    %esi
80104d53:	5f                   	pop    %edi
80104d54:	5d                   	pop    %ebp
80104d55:	c3                   	ret    
80104d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104d60:	83 ec 0c             	sub    $0xc,%esp
80104d63:	56                   	push   %esi
    return 0;
80104d64:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104d66:	e8 a5 cc ff ff       	call   80101a10 <iunlockput>
    return 0;
80104d6b:	83 c4 10             	add    $0x10,%esp
}
80104d6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d71:	89 f0                	mov    %esi,%eax
80104d73:	5b                   	pop    %ebx
80104d74:	5e                   	pop    %esi
80104d75:	5f                   	pop    %edi
80104d76:	5d                   	pop    %ebp
80104d77:	c3                   	ret    
80104d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d7f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104d80:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d84:	83 ec 08             	sub    $0x8,%esp
80104d87:	50                   	push   %eax
80104d88:	ff 33                	push   (%ebx)
80104d8a:	e8 81 c8 ff ff       	call   80101610 <ialloc>
80104d8f:	83 c4 10             	add    $0x10,%esp
80104d92:	89 c6                	mov    %eax,%esi
80104d94:	85 c0                	test   %eax,%eax
80104d96:	0f 84 cd 00 00 00    	je     80104e69 <create+0x189>
  ilock(ip);
80104d9c:	83 ec 0c             	sub    $0xc,%esp
80104d9f:	50                   	push   %eax
80104da0:	e8 db c9 ff ff       	call   80101780 <ilock>
  ip->major = major;
80104da5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104da9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104dad:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104db1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104db5:	b8 01 00 00 00       	mov    $0x1,%eax
80104dba:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104dbe:	89 34 24             	mov    %esi,(%esp)
80104dc1:	e8 0a c9 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104dc6:	83 c4 10             	add    $0x10,%esp
80104dc9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104dce:	74 30                	je     80104e00 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104dd0:	83 ec 04             	sub    $0x4,%esp
80104dd3:	ff 76 04             	push   0x4(%esi)
80104dd6:	57                   	push   %edi
80104dd7:	53                   	push   %ebx
80104dd8:	e8 03 d2 ff ff       	call   80101fe0 <dirlink>
80104ddd:	83 c4 10             	add    $0x10,%esp
80104de0:	85 c0                	test   %eax,%eax
80104de2:	78 78                	js     80104e5c <create+0x17c>
  iunlockput(dp);
80104de4:	83 ec 0c             	sub    $0xc,%esp
80104de7:	53                   	push   %ebx
80104de8:	e8 23 cc ff ff       	call   80101a10 <iunlockput>
  return ip;
80104ded:	83 c4 10             	add    $0x10,%esp
}
80104df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104df3:	89 f0                	mov    %esi,%eax
80104df5:	5b                   	pop    %ebx
80104df6:	5e                   	pop    %esi
80104df7:	5f                   	pop    %edi
80104df8:	5d                   	pop    %ebp
80104df9:	c3                   	ret    
80104dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104e00:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104e03:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104e08:	53                   	push   %ebx
80104e09:	e8 c2 c8 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104e0e:	83 c4 0c             	add    $0xc,%esp
80104e11:	ff 76 04             	push   0x4(%esi)
80104e14:	68 a4 7d 10 80       	push   $0x80107da4
80104e19:	56                   	push   %esi
80104e1a:	e8 c1 d1 ff ff       	call   80101fe0 <dirlink>
80104e1f:	83 c4 10             	add    $0x10,%esp
80104e22:	85 c0                	test   %eax,%eax
80104e24:	78 18                	js     80104e3e <create+0x15e>
80104e26:	83 ec 04             	sub    $0x4,%esp
80104e29:	ff 73 04             	push   0x4(%ebx)
80104e2c:	68 a3 7d 10 80       	push   $0x80107da3
80104e31:	56                   	push   %esi
80104e32:	e8 a9 d1 ff ff       	call   80101fe0 <dirlink>
80104e37:	83 c4 10             	add    $0x10,%esp
80104e3a:	85 c0                	test   %eax,%eax
80104e3c:	79 92                	jns    80104dd0 <create+0xf0>
      panic("create dots");
80104e3e:	83 ec 0c             	sub    $0xc,%esp
80104e41:	68 97 7d 10 80       	push   $0x80107d97
80104e46:	e8 35 b5 ff ff       	call   80100380 <panic>
80104e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e4f:	90                   	nop
}
80104e50:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104e53:	31 f6                	xor    %esi,%esi
}
80104e55:	5b                   	pop    %ebx
80104e56:	89 f0                	mov    %esi,%eax
80104e58:	5e                   	pop    %esi
80104e59:	5f                   	pop    %edi
80104e5a:	5d                   	pop    %ebp
80104e5b:	c3                   	ret    
    panic("create: dirlink");
80104e5c:	83 ec 0c             	sub    $0xc,%esp
80104e5f:	68 a6 7d 10 80       	push   $0x80107da6
80104e64:	e8 17 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104e69:	83 ec 0c             	sub    $0xc,%esp
80104e6c:	68 88 7d 10 80       	push   $0x80107d88
80104e71:	e8 0a b5 ff ff       	call   80100380 <panic>
80104e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e7d:	8d 76 00             	lea    0x0(%esi),%esi

80104e80 <sys_dup>:
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	56                   	push   %esi
80104e84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e85:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e8b:	50                   	push   %eax
80104e8c:	6a 00                	push   $0x0
80104e8e:	e8 9d fc ff ff       	call   80104b30 <argint>
80104e93:	83 c4 10             	add    $0x10,%esp
80104e96:	85 c0                	test   %eax,%eax
80104e98:	78 36                	js     80104ed0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e9a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e9e:	77 30                	ja     80104ed0 <sys_dup+0x50>
80104ea0:	e8 db ec ff ff       	call   80103b80 <myproc>
80104ea5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ea8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104eac:	85 f6                	test   %esi,%esi
80104eae:	74 20                	je     80104ed0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104eb0:	e8 cb ec ff ff       	call   80103b80 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104eb5:	31 db                	xor    %ebx,%ebx
80104eb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ebe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104ec0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104ec4:	85 d2                	test   %edx,%edx
80104ec6:	74 18                	je     80104ee0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104ec8:	83 c3 01             	add    $0x1,%ebx
80104ecb:	83 fb 10             	cmp    $0x10,%ebx
80104ece:	75 f0                	jne    80104ec0 <sys_dup+0x40>
}
80104ed0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104ed3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104ed8:	89 d8                	mov    %ebx,%eax
80104eda:	5b                   	pop    %ebx
80104edb:	5e                   	pop    %esi
80104edc:	5d                   	pop    %ebp
80104edd:	c3                   	ret    
80104ede:	66 90                	xchg   %ax,%ax
  filedup(f);
80104ee0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104ee3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104ee7:	56                   	push   %esi
80104ee8:	e8 b3 bf ff ff       	call   80100ea0 <filedup>
  return fd;
80104eed:	83 c4 10             	add    $0x10,%esp
}
80104ef0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ef3:	89 d8                	mov    %ebx,%eax
80104ef5:	5b                   	pop    %ebx
80104ef6:	5e                   	pop    %esi
80104ef7:	5d                   	pop    %ebp
80104ef8:	c3                   	ret    
80104ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f00 <sys_read>:
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	56                   	push   %esi
80104f04:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f05:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f08:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f0b:	53                   	push   %ebx
80104f0c:	6a 00                	push   $0x0
80104f0e:	e8 1d fc ff ff       	call   80104b30 <argint>
80104f13:	83 c4 10             	add    $0x10,%esp
80104f16:	85 c0                	test   %eax,%eax
80104f18:	78 5e                	js     80104f78 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f1a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f1e:	77 58                	ja     80104f78 <sys_read+0x78>
80104f20:	e8 5b ec ff ff       	call   80103b80 <myproc>
80104f25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f28:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f2c:	85 f6                	test   %esi,%esi
80104f2e:	74 48                	je     80104f78 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f30:	83 ec 08             	sub    $0x8,%esp
80104f33:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f36:	50                   	push   %eax
80104f37:	6a 02                	push   $0x2
80104f39:	e8 f2 fb ff ff       	call   80104b30 <argint>
80104f3e:	83 c4 10             	add    $0x10,%esp
80104f41:	85 c0                	test   %eax,%eax
80104f43:	78 33                	js     80104f78 <sys_read+0x78>
80104f45:	83 ec 04             	sub    $0x4,%esp
80104f48:	ff 75 f0             	push   -0x10(%ebp)
80104f4b:	53                   	push   %ebx
80104f4c:	6a 01                	push   $0x1
80104f4e:	e8 2d fc ff ff       	call   80104b80 <argptr>
80104f53:	83 c4 10             	add    $0x10,%esp
80104f56:	85 c0                	test   %eax,%eax
80104f58:	78 1e                	js     80104f78 <sys_read+0x78>
  return fileread(f, p, n);
80104f5a:	83 ec 04             	sub    $0x4,%esp
80104f5d:	ff 75 f0             	push   -0x10(%ebp)
80104f60:	ff 75 f4             	push   -0xc(%ebp)
80104f63:	56                   	push   %esi
80104f64:	e8 b7 c0 ff ff       	call   80101020 <fileread>
80104f69:	83 c4 10             	add    $0x10,%esp
}
80104f6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f6f:	5b                   	pop    %ebx
80104f70:	5e                   	pop    %esi
80104f71:	5d                   	pop    %ebp
80104f72:	c3                   	ret    
80104f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f77:	90                   	nop
    return -1;
80104f78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f7d:	eb ed                	jmp    80104f6c <sys_read+0x6c>
80104f7f:	90                   	nop

80104f80 <sys_write>:
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	56                   	push   %esi
80104f84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f85:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f8b:	53                   	push   %ebx
80104f8c:	6a 00                	push   $0x0
80104f8e:	e8 9d fb ff ff       	call   80104b30 <argint>
80104f93:	83 c4 10             	add    $0x10,%esp
80104f96:	85 c0                	test   %eax,%eax
80104f98:	78 5e                	js     80104ff8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f9a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f9e:	77 58                	ja     80104ff8 <sys_write+0x78>
80104fa0:	e8 db eb ff ff       	call   80103b80 <myproc>
80104fa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fa8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fac:	85 f6                	test   %esi,%esi
80104fae:	74 48                	je     80104ff8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fb0:	83 ec 08             	sub    $0x8,%esp
80104fb3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fb6:	50                   	push   %eax
80104fb7:	6a 02                	push   $0x2
80104fb9:	e8 72 fb ff ff       	call   80104b30 <argint>
80104fbe:	83 c4 10             	add    $0x10,%esp
80104fc1:	85 c0                	test   %eax,%eax
80104fc3:	78 33                	js     80104ff8 <sys_write+0x78>
80104fc5:	83 ec 04             	sub    $0x4,%esp
80104fc8:	ff 75 f0             	push   -0x10(%ebp)
80104fcb:	53                   	push   %ebx
80104fcc:	6a 01                	push   $0x1
80104fce:	e8 ad fb ff ff       	call   80104b80 <argptr>
80104fd3:	83 c4 10             	add    $0x10,%esp
80104fd6:	85 c0                	test   %eax,%eax
80104fd8:	78 1e                	js     80104ff8 <sys_write+0x78>
  return filewrite(f, p, n);
80104fda:	83 ec 04             	sub    $0x4,%esp
80104fdd:	ff 75 f0             	push   -0x10(%ebp)
80104fe0:	ff 75 f4             	push   -0xc(%ebp)
80104fe3:	56                   	push   %esi
80104fe4:	e8 c7 c0 ff ff       	call   801010b0 <filewrite>
80104fe9:	83 c4 10             	add    $0x10,%esp
}
80104fec:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fef:	5b                   	pop    %ebx
80104ff0:	5e                   	pop    %esi
80104ff1:	5d                   	pop    %ebp
80104ff2:	c3                   	ret    
80104ff3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ff7:	90                   	nop
    return -1;
80104ff8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ffd:	eb ed                	jmp    80104fec <sys_write+0x6c>
80104fff:	90                   	nop

80105000 <sys_close>:
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	56                   	push   %esi
80105004:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105005:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105008:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010500b:	50                   	push   %eax
8010500c:	6a 00                	push   $0x0
8010500e:	e8 1d fb ff ff       	call   80104b30 <argint>
80105013:	83 c4 10             	add    $0x10,%esp
80105016:	85 c0                	test   %eax,%eax
80105018:	78 3e                	js     80105058 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010501a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010501e:	77 38                	ja     80105058 <sys_close+0x58>
80105020:	e8 5b eb ff ff       	call   80103b80 <myproc>
80105025:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105028:	8d 5a 08             	lea    0x8(%edx),%ebx
8010502b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010502f:	85 f6                	test   %esi,%esi
80105031:	74 25                	je     80105058 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105033:	e8 48 eb ff ff       	call   80103b80 <myproc>
  fileclose(f);
80105038:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010503b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105042:	00 
  fileclose(f);
80105043:	56                   	push   %esi
80105044:	e8 a7 be ff ff       	call   80100ef0 <fileclose>
  return 0;
80105049:	83 c4 10             	add    $0x10,%esp
8010504c:	31 c0                	xor    %eax,%eax
}
8010504e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105051:	5b                   	pop    %ebx
80105052:	5e                   	pop    %esi
80105053:	5d                   	pop    %ebp
80105054:	c3                   	ret    
80105055:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105058:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010505d:	eb ef                	jmp    8010504e <sys_close+0x4e>
8010505f:	90                   	nop

80105060 <sys_fstat>:
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	56                   	push   %esi
80105064:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105065:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105068:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010506b:	53                   	push   %ebx
8010506c:	6a 00                	push   $0x0
8010506e:	e8 bd fa ff ff       	call   80104b30 <argint>
80105073:	83 c4 10             	add    $0x10,%esp
80105076:	85 c0                	test   %eax,%eax
80105078:	78 46                	js     801050c0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010507a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010507e:	77 40                	ja     801050c0 <sys_fstat+0x60>
80105080:	e8 fb ea ff ff       	call   80103b80 <myproc>
80105085:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105088:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010508c:	85 f6                	test   %esi,%esi
8010508e:	74 30                	je     801050c0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105090:	83 ec 04             	sub    $0x4,%esp
80105093:	6a 14                	push   $0x14
80105095:	53                   	push   %ebx
80105096:	6a 01                	push   $0x1
80105098:	e8 e3 fa ff ff       	call   80104b80 <argptr>
8010509d:	83 c4 10             	add    $0x10,%esp
801050a0:	85 c0                	test   %eax,%eax
801050a2:	78 1c                	js     801050c0 <sys_fstat+0x60>
  return filestat(f, st);
801050a4:	83 ec 08             	sub    $0x8,%esp
801050a7:	ff 75 f4             	push   -0xc(%ebp)
801050aa:	56                   	push   %esi
801050ab:	e8 20 bf ff ff       	call   80100fd0 <filestat>
801050b0:	83 c4 10             	add    $0x10,%esp
}
801050b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050b6:	5b                   	pop    %ebx
801050b7:	5e                   	pop    %esi
801050b8:	5d                   	pop    %ebp
801050b9:	c3                   	ret    
801050ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801050c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050c5:	eb ec                	jmp    801050b3 <sys_fstat+0x53>
801050c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ce:	66 90                	xchg   %ax,%ax

801050d0 <sys_link>:
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	57                   	push   %edi
801050d4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050d5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801050d8:	53                   	push   %ebx
801050d9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050dc:	50                   	push   %eax
801050dd:	6a 00                	push   $0x0
801050df:	e8 0c fb ff ff       	call   80104bf0 <argstr>
801050e4:	83 c4 10             	add    $0x10,%esp
801050e7:	85 c0                	test   %eax,%eax
801050e9:	0f 88 fb 00 00 00    	js     801051ea <sys_link+0x11a>
801050ef:	83 ec 08             	sub    $0x8,%esp
801050f2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801050f5:	50                   	push   %eax
801050f6:	6a 01                	push   $0x1
801050f8:	e8 f3 fa ff ff       	call   80104bf0 <argstr>
801050fd:	83 c4 10             	add    $0x10,%esp
80105100:	85 c0                	test   %eax,%eax
80105102:	0f 88 e2 00 00 00    	js     801051ea <sys_link+0x11a>
  begin_op();
80105108:	e8 63 de ff ff       	call   80102f70 <begin_op>
  if((ip = namei(old)) == 0){
8010510d:	83 ec 0c             	sub    $0xc,%esp
80105110:	ff 75 d4             	push   -0x2c(%ebp)
80105113:	e8 88 cf ff ff       	call   801020a0 <namei>
80105118:	83 c4 10             	add    $0x10,%esp
8010511b:	89 c3                	mov    %eax,%ebx
8010511d:	85 c0                	test   %eax,%eax
8010511f:	0f 84 e4 00 00 00    	je     80105209 <sys_link+0x139>
  ilock(ip);
80105125:	83 ec 0c             	sub    $0xc,%esp
80105128:	50                   	push   %eax
80105129:	e8 52 c6 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
8010512e:	83 c4 10             	add    $0x10,%esp
80105131:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105136:	0f 84 b5 00 00 00    	je     801051f1 <sys_link+0x121>
  iupdate(ip);
8010513c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010513f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105144:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105147:	53                   	push   %ebx
80105148:	e8 83 c5 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
8010514d:	89 1c 24             	mov    %ebx,(%esp)
80105150:	e8 0b c7 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105155:	58                   	pop    %eax
80105156:	5a                   	pop    %edx
80105157:	57                   	push   %edi
80105158:	ff 75 d0             	push   -0x30(%ebp)
8010515b:	e8 60 cf ff ff       	call   801020c0 <nameiparent>
80105160:	83 c4 10             	add    $0x10,%esp
80105163:	89 c6                	mov    %eax,%esi
80105165:	85 c0                	test   %eax,%eax
80105167:	74 5b                	je     801051c4 <sys_link+0xf4>
  ilock(dp);
80105169:	83 ec 0c             	sub    $0xc,%esp
8010516c:	50                   	push   %eax
8010516d:	e8 0e c6 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105172:	8b 03                	mov    (%ebx),%eax
80105174:	83 c4 10             	add    $0x10,%esp
80105177:	39 06                	cmp    %eax,(%esi)
80105179:	75 3d                	jne    801051b8 <sys_link+0xe8>
8010517b:	83 ec 04             	sub    $0x4,%esp
8010517e:	ff 73 04             	push   0x4(%ebx)
80105181:	57                   	push   %edi
80105182:	56                   	push   %esi
80105183:	e8 58 ce ff ff       	call   80101fe0 <dirlink>
80105188:	83 c4 10             	add    $0x10,%esp
8010518b:	85 c0                	test   %eax,%eax
8010518d:	78 29                	js     801051b8 <sys_link+0xe8>
  iunlockput(dp);
8010518f:	83 ec 0c             	sub    $0xc,%esp
80105192:	56                   	push   %esi
80105193:	e8 78 c8 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105198:	89 1c 24             	mov    %ebx,(%esp)
8010519b:	e8 10 c7 ff ff       	call   801018b0 <iput>
  end_op();
801051a0:	e8 3b de ff ff       	call   80102fe0 <end_op>
  return 0;
801051a5:	83 c4 10             	add    $0x10,%esp
801051a8:	31 c0                	xor    %eax,%eax
}
801051aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051ad:	5b                   	pop    %ebx
801051ae:	5e                   	pop    %esi
801051af:	5f                   	pop    %edi
801051b0:	5d                   	pop    %ebp
801051b1:	c3                   	ret    
801051b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801051b8:	83 ec 0c             	sub    $0xc,%esp
801051bb:	56                   	push   %esi
801051bc:	e8 4f c8 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801051c1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801051c4:	83 ec 0c             	sub    $0xc,%esp
801051c7:	53                   	push   %ebx
801051c8:	e8 b3 c5 ff ff       	call   80101780 <ilock>
  ip->nlink--;
801051cd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051d2:	89 1c 24             	mov    %ebx,(%esp)
801051d5:	e8 f6 c4 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801051da:	89 1c 24             	mov    %ebx,(%esp)
801051dd:	e8 2e c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
801051e2:	e8 f9 dd ff ff       	call   80102fe0 <end_op>
  return -1;
801051e7:	83 c4 10             	add    $0x10,%esp
801051ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ef:	eb b9                	jmp    801051aa <sys_link+0xda>
    iunlockput(ip);
801051f1:	83 ec 0c             	sub    $0xc,%esp
801051f4:	53                   	push   %ebx
801051f5:	e8 16 c8 ff ff       	call   80101a10 <iunlockput>
    end_op();
801051fa:	e8 e1 dd ff ff       	call   80102fe0 <end_op>
    return -1;
801051ff:	83 c4 10             	add    $0x10,%esp
80105202:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105207:	eb a1                	jmp    801051aa <sys_link+0xda>
    end_op();
80105209:	e8 d2 dd ff ff       	call   80102fe0 <end_op>
    return -1;
8010520e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105213:	eb 95                	jmp    801051aa <sys_link+0xda>
80105215:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010521c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105220 <sys_unlink>:
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	57                   	push   %edi
80105224:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105225:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105228:	53                   	push   %ebx
80105229:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010522c:	50                   	push   %eax
8010522d:	6a 00                	push   $0x0
8010522f:	e8 bc f9 ff ff       	call   80104bf0 <argstr>
80105234:	83 c4 10             	add    $0x10,%esp
80105237:	85 c0                	test   %eax,%eax
80105239:	0f 88 7a 01 00 00    	js     801053b9 <sys_unlink+0x199>
  begin_op();
8010523f:	e8 2c dd ff ff       	call   80102f70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105244:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105247:	83 ec 08             	sub    $0x8,%esp
8010524a:	53                   	push   %ebx
8010524b:	ff 75 c0             	push   -0x40(%ebp)
8010524e:	e8 6d ce ff ff       	call   801020c0 <nameiparent>
80105253:	83 c4 10             	add    $0x10,%esp
80105256:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105259:	85 c0                	test   %eax,%eax
8010525b:	0f 84 62 01 00 00    	je     801053c3 <sys_unlink+0x1a3>
  ilock(dp);
80105261:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105264:	83 ec 0c             	sub    $0xc,%esp
80105267:	57                   	push   %edi
80105268:	e8 13 c5 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010526d:	58                   	pop    %eax
8010526e:	5a                   	pop    %edx
8010526f:	68 a4 7d 10 80       	push   $0x80107da4
80105274:	53                   	push   %ebx
80105275:	e8 46 ca ff ff       	call   80101cc0 <namecmp>
8010527a:	83 c4 10             	add    $0x10,%esp
8010527d:	85 c0                	test   %eax,%eax
8010527f:	0f 84 fb 00 00 00    	je     80105380 <sys_unlink+0x160>
80105285:	83 ec 08             	sub    $0x8,%esp
80105288:	68 a3 7d 10 80       	push   $0x80107da3
8010528d:	53                   	push   %ebx
8010528e:	e8 2d ca ff ff       	call   80101cc0 <namecmp>
80105293:	83 c4 10             	add    $0x10,%esp
80105296:	85 c0                	test   %eax,%eax
80105298:	0f 84 e2 00 00 00    	je     80105380 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010529e:	83 ec 04             	sub    $0x4,%esp
801052a1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801052a4:	50                   	push   %eax
801052a5:	53                   	push   %ebx
801052a6:	57                   	push   %edi
801052a7:	e8 34 ca ff ff       	call   80101ce0 <dirlookup>
801052ac:	83 c4 10             	add    $0x10,%esp
801052af:	89 c3                	mov    %eax,%ebx
801052b1:	85 c0                	test   %eax,%eax
801052b3:	0f 84 c7 00 00 00    	je     80105380 <sys_unlink+0x160>
  ilock(ip);
801052b9:	83 ec 0c             	sub    $0xc,%esp
801052bc:	50                   	push   %eax
801052bd:	e8 be c4 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
801052c2:	83 c4 10             	add    $0x10,%esp
801052c5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801052ca:	0f 8e 1c 01 00 00    	jle    801053ec <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801052d0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052d5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801052d8:	74 66                	je     80105340 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801052da:	83 ec 04             	sub    $0x4,%esp
801052dd:	6a 10                	push   $0x10
801052df:	6a 00                	push   $0x0
801052e1:	57                   	push   %edi
801052e2:	e8 89 f5 ff ff       	call   80104870 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052e7:	6a 10                	push   $0x10
801052e9:	ff 75 c4             	push   -0x3c(%ebp)
801052ec:	57                   	push   %edi
801052ed:	ff 75 b4             	push   -0x4c(%ebp)
801052f0:	e8 9b c8 ff ff       	call   80101b90 <writei>
801052f5:	83 c4 20             	add    $0x20,%esp
801052f8:	83 f8 10             	cmp    $0x10,%eax
801052fb:	0f 85 de 00 00 00    	jne    801053df <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105301:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105306:	0f 84 94 00 00 00    	je     801053a0 <sys_unlink+0x180>
  iunlockput(dp);
8010530c:	83 ec 0c             	sub    $0xc,%esp
8010530f:	ff 75 b4             	push   -0x4c(%ebp)
80105312:	e8 f9 c6 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105317:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010531c:	89 1c 24             	mov    %ebx,(%esp)
8010531f:	e8 ac c3 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105324:	89 1c 24             	mov    %ebx,(%esp)
80105327:	e8 e4 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010532c:	e8 af dc ff ff       	call   80102fe0 <end_op>
  return 0;
80105331:	83 c4 10             	add    $0x10,%esp
80105334:	31 c0                	xor    %eax,%eax
}
80105336:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105339:	5b                   	pop    %ebx
8010533a:	5e                   	pop    %esi
8010533b:	5f                   	pop    %edi
8010533c:	5d                   	pop    %ebp
8010533d:	c3                   	ret    
8010533e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105340:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105344:	76 94                	jbe    801052da <sys_unlink+0xba>
80105346:	be 20 00 00 00       	mov    $0x20,%esi
8010534b:	eb 0b                	jmp    80105358 <sys_unlink+0x138>
8010534d:	8d 76 00             	lea    0x0(%esi),%esi
80105350:	83 c6 10             	add    $0x10,%esi
80105353:	3b 73 58             	cmp    0x58(%ebx),%esi
80105356:	73 82                	jae    801052da <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105358:	6a 10                	push   $0x10
8010535a:	56                   	push   %esi
8010535b:	57                   	push   %edi
8010535c:	53                   	push   %ebx
8010535d:	e8 2e c7 ff ff       	call   80101a90 <readi>
80105362:	83 c4 10             	add    $0x10,%esp
80105365:	83 f8 10             	cmp    $0x10,%eax
80105368:	75 68                	jne    801053d2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010536a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010536f:	74 df                	je     80105350 <sys_unlink+0x130>
    iunlockput(ip);
80105371:	83 ec 0c             	sub    $0xc,%esp
80105374:	53                   	push   %ebx
80105375:	e8 96 c6 ff ff       	call   80101a10 <iunlockput>
    goto bad;
8010537a:	83 c4 10             	add    $0x10,%esp
8010537d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105380:	83 ec 0c             	sub    $0xc,%esp
80105383:	ff 75 b4             	push   -0x4c(%ebp)
80105386:	e8 85 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010538b:	e8 50 dc ff ff       	call   80102fe0 <end_op>
  return -1;
80105390:	83 c4 10             	add    $0x10,%esp
80105393:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105398:	eb 9c                	jmp    80105336 <sys_unlink+0x116>
8010539a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801053a0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801053a3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801053a6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801053ab:	50                   	push   %eax
801053ac:	e8 1f c3 ff ff       	call   801016d0 <iupdate>
801053b1:	83 c4 10             	add    $0x10,%esp
801053b4:	e9 53 ff ff ff       	jmp    8010530c <sys_unlink+0xec>
    return -1;
801053b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053be:	e9 73 ff ff ff       	jmp    80105336 <sys_unlink+0x116>
    end_op();
801053c3:	e8 18 dc ff ff       	call   80102fe0 <end_op>
    return -1;
801053c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053cd:	e9 64 ff ff ff       	jmp    80105336 <sys_unlink+0x116>
      panic("isdirempty: readi");
801053d2:	83 ec 0c             	sub    $0xc,%esp
801053d5:	68 c8 7d 10 80       	push   $0x80107dc8
801053da:	e8 a1 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801053df:	83 ec 0c             	sub    $0xc,%esp
801053e2:	68 da 7d 10 80       	push   $0x80107dda
801053e7:	e8 94 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801053ec:	83 ec 0c             	sub    $0xc,%esp
801053ef:	68 b6 7d 10 80       	push   $0x80107db6
801053f4:	e8 87 af ff ff       	call   80100380 <panic>
801053f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105400 <sys_open>:

int
sys_open(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	57                   	push   %edi
80105404:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105405:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105408:	53                   	push   %ebx
80105409:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010540c:	50                   	push   %eax
8010540d:	6a 00                	push   $0x0
8010540f:	e8 dc f7 ff ff       	call   80104bf0 <argstr>
80105414:	83 c4 10             	add    $0x10,%esp
80105417:	85 c0                	test   %eax,%eax
80105419:	0f 88 8e 00 00 00    	js     801054ad <sys_open+0xad>
8010541f:	83 ec 08             	sub    $0x8,%esp
80105422:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105425:	50                   	push   %eax
80105426:	6a 01                	push   $0x1
80105428:	e8 03 f7 ff ff       	call   80104b30 <argint>
8010542d:	83 c4 10             	add    $0x10,%esp
80105430:	85 c0                	test   %eax,%eax
80105432:	78 79                	js     801054ad <sys_open+0xad>
    return -1;

  begin_op();
80105434:	e8 37 db ff ff       	call   80102f70 <begin_op>

  if(omode & O_CREATE){
80105439:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010543d:	75 79                	jne    801054b8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010543f:	83 ec 0c             	sub    $0xc,%esp
80105442:	ff 75 e0             	push   -0x20(%ebp)
80105445:	e8 56 cc ff ff       	call   801020a0 <namei>
8010544a:	83 c4 10             	add    $0x10,%esp
8010544d:	89 c6                	mov    %eax,%esi
8010544f:	85 c0                	test   %eax,%eax
80105451:	0f 84 7e 00 00 00    	je     801054d5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105457:	83 ec 0c             	sub    $0xc,%esp
8010545a:	50                   	push   %eax
8010545b:	e8 20 c3 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105460:	83 c4 10             	add    $0x10,%esp
80105463:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105468:	0f 84 c2 00 00 00    	je     80105530 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010546e:	e8 bd b9 ff ff       	call   80100e30 <filealloc>
80105473:	89 c7                	mov    %eax,%edi
80105475:	85 c0                	test   %eax,%eax
80105477:	74 23                	je     8010549c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105479:	e8 02 e7 ff ff       	call   80103b80 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010547e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105480:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105484:	85 d2                	test   %edx,%edx
80105486:	74 60                	je     801054e8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105488:	83 c3 01             	add    $0x1,%ebx
8010548b:	83 fb 10             	cmp    $0x10,%ebx
8010548e:	75 f0                	jne    80105480 <sys_open+0x80>
    if(f)
      fileclose(f);
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	57                   	push   %edi
80105494:	e8 57 ba ff ff       	call   80100ef0 <fileclose>
80105499:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010549c:	83 ec 0c             	sub    $0xc,%esp
8010549f:	56                   	push   %esi
801054a0:	e8 6b c5 ff ff       	call   80101a10 <iunlockput>
    end_op();
801054a5:	e8 36 db ff ff       	call   80102fe0 <end_op>
    return -1;
801054aa:	83 c4 10             	add    $0x10,%esp
801054ad:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054b2:	eb 6d                	jmp    80105521 <sys_open+0x121>
801054b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801054b8:	83 ec 0c             	sub    $0xc,%esp
801054bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801054be:	31 c9                	xor    %ecx,%ecx
801054c0:	ba 02 00 00 00       	mov    $0x2,%edx
801054c5:	6a 00                	push   $0x0
801054c7:	e8 14 f8 ff ff       	call   80104ce0 <create>
    if(ip == 0){
801054cc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801054cf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801054d1:	85 c0                	test   %eax,%eax
801054d3:	75 99                	jne    8010546e <sys_open+0x6e>
      end_op();
801054d5:	e8 06 db ff ff       	call   80102fe0 <end_op>
      return -1;
801054da:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054df:	eb 40                	jmp    80105521 <sys_open+0x121>
801054e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801054e8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801054eb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801054ef:	56                   	push   %esi
801054f0:	e8 6b c3 ff ff       	call   80101860 <iunlock>
  end_op();
801054f5:	e8 e6 da ff ff       	call   80102fe0 <end_op>

  f->type = FD_INODE;
801054fa:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105500:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105503:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105506:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105509:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010550b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105512:	f7 d0                	not    %eax
80105514:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105517:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010551a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010551d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105521:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105524:	89 d8                	mov    %ebx,%eax
80105526:	5b                   	pop    %ebx
80105527:	5e                   	pop    %esi
80105528:	5f                   	pop    %edi
80105529:	5d                   	pop    %ebp
8010552a:	c3                   	ret    
8010552b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010552f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105530:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105533:	85 c9                	test   %ecx,%ecx
80105535:	0f 84 33 ff ff ff    	je     8010546e <sys_open+0x6e>
8010553b:	e9 5c ff ff ff       	jmp    8010549c <sys_open+0x9c>

80105540 <sys_mkdir>:

int
sys_mkdir(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105546:	e8 25 da ff ff       	call   80102f70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010554b:	83 ec 08             	sub    $0x8,%esp
8010554e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105551:	50                   	push   %eax
80105552:	6a 00                	push   $0x0
80105554:	e8 97 f6 ff ff       	call   80104bf0 <argstr>
80105559:	83 c4 10             	add    $0x10,%esp
8010555c:	85 c0                	test   %eax,%eax
8010555e:	78 30                	js     80105590 <sys_mkdir+0x50>
80105560:	83 ec 0c             	sub    $0xc,%esp
80105563:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105566:	31 c9                	xor    %ecx,%ecx
80105568:	ba 01 00 00 00       	mov    $0x1,%edx
8010556d:	6a 00                	push   $0x0
8010556f:	e8 6c f7 ff ff       	call   80104ce0 <create>
80105574:	83 c4 10             	add    $0x10,%esp
80105577:	85 c0                	test   %eax,%eax
80105579:	74 15                	je     80105590 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010557b:	83 ec 0c             	sub    $0xc,%esp
8010557e:	50                   	push   %eax
8010557f:	e8 8c c4 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105584:	e8 57 da ff ff       	call   80102fe0 <end_op>
  return 0;
80105589:	83 c4 10             	add    $0x10,%esp
8010558c:	31 c0                	xor    %eax,%eax
}
8010558e:	c9                   	leave  
8010558f:	c3                   	ret    
    end_op();
80105590:	e8 4b da ff ff       	call   80102fe0 <end_op>
    return -1;
80105595:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010559a:	c9                   	leave  
8010559b:	c3                   	ret    
8010559c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055a0 <sys_mknod>:

int
sys_mknod(void)
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801055a6:	e8 c5 d9 ff ff       	call   80102f70 <begin_op>
  if((argstr(0, &path)) < 0 ||
801055ab:	83 ec 08             	sub    $0x8,%esp
801055ae:	8d 45 ec             	lea    -0x14(%ebp),%eax
801055b1:	50                   	push   %eax
801055b2:	6a 00                	push   $0x0
801055b4:	e8 37 f6 ff ff       	call   80104bf0 <argstr>
801055b9:	83 c4 10             	add    $0x10,%esp
801055bc:	85 c0                	test   %eax,%eax
801055be:	78 60                	js     80105620 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801055c0:	83 ec 08             	sub    $0x8,%esp
801055c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055c6:	50                   	push   %eax
801055c7:	6a 01                	push   $0x1
801055c9:	e8 62 f5 ff ff       	call   80104b30 <argint>
  if((argstr(0, &path)) < 0 ||
801055ce:	83 c4 10             	add    $0x10,%esp
801055d1:	85 c0                	test   %eax,%eax
801055d3:	78 4b                	js     80105620 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801055d5:	83 ec 08             	sub    $0x8,%esp
801055d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055db:	50                   	push   %eax
801055dc:	6a 02                	push   $0x2
801055de:	e8 4d f5 ff ff       	call   80104b30 <argint>
     argint(1, &major) < 0 ||
801055e3:	83 c4 10             	add    $0x10,%esp
801055e6:	85 c0                	test   %eax,%eax
801055e8:	78 36                	js     80105620 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801055ea:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801055ee:	83 ec 0c             	sub    $0xc,%esp
801055f1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801055f5:	ba 03 00 00 00       	mov    $0x3,%edx
801055fa:	50                   	push   %eax
801055fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801055fe:	e8 dd f6 ff ff       	call   80104ce0 <create>
     argint(2, &minor) < 0 ||
80105603:	83 c4 10             	add    $0x10,%esp
80105606:	85 c0                	test   %eax,%eax
80105608:	74 16                	je     80105620 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010560a:	83 ec 0c             	sub    $0xc,%esp
8010560d:	50                   	push   %eax
8010560e:	e8 fd c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105613:	e8 c8 d9 ff ff       	call   80102fe0 <end_op>
  return 0;
80105618:	83 c4 10             	add    $0x10,%esp
8010561b:	31 c0                	xor    %eax,%eax
}
8010561d:	c9                   	leave  
8010561e:	c3                   	ret    
8010561f:	90                   	nop
    end_op();
80105620:	e8 bb d9 ff ff       	call   80102fe0 <end_op>
    return -1;
80105625:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010562a:	c9                   	leave  
8010562b:	c3                   	ret    
8010562c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105630 <sys_chdir>:

int
sys_chdir(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	56                   	push   %esi
80105634:	53                   	push   %ebx
80105635:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105638:	e8 43 e5 ff ff       	call   80103b80 <myproc>
8010563d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010563f:	e8 2c d9 ff ff       	call   80102f70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105644:	83 ec 08             	sub    $0x8,%esp
80105647:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010564a:	50                   	push   %eax
8010564b:	6a 00                	push   $0x0
8010564d:	e8 9e f5 ff ff       	call   80104bf0 <argstr>
80105652:	83 c4 10             	add    $0x10,%esp
80105655:	85 c0                	test   %eax,%eax
80105657:	78 77                	js     801056d0 <sys_chdir+0xa0>
80105659:	83 ec 0c             	sub    $0xc,%esp
8010565c:	ff 75 f4             	push   -0xc(%ebp)
8010565f:	e8 3c ca ff ff       	call   801020a0 <namei>
80105664:	83 c4 10             	add    $0x10,%esp
80105667:	89 c3                	mov    %eax,%ebx
80105669:	85 c0                	test   %eax,%eax
8010566b:	74 63                	je     801056d0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010566d:	83 ec 0c             	sub    $0xc,%esp
80105670:	50                   	push   %eax
80105671:	e8 0a c1 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105676:	83 c4 10             	add    $0x10,%esp
80105679:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010567e:	75 30                	jne    801056b0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105680:	83 ec 0c             	sub    $0xc,%esp
80105683:	53                   	push   %ebx
80105684:	e8 d7 c1 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105689:	58                   	pop    %eax
8010568a:	ff 76 68             	push   0x68(%esi)
8010568d:	e8 1e c2 ff ff       	call   801018b0 <iput>
  end_op();
80105692:	e8 49 d9 ff ff       	call   80102fe0 <end_op>
  curproc->cwd = ip;
80105697:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010569a:	83 c4 10             	add    $0x10,%esp
8010569d:	31 c0                	xor    %eax,%eax
}
8010569f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056a2:	5b                   	pop    %ebx
801056a3:	5e                   	pop    %esi
801056a4:	5d                   	pop    %ebp
801056a5:	c3                   	ret    
801056a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ad:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801056b0:	83 ec 0c             	sub    $0xc,%esp
801056b3:	53                   	push   %ebx
801056b4:	e8 57 c3 ff ff       	call   80101a10 <iunlockput>
    end_op();
801056b9:	e8 22 d9 ff ff       	call   80102fe0 <end_op>
    return -1;
801056be:	83 c4 10             	add    $0x10,%esp
801056c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056c6:	eb d7                	jmp    8010569f <sys_chdir+0x6f>
801056c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056cf:	90                   	nop
    end_op();
801056d0:	e8 0b d9 ff ff       	call   80102fe0 <end_op>
    return -1;
801056d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056da:	eb c3                	jmp    8010569f <sys_chdir+0x6f>
801056dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056e0 <sys_exec>:

int
sys_exec(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	57                   	push   %edi
801056e4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056e5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801056eb:	53                   	push   %ebx
801056ec:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056f2:	50                   	push   %eax
801056f3:	6a 00                	push   $0x0
801056f5:	e8 f6 f4 ff ff       	call   80104bf0 <argstr>
801056fa:	83 c4 10             	add    $0x10,%esp
801056fd:	85 c0                	test   %eax,%eax
801056ff:	0f 88 87 00 00 00    	js     8010578c <sys_exec+0xac>
80105705:	83 ec 08             	sub    $0x8,%esp
80105708:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010570e:	50                   	push   %eax
8010570f:	6a 01                	push   $0x1
80105711:	e8 1a f4 ff ff       	call   80104b30 <argint>
80105716:	83 c4 10             	add    $0x10,%esp
80105719:	85 c0                	test   %eax,%eax
8010571b:	78 6f                	js     8010578c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010571d:	83 ec 04             	sub    $0x4,%esp
80105720:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105726:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105728:	68 80 00 00 00       	push   $0x80
8010572d:	6a 00                	push   $0x0
8010572f:	56                   	push   %esi
80105730:	e8 3b f1 ff ff       	call   80104870 <memset>
80105735:	83 c4 10             	add    $0x10,%esp
80105738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105740:	83 ec 08             	sub    $0x8,%esp
80105743:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105749:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105750:	50                   	push   %eax
80105751:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105757:	01 f8                	add    %edi,%eax
80105759:	50                   	push   %eax
8010575a:	e8 41 f3 ff ff       	call   80104aa0 <fetchint>
8010575f:	83 c4 10             	add    $0x10,%esp
80105762:	85 c0                	test   %eax,%eax
80105764:	78 26                	js     8010578c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105766:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010576c:	85 c0                	test   %eax,%eax
8010576e:	74 30                	je     801057a0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105770:	83 ec 08             	sub    $0x8,%esp
80105773:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105776:	52                   	push   %edx
80105777:	50                   	push   %eax
80105778:	e8 63 f3 ff ff       	call   80104ae0 <fetchstr>
8010577d:	83 c4 10             	add    $0x10,%esp
80105780:	85 c0                	test   %eax,%eax
80105782:	78 08                	js     8010578c <sys_exec+0xac>
  for(i=0;; i++){
80105784:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105787:	83 fb 20             	cmp    $0x20,%ebx
8010578a:	75 b4                	jne    80105740 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010578c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010578f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105794:	5b                   	pop    %ebx
80105795:	5e                   	pop    %esi
80105796:	5f                   	pop    %edi
80105797:	5d                   	pop    %ebp
80105798:	c3                   	ret    
80105799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801057a0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801057a7:	00 00 00 00 
  return exec(path, argv);
801057ab:	83 ec 08             	sub    $0x8,%esp
801057ae:	56                   	push   %esi
801057af:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801057b5:	e8 f6 b2 ff ff       	call   80100ab0 <exec>
801057ba:	83 c4 10             	add    $0x10,%esp
}
801057bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057c0:	5b                   	pop    %ebx
801057c1:	5e                   	pop    %esi
801057c2:	5f                   	pop    %edi
801057c3:	5d                   	pop    %ebp
801057c4:	c3                   	ret    
801057c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057d0 <sys_pipe>:

int
sys_pipe(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	57                   	push   %edi
801057d4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057d5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801057d8:	53                   	push   %ebx
801057d9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057dc:	6a 08                	push   $0x8
801057de:	50                   	push   %eax
801057df:	6a 00                	push   $0x0
801057e1:	e8 9a f3 ff ff       	call   80104b80 <argptr>
801057e6:	83 c4 10             	add    $0x10,%esp
801057e9:	85 c0                	test   %eax,%eax
801057eb:	78 4a                	js     80105837 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801057ed:	83 ec 08             	sub    $0x8,%esp
801057f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057f3:	50                   	push   %eax
801057f4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801057f7:	50                   	push   %eax
801057f8:	e8 43 de ff ff       	call   80103640 <pipealloc>
801057fd:	83 c4 10             	add    $0x10,%esp
80105800:	85 c0                	test   %eax,%eax
80105802:	78 33                	js     80105837 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105804:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105807:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105809:	e8 72 e3 ff ff       	call   80103b80 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010580e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105810:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105814:	85 f6                	test   %esi,%esi
80105816:	74 28                	je     80105840 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105818:	83 c3 01             	add    $0x1,%ebx
8010581b:	83 fb 10             	cmp    $0x10,%ebx
8010581e:	75 f0                	jne    80105810 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105820:	83 ec 0c             	sub    $0xc,%esp
80105823:	ff 75 e0             	push   -0x20(%ebp)
80105826:	e8 c5 b6 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010582b:	58                   	pop    %eax
8010582c:	ff 75 e4             	push   -0x1c(%ebp)
8010582f:	e8 bc b6 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105834:	83 c4 10             	add    $0x10,%esp
80105837:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010583c:	eb 53                	jmp    80105891 <sys_pipe+0xc1>
8010583e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105840:	8d 73 08             	lea    0x8(%ebx),%esi
80105843:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105847:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010584a:	e8 31 e3 ff ff       	call   80103b80 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010584f:	31 d2                	xor    %edx,%edx
80105851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105858:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010585c:	85 c9                	test   %ecx,%ecx
8010585e:	74 20                	je     80105880 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105860:	83 c2 01             	add    $0x1,%edx
80105863:	83 fa 10             	cmp    $0x10,%edx
80105866:	75 f0                	jne    80105858 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105868:	e8 13 e3 ff ff       	call   80103b80 <myproc>
8010586d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105874:	00 
80105875:	eb a9                	jmp    80105820 <sys_pipe+0x50>
80105877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010587e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105880:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105884:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105887:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105889:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010588c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010588f:	31 c0                	xor    %eax,%eax
}
80105891:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105894:	5b                   	pop    %ebx
80105895:	5e                   	pop    %esi
80105896:	5f                   	pop    %edi
80105897:	5d                   	pop    %ebp
80105898:	c3                   	ret    
80105899:	66 90                	xchg   %ax,%ax
8010589b:	66 90                	xchg   %ax,%ax
8010589d:	66 90                	xchg   %ax,%ax
8010589f:	90                   	nop

801058a0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801058a0:	e9 7b e4 ff ff       	jmp    80103d20 <fork>
801058a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058b0 <sys_exit>:
}

int
sys_exit(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	83 ec 08             	sub    $0x8,%esp
  exit();
801058b6:	e8 e5 e6 ff ff       	call   80103fa0 <exit>
  return 0;  // not reached
}
801058bb:	31 c0                	xor    %eax,%eax
801058bd:	c9                   	leave  
801058be:	c3                   	ret    
801058bf:	90                   	nop

801058c0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801058c0:	e9 0b e8 ff ff       	jmp    801040d0 <wait>
801058c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058d0 <sys_kill>:
}

int
sys_kill(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801058d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058d9:	50                   	push   %eax
801058da:	6a 00                	push   $0x0
801058dc:	e8 4f f2 ff ff       	call   80104b30 <argint>
801058e1:	83 c4 10             	add    $0x10,%esp
801058e4:	85 c0                	test   %eax,%eax
801058e6:	78 18                	js     80105900 <sys_kill+0x30>
    return -1;
  return kill(pid);
801058e8:	83 ec 0c             	sub    $0xc,%esp
801058eb:	ff 75 f4             	push   -0xc(%ebp)
801058ee:	e8 7d ea ff ff       	call   80104370 <kill>
801058f3:	83 c4 10             	add    $0x10,%esp
}
801058f6:	c9                   	leave  
801058f7:	c3                   	ret    
801058f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ff:	90                   	nop
80105900:	c9                   	leave  
    return -1;
80105901:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105906:	c3                   	ret    
80105907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010590e:	66 90                	xchg   %ax,%ax

80105910 <sys_getpid>:

int
sys_getpid(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105916:	e8 65 e2 ff ff       	call   80103b80 <myproc>
8010591b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010591e:	c9                   	leave  
8010591f:	c3                   	ret    

80105920 <sys_sbrk>:

int
sys_sbrk(void)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105924:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105927:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010592a:	50                   	push   %eax
8010592b:	6a 00                	push   $0x0
8010592d:	e8 fe f1 ff ff       	call   80104b30 <argint>
80105932:	83 c4 10             	add    $0x10,%esp
80105935:	85 c0                	test   %eax,%eax
80105937:	78 27                	js     80105960 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105939:	e8 42 e2 ff ff       	call   80103b80 <myproc>
  if(growproc(n) < 0)
8010593e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105941:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105943:	ff 75 f4             	push   -0xc(%ebp)
80105946:	e8 55 e3 ff ff       	call   80103ca0 <growproc>
8010594b:	83 c4 10             	add    $0x10,%esp
8010594e:	85 c0                	test   %eax,%eax
80105950:	78 0e                	js     80105960 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105952:	89 d8                	mov    %ebx,%eax
80105954:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105957:	c9                   	leave  
80105958:	c3                   	ret    
80105959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105960:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105965:	eb eb                	jmp    80105952 <sys_sbrk+0x32>
80105967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596e:	66 90                	xchg   %ax,%ax

80105970 <sys_sleep>:

int
sys_sleep(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105974:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105977:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010597a:	50                   	push   %eax
8010597b:	6a 00                	push   $0x0
8010597d:	e8 ae f1 ff ff       	call   80104b30 <argint>
80105982:	83 c4 10             	add    $0x10,%esp
80105985:	85 c0                	test   %eax,%eax
80105987:	0f 88 8a 00 00 00    	js     80105a17 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010598d:	83 ec 0c             	sub    $0xc,%esp
80105990:	68 80 cc 14 80       	push   $0x8014cc80
80105995:	e8 16 ee ff ff       	call   801047b0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010599a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010599d:	8b 1d 60 cc 14 80    	mov    0x8014cc60,%ebx
  while(ticks - ticks0 < n){
801059a3:	83 c4 10             	add    $0x10,%esp
801059a6:	85 d2                	test   %edx,%edx
801059a8:	75 27                	jne    801059d1 <sys_sleep+0x61>
801059aa:	eb 54                	jmp    80105a00 <sys_sleep+0x90>
801059ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801059b0:	83 ec 08             	sub    $0x8,%esp
801059b3:	68 80 cc 14 80       	push   $0x8014cc80
801059b8:	68 60 cc 14 80       	push   $0x8014cc60
801059bd:	e8 8e e8 ff ff       	call   80104250 <sleep>
  while(ticks - ticks0 < n){
801059c2:	a1 60 cc 14 80       	mov    0x8014cc60,%eax
801059c7:	83 c4 10             	add    $0x10,%esp
801059ca:	29 d8                	sub    %ebx,%eax
801059cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801059cf:	73 2f                	jae    80105a00 <sys_sleep+0x90>
    if(myproc()->killed){
801059d1:	e8 aa e1 ff ff       	call   80103b80 <myproc>
801059d6:	8b 40 24             	mov    0x24(%eax),%eax
801059d9:	85 c0                	test   %eax,%eax
801059db:	74 d3                	je     801059b0 <sys_sleep+0x40>
      release(&tickslock);
801059dd:	83 ec 0c             	sub    $0xc,%esp
801059e0:	68 80 cc 14 80       	push   $0x8014cc80
801059e5:	e8 66 ed ff ff       	call   80104750 <release>
  }
  release(&tickslock);
  return 0;
}
801059ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801059ed:	83 c4 10             	add    $0x10,%esp
801059f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059f5:	c9                   	leave  
801059f6:	c3                   	ret    
801059f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059fe:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105a00:	83 ec 0c             	sub    $0xc,%esp
80105a03:	68 80 cc 14 80       	push   $0x8014cc80
80105a08:	e8 43 ed ff ff       	call   80104750 <release>
  return 0;
80105a0d:	83 c4 10             	add    $0x10,%esp
80105a10:	31 c0                	xor    %eax,%eax
}
80105a12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a15:	c9                   	leave  
80105a16:	c3                   	ret    
    return -1;
80105a17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a1c:	eb f4                	jmp    80105a12 <sys_sleep+0xa2>
80105a1e:	66 90                	xchg   %ax,%ax

80105a20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	53                   	push   %ebx
80105a24:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a27:	68 80 cc 14 80       	push   $0x8014cc80
80105a2c:	e8 7f ed ff ff       	call   801047b0 <acquire>
  xticks = ticks;
80105a31:	8b 1d 60 cc 14 80    	mov    0x8014cc60,%ebx
  release(&tickslock);
80105a37:	c7 04 24 80 cc 14 80 	movl   $0x8014cc80,(%esp)
80105a3e:	e8 0d ed ff ff       	call   80104750 <release>
  return xticks;
}
80105a43:	89 d8                	mov    %ebx,%eax
80105a45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a48:	c9                   	leave  
80105a49:	c3                   	ret    
80105a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a50 <sys_countfp>:

int
sys_countfp(void)
{
  return countfp();
80105a50:	e9 2b cd ff ff       	jmp    80102780 <countfp>
80105a55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a60 <sys_countvp>:
}

int
sys_countvp(void)
{
  return countvp();
80105a60:	e9 9b 1a 00 00       	jmp    80107500 <countvp>
80105a65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a70 <sys_countpp>:
}

int
sys_countpp(void)
{
  return countpp();
80105a70:	e9 0b 1b 00 00       	jmp    80107580 <countpp>
80105a75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a80 <sys_countptp>:
}

int
sys_countptp(void)
{
  return countptp();
80105a80:	e9 5b 1b 00 00       	jmp    801075e0 <countptp>

80105a85 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105a85:	1e                   	push   %ds
  pushl %es
80105a86:	06                   	push   %es
  pushl %fs
80105a87:	0f a0                	push   %fs
  pushl %gs
80105a89:	0f a8                	push   %gs
  pushal
80105a8b:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105a8c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105a90:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105a92:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105a94:	54                   	push   %esp
  call trap
80105a95:	e8 c6 00 00 00       	call   80105b60 <trap>
  addl $4, %esp
80105a9a:	83 c4 04             	add    $0x4,%esp

80105a9d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105a9d:	61                   	popa   
  popl %gs
80105a9e:	0f a9                	pop    %gs
  popl %fs
80105aa0:	0f a1                	pop    %fs
  popl %es
80105aa2:	07                   	pop    %es
  popl %ds
80105aa3:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105aa4:	83 c4 08             	add    $0x8,%esp
  iret
80105aa7:	cf                   	iret   
80105aa8:	66 90                	xchg   %ax,%ax
80105aaa:	66 90                	xchg   %ax,%ax
80105aac:	66 90                	xchg   %ax,%ax
80105aae:	66 90                	xchg   %ax,%ax

80105ab0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105ab0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105ab1:	31 c0                	xor    %eax,%eax
{
80105ab3:	89 e5                	mov    %esp,%ebp
80105ab5:	83 ec 08             	sub    $0x8,%esp
80105ab8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105abf:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ac0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105ac7:	c7 04 c5 c2 cc 14 80 	movl   $0x8e000008,-0x7feb333e(,%eax,8)
80105ace:	08 00 00 8e 
80105ad2:	66 89 14 c5 c0 cc 14 	mov    %dx,-0x7feb3340(,%eax,8)
80105ad9:	80 
80105ada:	c1 ea 10             	shr    $0x10,%edx
80105add:	66 89 14 c5 c6 cc 14 	mov    %dx,-0x7feb333a(,%eax,8)
80105ae4:	80 
  for(i = 0; i < 256; i++)
80105ae5:	83 c0 01             	add    $0x1,%eax
80105ae8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105aed:	75 d1                	jne    80105ac0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105aef:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105af2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105af7:	c7 05 c2 ce 14 80 08 	movl   $0xef000008,0x8014cec2
80105afe:	00 00 ef 
  initlock(&tickslock, "time");
80105b01:	68 e9 7d 10 80       	push   $0x80107de9
80105b06:	68 80 cc 14 80       	push   $0x8014cc80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b0b:	66 a3 c0 ce 14 80    	mov    %ax,0x8014cec0
80105b11:	c1 e8 10             	shr    $0x10,%eax
80105b14:	66 a3 c6 ce 14 80    	mov    %ax,0x8014cec6
  initlock(&tickslock, "time");
80105b1a:	e8 c1 ea ff ff       	call   801045e0 <initlock>
}
80105b1f:	83 c4 10             	add    $0x10,%esp
80105b22:	c9                   	leave  
80105b23:	c3                   	ret    
80105b24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b2f:	90                   	nop

80105b30 <idtinit>:

void
idtinit(void)
{
80105b30:	55                   	push   %ebp
  pd[0] = size-1;
80105b31:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105b36:	89 e5                	mov    %esp,%ebp
80105b38:	83 ec 10             	sub    $0x10,%esp
80105b3b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105b3f:	b8 c0 cc 14 80       	mov    $0x8014ccc0,%eax
80105b44:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105b48:	c1 e8 10             	shr    $0x10,%eax
80105b4b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105b4f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b52:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105b55:	c9                   	leave  
80105b56:	c3                   	ret    
80105b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5e:	66 90                	xchg   %ax,%ax

80105b60 <trap>:
extern void CoW_handler(void);

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	57                   	push   %edi
80105b64:	56                   	push   %esi
80105b65:	53                   	push   %ebx
80105b66:	83 ec 1c             	sub    $0x1c,%esp
80105b69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105b6c:	8b 43 30             	mov    0x30(%ebx),%eax
80105b6f:	83 f8 40             	cmp    $0x40,%eax
80105b72:	0f 84 30 01 00 00    	je     80105ca8 <trap+0x148>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105b78:	83 e8 0e             	sub    $0xe,%eax
80105b7b:	83 f8 31             	cmp    $0x31,%eax
80105b7e:	0f 87 8c 00 00 00    	ja     80105c10 <trap+0xb0>
80105b84:	ff 24 85 90 7e 10 80 	jmp    *-0x7fef8170(,%eax,4)
80105b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b8f:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105b90:	e8 cb df ff ff       	call   80103b60 <cpuid>
80105b95:	85 c0                	test   %eax,%eax
80105b97:	0f 84 13 02 00 00    	je     80105db0 <trap+0x250>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105b9d:	e8 7e cf ff ff       	call   80102b20 <lapiceoi>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  // Force process exit if it has been killed and is in user space.
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ba2:	e8 d9 df ff ff       	call   80103b80 <myproc>
80105ba7:	85 c0                	test   %eax,%eax
80105ba9:	74 1d                	je     80105bc8 <trap+0x68>
80105bab:	e8 d0 df ff ff       	call   80103b80 <myproc>
80105bb0:	8b 50 24             	mov    0x24(%eax),%edx
80105bb3:	85 d2                	test   %edx,%edx
80105bb5:	74 11                	je     80105bc8 <trap+0x68>
80105bb7:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105bbb:	83 e0 03             	and    $0x3,%eax
80105bbe:	66 83 f8 03          	cmp    $0x3,%ax
80105bc2:	0f 84 c8 01 00 00    	je     80105d90 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  if(myproc() && myproc()->state == RUNNING &&
80105bc8:	e8 b3 df ff ff       	call   80103b80 <myproc>
80105bcd:	85 c0                	test   %eax,%eax
80105bcf:	74 0f                	je     80105be0 <trap+0x80>
80105bd1:	e8 aa df ff ff       	call   80103b80 <myproc>
80105bd6:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105bda:	0f 84 b0 00 00 00    	je     80105c90 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105be0:	e8 9b df ff ff       	call   80103b80 <myproc>
80105be5:	85 c0                	test   %eax,%eax
80105be7:	74 1d                	je     80105c06 <trap+0xa6>
80105be9:	e8 92 df ff ff       	call   80103b80 <myproc>
80105bee:	8b 40 24             	mov    0x24(%eax),%eax
80105bf1:	85 c0                	test   %eax,%eax
80105bf3:	74 11                	je     80105c06 <trap+0xa6>
80105bf5:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105bf9:	83 e0 03             	and    $0x3,%eax
80105bfc:	66 83 f8 03          	cmp    $0x3,%ax
80105c00:	0f 84 cf 00 00 00    	je     80105cd5 <trap+0x175>
    exit();
80105c06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c09:	5b                   	pop    %ebx
80105c0a:	5e                   	pop    %esi
80105c0b:	5f                   	pop    %edi
80105c0c:	5d                   	pop    %ebp
80105c0d:	c3                   	ret    
80105c0e:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80105c10:	e8 6b df ff ff       	call   80103b80 <myproc>
80105c15:	8b 7b 38             	mov    0x38(%ebx),%edi
80105c18:	85 c0                	test   %eax,%eax
80105c1a:	0f 84 c4 01 00 00    	je     80105de4 <trap+0x284>
80105c20:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105c24:	0f 84 ba 01 00 00    	je     80105de4 <trap+0x284>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c2a:	0f 20 d1             	mov    %cr2,%ecx
80105c2d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c30:	e8 2b df ff ff       	call   80103b60 <cpuid>
80105c35:	8b 73 30             	mov    0x30(%ebx),%esi
80105c38:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105c3b:	8b 43 34             	mov    0x34(%ebx),%eax
80105c3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105c41:	e8 3a df ff ff       	call   80103b80 <myproc>
80105c46:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c49:	e8 32 df ff ff       	call   80103b80 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c4e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105c51:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105c54:	51                   	push   %ecx
80105c55:	57                   	push   %edi
80105c56:	52                   	push   %edx
80105c57:	ff 75 e4             	push   -0x1c(%ebp)
80105c5a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105c5b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105c5e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c61:	56                   	push   %esi
80105c62:	ff 70 10             	push   0x10(%eax)
80105c65:	68 4c 7e 10 80       	push   $0x80107e4c
80105c6a:	e8 31 aa ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105c6f:	83 c4 20             	add    $0x20,%esp
80105c72:	e8 09 df ff ff       	call   80103b80 <myproc>
80105c77:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c7e:	e8 fd de ff ff       	call   80103b80 <myproc>
80105c83:	85 c0                	test   %eax,%eax
80105c85:	0f 85 20 ff ff ff    	jne    80105bab <trap+0x4b>
80105c8b:	e9 38 ff ff ff       	jmp    80105bc8 <trap+0x68>
  if(myproc() && myproc()->state == RUNNING &&
80105c90:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105c94:	0f 85 46 ff ff ff    	jne    80105be0 <trap+0x80>
    yield();
80105c9a:	e8 61 e5 ff ff       	call   80104200 <yield>
80105c9f:	e9 3c ff ff ff       	jmp    80105be0 <trap+0x80>
80105ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105ca8:	e8 d3 de ff ff       	call   80103b80 <myproc>
80105cad:	8b 70 24             	mov    0x24(%eax),%esi
80105cb0:	85 f6                	test   %esi,%esi
80105cb2:	0f 85 e8 00 00 00    	jne    80105da0 <trap+0x240>
    myproc()->tf = tf;
80105cb8:	e8 c3 de ff ff       	call   80103b80 <myproc>
80105cbd:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105cc0:	e8 ab ef ff ff       	call   80104c70 <syscall>
    if(myproc()->killed)
80105cc5:	e8 b6 de ff ff       	call   80103b80 <myproc>
80105cca:	8b 48 24             	mov    0x24(%eax),%ecx
80105ccd:	85 c9                	test   %ecx,%ecx
80105ccf:	0f 84 31 ff ff ff    	je     80105c06 <trap+0xa6>
80105cd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cd8:	5b                   	pop    %ebx
80105cd9:	5e                   	pop    %esi
80105cda:	5f                   	pop    %edi
80105cdb:	5d                   	pop    %ebp
      exit();
80105cdc:	e9 bf e2 ff ff       	jmp    80103fa0 <exit>
80105ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ce8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105ceb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105cef:	e8 6c de ff ff       	call   80103b60 <cpuid>
80105cf4:	57                   	push   %edi
80105cf5:	56                   	push   %esi
80105cf6:	50                   	push   %eax
80105cf7:	68 f4 7d 10 80       	push   $0x80107df4
80105cfc:	e8 9f a9 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105d01:	e8 1a ce ff ff       	call   80102b20 <lapiceoi>
    break;
80105d06:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d09:	e8 72 de ff ff       	call   80103b80 <myproc>
80105d0e:	85 c0                	test   %eax,%eax
80105d10:	0f 85 95 fe ff ff    	jne    80105bab <trap+0x4b>
80105d16:	e9 ad fe ff ff       	jmp    80105bc8 <trap+0x68>
80105d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d1f:	90                   	nop
    kbdintr();
80105d20:	e8 bb cc ff ff       	call   801029e0 <kbdintr>
    lapiceoi();
80105d25:	e8 f6 cd ff ff       	call   80102b20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d2a:	e8 51 de ff ff       	call   80103b80 <myproc>
80105d2f:	85 c0                	test   %eax,%eax
80105d31:	0f 85 74 fe ff ff    	jne    80105bab <trap+0x4b>
80105d37:	e9 8c fe ff ff       	jmp    80105bc8 <trap+0x68>
80105d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105d40:	e8 3b 02 00 00       	call   80105f80 <uartintr>
    lapiceoi();
80105d45:	e8 d6 cd ff ff       	call   80102b20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d4a:	e8 31 de ff ff       	call   80103b80 <myproc>
80105d4f:	85 c0                	test   %eax,%eax
80105d51:	0f 85 54 fe ff ff    	jne    80105bab <trap+0x4b>
80105d57:	e9 6c fe ff ff       	jmp    80105bc8 <trap+0x68>
80105d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105d60:	e8 db c4 ff ff       	call   80102240 <ideintr>
80105d65:	e9 33 fe ff ff       	jmp    80105b9d <trap+0x3d>
80105d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    CoW_handler();
80105d70:	e8 4b 16 00 00       	call   801073c0 <CoW_handler>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d75:	e8 06 de ff ff       	call   80103b80 <myproc>
80105d7a:	85 c0                	test   %eax,%eax
80105d7c:	0f 85 29 fe ff ff    	jne    80105bab <trap+0x4b>
80105d82:	e9 41 fe ff ff       	jmp    80105bc8 <trap+0x68>
80105d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d8e:	66 90                	xchg   %ax,%ax
    exit();
80105d90:	e8 0b e2 ff ff       	call   80103fa0 <exit>
80105d95:	e9 2e fe ff ff       	jmp    80105bc8 <trap+0x68>
80105d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105da0:	e8 fb e1 ff ff       	call   80103fa0 <exit>
80105da5:	e9 0e ff ff ff       	jmp    80105cb8 <trap+0x158>
80105daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105db0:	83 ec 0c             	sub    $0xc,%esp
80105db3:	68 80 cc 14 80       	push   $0x8014cc80
80105db8:	e8 f3 e9 ff ff       	call   801047b0 <acquire>
      wakeup(&ticks);
80105dbd:	c7 04 24 60 cc 14 80 	movl   $0x8014cc60,(%esp)
      ticks++;
80105dc4:	83 05 60 cc 14 80 01 	addl   $0x1,0x8014cc60
      wakeup(&ticks);
80105dcb:	e8 40 e5 ff ff       	call   80104310 <wakeup>
      release(&tickslock);
80105dd0:	c7 04 24 80 cc 14 80 	movl   $0x8014cc80,(%esp)
80105dd7:	e8 74 e9 ff ff       	call   80104750 <release>
80105ddc:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105ddf:	e9 b9 fd ff ff       	jmp    80105b9d <trap+0x3d>
80105de4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105de7:	e8 74 dd ff ff       	call   80103b60 <cpuid>
80105dec:	83 ec 0c             	sub    $0xc,%esp
80105def:	56                   	push   %esi
80105df0:	57                   	push   %edi
80105df1:	50                   	push   %eax
80105df2:	ff 73 30             	push   0x30(%ebx)
80105df5:	68 18 7e 10 80       	push   $0x80107e18
80105dfa:	e8 a1 a8 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105dff:	83 c4 14             	add    $0x14,%esp
80105e02:	68 ee 7d 10 80       	push   $0x80107dee
80105e07:	e8 74 a5 ff ff       	call   80100380 <panic>
80105e0c:	66 90                	xchg   %ax,%ax
80105e0e:	66 90                	xchg   %ax,%ax

80105e10 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105e10:	a1 c0 d4 14 80       	mov    0x8014d4c0,%eax
80105e15:	85 c0                	test   %eax,%eax
80105e17:	74 17                	je     80105e30 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e19:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e1e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105e1f:	a8 01                	test   $0x1,%al
80105e21:	74 0d                	je     80105e30 <uartgetc+0x20>
80105e23:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e28:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105e29:	0f b6 c0             	movzbl %al,%eax
80105e2c:	c3                   	ret    
80105e2d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e35:	c3                   	ret    
80105e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e3d:	8d 76 00             	lea    0x0(%esi),%esi

80105e40 <uartinit>:
{
80105e40:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e41:	31 c9                	xor    %ecx,%ecx
80105e43:	89 c8                	mov    %ecx,%eax
80105e45:	89 e5                	mov    %esp,%ebp
80105e47:	57                   	push   %edi
80105e48:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105e4d:	56                   	push   %esi
80105e4e:	89 fa                	mov    %edi,%edx
80105e50:	53                   	push   %ebx
80105e51:	83 ec 1c             	sub    $0x1c,%esp
80105e54:	ee                   	out    %al,(%dx)
80105e55:	be fb 03 00 00       	mov    $0x3fb,%esi
80105e5a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e5f:	89 f2                	mov    %esi,%edx
80105e61:	ee                   	out    %al,(%dx)
80105e62:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e67:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e6c:	ee                   	out    %al,(%dx)
80105e6d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105e72:	89 c8                	mov    %ecx,%eax
80105e74:	89 da                	mov    %ebx,%edx
80105e76:	ee                   	out    %al,(%dx)
80105e77:	b8 03 00 00 00       	mov    $0x3,%eax
80105e7c:	89 f2                	mov    %esi,%edx
80105e7e:	ee                   	out    %al,(%dx)
80105e7f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105e84:	89 c8                	mov    %ecx,%eax
80105e86:	ee                   	out    %al,(%dx)
80105e87:	b8 01 00 00 00       	mov    $0x1,%eax
80105e8c:	89 da                	mov    %ebx,%edx
80105e8e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e8f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e94:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105e95:	3c ff                	cmp    $0xff,%al
80105e97:	74 78                	je     80105f11 <uartinit+0xd1>
  uart = 1;
80105e99:	c7 05 c0 d4 14 80 01 	movl   $0x1,0x8014d4c0
80105ea0:	00 00 00 
80105ea3:	89 fa                	mov    %edi,%edx
80105ea5:	ec                   	in     (%dx),%al
80105ea6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105eab:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105eac:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105eaf:	bf 58 7f 10 80       	mov    $0x80107f58,%edi
80105eb4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105eb9:	6a 00                	push   $0x0
80105ebb:	6a 04                	push   $0x4
80105ebd:	e8 be c5 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105ec2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105ec6:	83 c4 10             	add    $0x10,%esp
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105ed0:	a1 c0 d4 14 80       	mov    0x8014d4c0,%eax
80105ed5:	bb 80 00 00 00       	mov    $0x80,%ebx
80105eda:	85 c0                	test   %eax,%eax
80105edc:	75 14                	jne    80105ef2 <uartinit+0xb2>
80105ede:	eb 23                	jmp    80105f03 <uartinit+0xc3>
    microdelay(10);
80105ee0:	83 ec 0c             	sub    $0xc,%esp
80105ee3:	6a 0a                	push   $0xa
80105ee5:	e8 56 cc ff ff       	call   80102b40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105eea:	83 c4 10             	add    $0x10,%esp
80105eed:	83 eb 01             	sub    $0x1,%ebx
80105ef0:	74 07                	je     80105ef9 <uartinit+0xb9>
80105ef2:	89 f2                	mov    %esi,%edx
80105ef4:	ec                   	in     (%dx),%al
80105ef5:	a8 20                	test   $0x20,%al
80105ef7:	74 e7                	je     80105ee0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ef9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105efd:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f02:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105f03:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105f07:	83 c7 01             	add    $0x1,%edi
80105f0a:	88 45 e7             	mov    %al,-0x19(%ebp)
80105f0d:	84 c0                	test   %al,%al
80105f0f:	75 bf                	jne    80105ed0 <uartinit+0x90>
}
80105f11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f14:	5b                   	pop    %ebx
80105f15:	5e                   	pop    %esi
80105f16:	5f                   	pop    %edi
80105f17:	5d                   	pop    %ebp
80105f18:	c3                   	ret    
80105f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f20 <uartputc>:
  if(!uart)
80105f20:	a1 c0 d4 14 80       	mov    0x8014d4c0,%eax
80105f25:	85 c0                	test   %eax,%eax
80105f27:	74 47                	je     80105f70 <uartputc+0x50>
{
80105f29:	55                   	push   %ebp
80105f2a:	89 e5                	mov    %esp,%ebp
80105f2c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f2d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f32:	53                   	push   %ebx
80105f33:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f38:	eb 18                	jmp    80105f52 <uartputc+0x32>
80105f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105f40:	83 ec 0c             	sub    $0xc,%esp
80105f43:	6a 0a                	push   $0xa
80105f45:	e8 f6 cb ff ff       	call   80102b40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f4a:	83 c4 10             	add    $0x10,%esp
80105f4d:	83 eb 01             	sub    $0x1,%ebx
80105f50:	74 07                	je     80105f59 <uartputc+0x39>
80105f52:	89 f2                	mov    %esi,%edx
80105f54:	ec                   	in     (%dx),%al
80105f55:	a8 20                	test   $0x20,%al
80105f57:	74 e7                	je     80105f40 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f59:	8b 45 08             	mov    0x8(%ebp),%eax
80105f5c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f61:	ee                   	out    %al,(%dx)
}
80105f62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f65:	5b                   	pop    %ebx
80105f66:	5e                   	pop    %esi
80105f67:	5d                   	pop    %ebp
80105f68:	c3                   	ret    
80105f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f70:	c3                   	ret    
80105f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f7f:	90                   	nop

80105f80 <uartintr>:

void
uartintr(void)
{
80105f80:	55                   	push   %ebp
80105f81:	89 e5                	mov    %esp,%ebp
80105f83:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105f86:	68 10 5e 10 80       	push   $0x80105e10
80105f8b:	e8 f0 a8 ff ff       	call   80100880 <consoleintr>
}
80105f90:	83 c4 10             	add    $0x10,%esp
80105f93:	c9                   	leave  
80105f94:	c3                   	ret    

80105f95 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105f95:	6a 00                	push   $0x0
  pushl $0
80105f97:	6a 00                	push   $0x0
  jmp alltraps
80105f99:	e9 e7 fa ff ff       	jmp    80105a85 <alltraps>

80105f9e <vector1>:
.globl vector1
vector1:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $1
80105fa0:	6a 01                	push   $0x1
  jmp alltraps
80105fa2:	e9 de fa ff ff       	jmp    80105a85 <alltraps>

80105fa7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105fa7:	6a 00                	push   $0x0
  pushl $2
80105fa9:	6a 02                	push   $0x2
  jmp alltraps
80105fab:	e9 d5 fa ff ff       	jmp    80105a85 <alltraps>

80105fb0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105fb0:	6a 00                	push   $0x0
  pushl $3
80105fb2:	6a 03                	push   $0x3
  jmp alltraps
80105fb4:	e9 cc fa ff ff       	jmp    80105a85 <alltraps>

80105fb9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105fb9:	6a 00                	push   $0x0
  pushl $4
80105fbb:	6a 04                	push   $0x4
  jmp alltraps
80105fbd:	e9 c3 fa ff ff       	jmp    80105a85 <alltraps>

80105fc2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $5
80105fc4:	6a 05                	push   $0x5
  jmp alltraps
80105fc6:	e9 ba fa ff ff       	jmp    80105a85 <alltraps>

80105fcb <vector6>:
.globl vector6
vector6:
  pushl $0
80105fcb:	6a 00                	push   $0x0
  pushl $6
80105fcd:	6a 06                	push   $0x6
  jmp alltraps
80105fcf:	e9 b1 fa ff ff       	jmp    80105a85 <alltraps>

80105fd4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $7
80105fd6:	6a 07                	push   $0x7
  jmp alltraps
80105fd8:	e9 a8 fa ff ff       	jmp    80105a85 <alltraps>

80105fdd <vector8>:
.globl vector8
vector8:
  pushl $8
80105fdd:	6a 08                	push   $0x8
  jmp alltraps
80105fdf:	e9 a1 fa ff ff       	jmp    80105a85 <alltraps>

80105fe4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105fe4:	6a 00                	push   $0x0
  pushl $9
80105fe6:	6a 09                	push   $0x9
  jmp alltraps
80105fe8:	e9 98 fa ff ff       	jmp    80105a85 <alltraps>

80105fed <vector10>:
.globl vector10
vector10:
  pushl $10
80105fed:	6a 0a                	push   $0xa
  jmp alltraps
80105fef:	e9 91 fa ff ff       	jmp    80105a85 <alltraps>

80105ff4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105ff4:	6a 0b                	push   $0xb
  jmp alltraps
80105ff6:	e9 8a fa ff ff       	jmp    80105a85 <alltraps>

80105ffb <vector12>:
.globl vector12
vector12:
  pushl $12
80105ffb:	6a 0c                	push   $0xc
  jmp alltraps
80105ffd:	e9 83 fa ff ff       	jmp    80105a85 <alltraps>

80106002 <vector13>:
.globl vector13
vector13:
  pushl $13
80106002:	6a 0d                	push   $0xd
  jmp alltraps
80106004:	e9 7c fa ff ff       	jmp    80105a85 <alltraps>

80106009 <vector14>:
.globl vector14
vector14:
  pushl $14
80106009:	6a 0e                	push   $0xe
  jmp alltraps
8010600b:	e9 75 fa ff ff       	jmp    80105a85 <alltraps>

80106010 <vector15>:
.globl vector15
vector15:
  pushl $0
80106010:	6a 00                	push   $0x0
  pushl $15
80106012:	6a 0f                	push   $0xf
  jmp alltraps
80106014:	e9 6c fa ff ff       	jmp    80105a85 <alltraps>

80106019 <vector16>:
.globl vector16
vector16:
  pushl $0
80106019:	6a 00                	push   $0x0
  pushl $16
8010601b:	6a 10                	push   $0x10
  jmp alltraps
8010601d:	e9 63 fa ff ff       	jmp    80105a85 <alltraps>

80106022 <vector17>:
.globl vector17
vector17:
  pushl $17
80106022:	6a 11                	push   $0x11
  jmp alltraps
80106024:	e9 5c fa ff ff       	jmp    80105a85 <alltraps>

80106029 <vector18>:
.globl vector18
vector18:
  pushl $0
80106029:	6a 00                	push   $0x0
  pushl $18
8010602b:	6a 12                	push   $0x12
  jmp alltraps
8010602d:	e9 53 fa ff ff       	jmp    80105a85 <alltraps>

80106032 <vector19>:
.globl vector19
vector19:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $19
80106034:	6a 13                	push   $0x13
  jmp alltraps
80106036:	e9 4a fa ff ff       	jmp    80105a85 <alltraps>

8010603b <vector20>:
.globl vector20
vector20:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $20
8010603d:	6a 14                	push   $0x14
  jmp alltraps
8010603f:	e9 41 fa ff ff       	jmp    80105a85 <alltraps>

80106044 <vector21>:
.globl vector21
vector21:
  pushl $0
80106044:	6a 00                	push   $0x0
  pushl $21
80106046:	6a 15                	push   $0x15
  jmp alltraps
80106048:	e9 38 fa ff ff       	jmp    80105a85 <alltraps>

8010604d <vector22>:
.globl vector22
vector22:
  pushl $0
8010604d:	6a 00                	push   $0x0
  pushl $22
8010604f:	6a 16                	push   $0x16
  jmp alltraps
80106051:	e9 2f fa ff ff       	jmp    80105a85 <alltraps>

80106056 <vector23>:
.globl vector23
vector23:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $23
80106058:	6a 17                	push   $0x17
  jmp alltraps
8010605a:	e9 26 fa ff ff       	jmp    80105a85 <alltraps>

8010605f <vector24>:
.globl vector24
vector24:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $24
80106061:	6a 18                	push   $0x18
  jmp alltraps
80106063:	e9 1d fa ff ff       	jmp    80105a85 <alltraps>

80106068 <vector25>:
.globl vector25
vector25:
  pushl $0
80106068:	6a 00                	push   $0x0
  pushl $25
8010606a:	6a 19                	push   $0x19
  jmp alltraps
8010606c:	e9 14 fa ff ff       	jmp    80105a85 <alltraps>

80106071 <vector26>:
.globl vector26
vector26:
  pushl $0
80106071:	6a 00                	push   $0x0
  pushl $26
80106073:	6a 1a                	push   $0x1a
  jmp alltraps
80106075:	e9 0b fa ff ff       	jmp    80105a85 <alltraps>

8010607a <vector27>:
.globl vector27
vector27:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $27
8010607c:	6a 1b                	push   $0x1b
  jmp alltraps
8010607e:	e9 02 fa ff ff       	jmp    80105a85 <alltraps>

80106083 <vector28>:
.globl vector28
vector28:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $28
80106085:	6a 1c                	push   $0x1c
  jmp alltraps
80106087:	e9 f9 f9 ff ff       	jmp    80105a85 <alltraps>

8010608c <vector29>:
.globl vector29
vector29:
  pushl $0
8010608c:	6a 00                	push   $0x0
  pushl $29
8010608e:	6a 1d                	push   $0x1d
  jmp alltraps
80106090:	e9 f0 f9 ff ff       	jmp    80105a85 <alltraps>

80106095 <vector30>:
.globl vector30
vector30:
  pushl $0
80106095:	6a 00                	push   $0x0
  pushl $30
80106097:	6a 1e                	push   $0x1e
  jmp alltraps
80106099:	e9 e7 f9 ff ff       	jmp    80105a85 <alltraps>

8010609e <vector31>:
.globl vector31
vector31:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $31
801060a0:	6a 1f                	push   $0x1f
  jmp alltraps
801060a2:	e9 de f9 ff ff       	jmp    80105a85 <alltraps>

801060a7 <vector32>:
.globl vector32
vector32:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $32
801060a9:	6a 20                	push   $0x20
  jmp alltraps
801060ab:	e9 d5 f9 ff ff       	jmp    80105a85 <alltraps>

801060b0 <vector33>:
.globl vector33
vector33:
  pushl $0
801060b0:	6a 00                	push   $0x0
  pushl $33
801060b2:	6a 21                	push   $0x21
  jmp alltraps
801060b4:	e9 cc f9 ff ff       	jmp    80105a85 <alltraps>

801060b9 <vector34>:
.globl vector34
vector34:
  pushl $0
801060b9:	6a 00                	push   $0x0
  pushl $34
801060bb:	6a 22                	push   $0x22
  jmp alltraps
801060bd:	e9 c3 f9 ff ff       	jmp    80105a85 <alltraps>

801060c2 <vector35>:
.globl vector35
vector35:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $35
801060c4:	6a 23                	push   $0x23
  jmp alltraps
801060c6:	e9 ba f9 ff ff       	jmp    80105a85 <alltraps>

801060cb <vector36>:
.globl vector36
vector36:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $36
801060cd:	6a 24                	push   $0x24
  jmp alltraps
801060cf:	e9 b1 f9 ff ff       	jmp    80105a85 <alltraps>

801060d4 <vector37>:
.globl vector37
vector37:
  pushl $0
801060d4:	6a 00                	push   $0x0
  pushl $37
801060d6:	6a 25                	push   $0x25
  jmp alltraps
801060d8:	e9 a8 f9 ff ff       	jmp    80105a85 <alltraps>

801060dd <vector38>:
.globl vector38
vector38:
  pushl $0
801060dd:	6a 00                	push   $0x0
  pushl $38
801060df:	6a 26                	push   $0x26
  jmp alltraps
801060e1:	e9 9f f9 ff ff       	jmp    80105a85 <alltraps>

801060e6 <vector39>:
.globl vector39
vector39:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $39
801060e8:	6a 27                	push   $0x27
  jmp alltraps
801060ea:	e9 96 f9 ff ff       	jmp    80105a85 <alltraps>

801060ef <vector40>:
.globl vector40
vector40:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $40
801060f1:	6a 28                	push   $0x28
  jmp alltraps
801060f3:	e9 8d f9 ff ff       	jmp    80105a85 <alltraps>

801060f8 <vector41>:
.globl vector41
vector41:
  pushl $0
801060f8:	6a 00                	push   $0x0
  pushl $41
801060fa:	6a 29                	push   $0x29
  jmp alltraps
801060fc:	e9 84 f9 ff ff       	jmp    80105a85 <alltraps>

80106101 <vector42>:
.globl vector42
vector42:
  pushl $0
80106101:	6a 00                	push   $0x0
  pushl $42
80106103:	6a 2a                	push   $0x2a
  jmp alltraps
80106105:	e9 7b f9 ff ff       	jmp    80105a85 <alltraps>

8010610a <vector43>:
.globl vector43
vector43:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $43
8010610c:	6a 2b                	push   $0x2b
  jmp alltraps
8010610e:	e9 72 f9 ff ff       	jmp    80105a85 <alltraps>

80106113 <vector44>:
.globl vector44
vector44:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $44
80106115:	6a 2c                	push   $0x2c
  jmp alltraps
80106117:	e9 69 f9 ff ff       	jmp    80105a85 <alltraps>

8010611c <vector45>:
.globl vector45
vector45:
  pushl $0
8010611c:	6a 00                	push   $0x0
  pushl $45
8010611e:	6a 2d                	push   $0x2d
  jmp alltraps
80106120:	e9 60 f9 ff ff       	jmp    80105a85 <alltraps>

80106125 <vector46>:
.globl vector46
vector46:
  pushl $0
80106125:	6a 00                	push   $0x0
  pushl $46
80106127:	6a 2e                	push   $0x2e
  jmp alltraps
80106129:	e9 57 f9 ff ff       	jmp    80105a85 <alltraps>

8010612e <vector47>:
.globl vector47
vector47:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $47
80106130:	6a 2f                	push   $0x2f
  jmp alltraps
80106132:	e9 4e f9 ff ff       	jmp    80105a85 <alltraps>

80106137 <vector48>:
.globl vector48
vector48:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $48
80106139:	6a 30                	push   $0x30
  jmp alltraps
8010613b:	e9 45 f9 ff ff       	jmp    80105a85 <alltraps>

80106140 <vector49>:
.globl vector49
vector49:
  pushl $0
80106140:	6a 00                	push   $0x0
  pushl $49
80106142:	6a 31                	push   $0x31
  jmp alltraps
80106144:	e9 3c f9 ff ff       	jmp    80105a85 <alltraps>

80106149 <vector50>:
.globl vector50
vector50:
  pushl $0
80106149:	6a 00                	push   $0x0
  pushl $50
8010614b:	6a 32                	push   $0x32
  jmp alltraps
8010614d:	e9 33 f9 ff ff       	jmp    80105a85 <alltraps>

80106152 <vector51>:
.globl vector51
vector51:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $51
80106154:	6a 33                	push   $0x33
  jmp alltraps
80106156:	e9 2a f9 ff ff       	jmp    80105a85 <alltraps>

8010615b <vector52>:
.globl vector52
vector52:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $52
8010615d:	6a 34                	push   $0x34
  jmp alltraps
8010615f:	e9 21 f9 ff ff       	jmp    80105a85 <alltraps>

80106164 <vector53>:
.globl vector53
vector53:
  pushl $0
80106164:	6a 00                	push   $0x0
  pushl $53
80106166:	6a 35                	push   $0x35
  jmp alltraps
80106168:	e9 18 f9 ff ff       	jmp    80105a85 <alltraps>

8010616d <vector54>:
.globl vector54
vector54:
  pushl $0
8010616d:	6a 00                	push   $0x0
  pushl $54
8010616f:	6a 36                	push   $0x36
  jmp alltraps
80106171:	e9 0f f9 ff ff       	jmp    80105a85 <alltraps>

80106176 <vector55>:
.globl vector55
vector55:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $55
80106178:	6a 37                	push   $0x37
  jmp alltraps
8010617a:	e9 06 f9 ff ff       	jmp    80105a85 <alltraps>

8010617f <vector56>:
.globl vector56
vector56:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $56
80106181:	6a 38                	push   $0x38
  jmp alltraps
80106183:	e9 fd f8 ff ff       	jmp    80105a85 <alltraps>

80106188 <vector57>:
.globl vector57
vector57:
  pushl $0
80106188:	6a 00                	push   $0x0
  pushl $57
8010618a:	6a 39                	push   $0x39
  jmp alltraps
8010618c:	e9 f4 f8 ff ff       	jmp    80105a85 <alltraps>

80106191 <vector58>:
.globl vector58
vector58:
  pushl $0
80106191:	6a 00                	push   $0x0
  pushl $58
80106193:	6a 3a                	push   $0x3a
  jmp alltraps
80106195:	e9 eb f8 ff ff       	jmp    80105a85 <alltraps>

8010619a <vector59>:
.globl vector59
vector59:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $59
8010619c:	6a 3b                	push   $0x3b
  jmp alltraps
8010619e:	e9 e2 f8 ff ff       	jmp    80105a85 <alltraps>

801061a3 <vector60>:
.globl vector60
vector60:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $60
801061a5:	6a 3c                	push   $0x3c
  jmp alltraps
801061a7:	e9 d9 f8 ff ff       	jmp    80105a85 <alltraps>

801061ac <vector61>:
.globl vector61
vector61:
  pushl $0
801061ac:	6a 00                	push   $0x0
  pushl $61
801061ae:	6a 3d                	push   $0x3d
  jmp alltraps
801061b0:	e9 d0 f8 ff ff       	jmp    80105a85 <alltraps>

801061b5 <vector62>:
.globl vector62
vector62:
  pushl $0
801061b5:	6a 00                	push   $0x0
  pushl $62
801061b7:	6a 3e                	push   $0x3e
  jmp alltraps
801061b9:	e9 c7 f8 ff ff       	jmp    80105a85 <alltraps>

801061be <vector63>:
.globl vector63
vector63:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $63
801061c0:	6a 3f                	push   $0x3f
  jmp alltraps
801061c2:	e9 be f8 ff ff       	jmp    80105a85 <alltraps>

801061c7 <vector64>:
.globl vector64
vector64:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $64
801061c9:	6a 40                	push   $0x40
  jmp alltraps
801061cb:	e9 b5 f8 ff ff       	jmp    80105a85 <alltraps>

801061d0 <vector65>:
.globl vector65
vector65:
  pushl $0
801061d0:	6a 00                	push   $0x0
  pushl $65
801061d2:	6a 41                	push   $0x41
  jmp alltraps
801061d4:	e9 ac f8 ff ff       	jmp    80105a85 <alltraps>

801061d9 <vector66>:
.globl vector66
vector66:
  pushl $0
801061d9:	6a 00                	push   $0x0
  pushl $66
801061db:	6a 42                	push   $0x42
  jmp alltraps
801061dd:	e9 a3 f8 ff ff       	jmp    80105a85 <alltraps>

801061e2 <vector67>:
.globl vector67
vector67:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $67
801061e4:	6a 43                	push   $0x43
  jmp alltraps
801061e6:	e9 9a f8 ff ff       	jmp    80105a85 <alltraps>

801061eb <vector68>:
.globl vector68
vector68:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $68
801061ed:	6a 44                	push   $0x44
  jmp alltraps
801061ef:	e9 91 f8 ff ff       	jmp    80105a85 <alltraps>

801061f4 <vector69>:
.globl vector69
vector69:
  pushl $0
801061f4:	6a 00                	push   $0x0
  pushl $69
801061f6:	6a 45                	push   $0x45
  jmp alltraps
801061f8:	e9 88 f8 ff ff       	jmp    80105a85 <alltraps>

801061fd <vector70>:
.globl vector70
vector70:
  pushl $0
801061fd:	6a 00                	push   $0x0
  pushl $70
801061ff:	6a 46                	push   $0x46
  jmp alltraps
80106201:	e9 7f f8 ff ff       	jmp    80105a85 <alltraps>

80106206 <vector71>:
.globl vector71
vector71:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $71
80106208:	6a 47                	push   $0x47
  jmp alltraps
8010620a:	e9 76 f8 ff ff       	jmp    80105a85 <alltraps>

8010620f <vector72>:
.globl vector72
vector72:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $72
80106211:	6a 48                	push   $0x48
  jmp alltraps
80106213:	e9 6d f8 ff ff       	jmp    80105a85 <alltraps>

80106218 <vector73>:
.globl vector73
vector73:
  pushl $0
80106218:	6a 00                	push   $0x0
  pushl $73
8010621a:	6a 49                	push   $0x49
  jmp alltraps
8010621c:	e9 64 f8 ff ff       	jmp    80105a85 <alltraps>

80106221 <vector74>:
.globl vector74
vector74:
  pushl $0
80106221:	6a 00                	push   $0x0
  pushl $74
80106223:	6a 4a                	push   $0x4a
  jmp alltraps
80106225:	e9 5b f8 ff ff       	jmp    80105a85 <alltraps>

8010622a <vector75>:
.globl vector75
vector75:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $75
8010622c:	6a 4b                	push   $0x4b
  jmp alltraps
8010622e:	e9 52 f8 ff ff       	jmp    80105a85 <alltraps>

80106233 <vector76>:
.globl vector76
vector76:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $76
80106235:	6a 4c                	push   $0x4c
  jmp alltraps
80106237:	e9 49 f8 ff ff       	jmp    80105a85 <alltraps>

8010623c <vector77>:
.globl vector77
vector77:
  pushl $0
8010623c:	6a 00                	push   $0x0
  pushl $77
8010623e:	6a 4d                	push   $0x4d
  jmp alltraps
80106240:	e9 40 f8 ff ff       	jmp    80105a85 <alltraps>

80106245 <vector78>:
.globl vector78
vector78:
  pushl $0
80106245:	6a 00                	push   $0x0
  pushl $78
80106247:	6a 4e                	push   $0x4e
  jmp alltraps
80106249:	e9 37 f8 ff ff       	jmp    80105a85 <alltraps>

8010624e <vector79>:
.globl vector79
vector79:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $79
80106250:	6a 4f                	push   $0x4f
  jmp alltraps
80106252:	e9 2e f8 ff ff       	jmp    80105a85 <alltraps>

80106257 <vector80>:
.globl vector80
vector80:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $80
80106259:	6a 50                	push   $0x50
  jmp alltraps
8010625b:	e9 25 f8 ff ff       	jmp    80105a85 <alltraps>

80106260 <vector81>:
.globl vector81
vector81:
  pushl $0
80106260:	6a 00                	push   $0x0
  pushl $81
80106262:	6a 51                	push   $0x51
  jmp alltraps
80106264:	e9 1c f8 ff ff       	jmp    80105a85 <alltraps>

80106269 <vector82>:
.globl vector82
vector82:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $82
8010626b:	6a 52                	push   $0x52
  jmp alltraps
8010626d:	e9 13 f8 ff ff       	jmp    80105a85 <alltraps>

80106272 <vector83>:
.globl vector83
vector83:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $83
80106274:	6a 53                	push   $0x53
  jmp alltraps
80106276:	e9 0a f8 ff ff       	jmp    80105a85 <alltraps>

8010627b <vector84>:
.globl vector84
vector84:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $84
8010627d:	6a 54                	push   $0x54
  jmp alltraps
8010627f:	e9 01 f8 ff ff       	jmp    80105a85 <alltraps>

80106284 <vector85>:
.globl vector85
vector85:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $85
80106286:	6a 55                	push   $0x55
  jmp alltraps
80106288:	e9 f8 f7 ff ff       	jmp    80105a85 <alltraps>

8010628d <vector86>:
.globl vector86
vector86:
  pushl $0
8010628d:	6a 00                	push   $0x0
  pushl $86
8010628f:	6a 56                	push   $0x56
  jmp alltraps
80106291:	e9 ef f7 ff ff       	jmp    80105a85 <alltraps>

80106296 <vector87>:
.globl vector87
vector87:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $87
80106298:	6a 57                	push   $0x57
  jmp alltraps
8010629a:	e9 e6 f7 ff ff       	jmp    80105a85 <alltraps>

8010629f <vector88>:
.globl vector88
vector88:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $88
801062a1:	6a 58                	push   $0x58
  jmp alltraps
801062a3:	e9 dd f7 ff ff       	jmp    80105a85 <alltraps>

801062a8 <vector89>:
.globl vector89
vector89:
  pushl $0
801062a8:	6a 00                	push   $0x0
  pushl $89
801062aa:	6a 59                	push   $0x59
  jmp alltraps
801062ac:	e9 d4 f7 ff ff       	jmp    80105a85 <alltraps>

801062b1 <vector90>:
.globl vector90
vector90:
  pushl $0
801062b1:	6a 00                	push   $0x0
  pushl $90
801062b3:	6a 5a                	push   $0x5a
  jmp alltraps
801062b5:	e9 cb f7 ff ff       	jmp    80105a85 <alltraps>

801062ba <vector91>:
.globl vector91
vector91:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $91
801062bc:	6a 5b                	push   $0x5b
  jmp alltraps
801062be:	e9 c2 f7 ff ff       	jmp    80105a85 <alltraps>

801062c3 <vector92>:
.globl vector92
vector92:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $92
801062c5:	6a 5c                	push   $0x5c
  jmp alltraps
801062c7:	e9 b9 f7 ff ff       	jmp    80105a85 <alltraps>

801062cc <vector93>:
.globl vector93
vector93:
  pushl $0
801062cc:	6a 00                	push   $0x0
  pushl $93
801062ce:	6a 5d                	push   $0x5d
  jmp alltraps
801062d0:	e9 b0 f7 ff ff       	jmp    80105a85 <alltraps>

801062d5 <vector94>:
.globl vector94
vector94:
  pushl $0
801062d5:	6a 00                	push   $0x0
  pushl $94
801062d7:	6a 5e                	push   $0x5e
  jmp alltraps
801062d9:	e9 a7 f7 ff ff       	jmp    80105a85 <alltraps>

801062de <vector95>:
.globl vector95
vector95:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $95
801062e0:	6a 5f                	push   $0x5f
  jmp alltraps
801062e2:	e9 9e f7 ff ff       	jmp    80105a85 <alltraps>

801062e7 <vector96>:
.globl vector96
vector96:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $96
801062e9:	6a 60                	push   $0x60
  jmp alltraps
801062eb:	e9 95 f7 ff ff       	jmp    80105a85 <alltraps>

801062f0 <vector97>:
.globl vector97
vector97:
  pushl $0
801062f0:	6a 00                	push   $0x0
  pushl $97
801062f2:	6a 61                	push   $0x61
  jmp alltraps
801062f4:	e9 8c f7 ff ff       	jmp    80105a85 <alltraps>

801062f9 <vector98>:
.globl vector98
vector98:
  pushl $0
801062f9:	6a 00                	push   $0x0
  pushl $98
801062fb:	6a 62                	push   $0x62
  jmp alltraps
801062fd:	e9 83 f7 ff ff       	jmp    80105a85 <alltraps>

80106302 <vector99>:
.globl vector99
vector99:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $99
80106304:	6a 63                	push   $0x63
  jmp alltraps
80106306:	e9 7a f7 ff ff       	jmp    80105a85 <alltraps>

8010630b <vector100>:
.globl vector100
vector100:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $100
8010630d:	6a 64                	push   $0x64
  jmp alltraps
8010630f:	e9 71 f7 ff ff       	jmp    80105a85 <alltraps>

80106314 <vector101>:
.globl vector101
vector101:
  pushl $0
80106314:	6a 00                	push   $0x0
  pushl $101
80106316:	6a 65                	push   $0x65
  jmp alltraps
80106318:	e9 68 f7 ff ff       	jmp    80105a85 <alltraps>

8010631d <vector102>:
.globl vector102
vector102:
  pushl $0
8010631d:	6a 00                	push   $0x0
  pushl $102
8010631f:	6a 66                	push   $0x66
  jmp alltraps
80106321:	e9 5f f7 ff ff       	jmp    80105a85 <alltraps>

80106326 <vector103>:
.globl vector103
vector103:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $103
80106328:	6a 67                	push   $0x67
  jmp alltraps
8010632a:	e9 56 f7 ff ff       	jmp    80105a85 <alltraps>

8010632f <vector104>:
.globl vector104
vector104:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $104
80106331:	6a 68                	push   $0x68
  jmp alltraps
80106333:	e9 4d f7 ff ff       	jmp    80105a85 <alltraps>

80106338 <vector105>:
.globl vector105
vector105:
  pushl $0
80106338:	6a 00                	push   $0x0
  pushl $105
8010633a:	6a 69                	push   $0x69
  jmp alltraps
8010633c:	e9 44 f7 ff ff       	jmp    80105a85 <alltraps>

80106341 <vector106>:
.globl vector106
vector106:
  pushl $0
80106341:	6a 00                	push   $0x0
  pushl $106
80106343:	6a 6a                	push   $0x6a
  jmp alltraps
80106345:	e9 3b f7 ff ff       	jmp    80105a85 <alltraps>

8010634a <vector107>:
.globl vector107
vector107:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $107
8010634c:	6a 6b                	push   $0x6b
  jmp alltraps
8010634e:	e9 32 f7 ff ff       	jmp    80105a85 <alltraps>

80106353 <vector108>:
.globl vector108
vector108:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $108
80106355:	6a 6c                	push   $0x6c
  jmp alltraps
80106357:	e9 29 f7 ff ff       	jmp    80105a85 <alltraps>

8010635c <vector109>:
.globl vector109
vector109:
  pushl $0
8010635c:	6a 00                	push   $0x0
  pushl $109
8010635e:	6a 6d                	push   $0x6d
  jmp alltraps
80106360:	e9 20 f7 ff ff       	jmp    80105a85 <alltraps>

80106365 <vector110>:
.globl vector110
vector110:
  pushl $0
80106365:	6a 00                	push   $0x0
  pushl $110
80106367:	6a 6e                	push   $0x6e
  jmp alltraps
80106369:	e9 17 f7 ff ff       	jmp    80105a85 <alltraps>

8010636e <vector111>:
.globl vector111
vector111:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $111
80106370:	6a 6f                	push   $0x6f
  jmp alltraps
80106372:	e9 0e f7 ff ff       	jmp    80105a85 <alltraps>

80106377 <vector112>:
.globl vector112
vector112:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $112
80106379:	6a 70                	push   $0x70
  jmp alltraps
8010637b:	e9 05 f7 ff ff       	jmp    80105a85 <alltraps>

80106380 <vector113>:
.globl vector113
vector113:
  pushl $0
80106380:	6a 00                	push   $0x0
  pushl $113
80106382:	6a 71                	push   $0x71
  jmp alltraps
80106384:	e9 fc f6 ff ff       	jmp    80105a85 <alltraps>

80106389 <vector114>:
.globl vector114
vector114:
  pushl $0
80106389:	6a 00                	push   $0x0
  pushl $114
8010638b:	6a 72                	push   $0x72
  jmp alltraps
8010638d:	e9 f3 f6 ff ff       	jmp    80105a85 <alltraps>

80106392 <vector115>:
.globl vector115
vector115:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $115
80106394:	6a 73                	push   $0x73
  jmp alltraps
80106396:	e9 ea f6 ff ff       	jmp    80105a85 <alltraps>

8010639b <vector116>:
.globl vector116
vector116:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $116
8010639d:	6a 74                	push   $0x74
  jmp alltraps
8010639f:	e9 e1 f6 ff ff       	jmp    80105a85 <alltraps>

801063a4 <vector117>:
.globl vector117
vector117:
  pushl $0
801063a4:	6a 00                	push   $0x0
  pushl $117
801063a6:	6a 75                	push   $0x75
  jmp alltraps
801063a8:	e9 d8 f6 ff ff       	jmp    80105a85 <alltraps>

801063ad <vector118>:
.globl vector118
vector118:
  pushl $0
801063ad:	6a 00                	push   $0x0
  pushl $118
801063af:	6a 76                	push   $0x76
  jmp alltraps
801063b1:	e9 cf f6 ff ff       	jmp    80105a85 <alltraps>

801063b6 <vector119>:
.globl vector119
vector119:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $119
801063b8:	6a 77                	push   $0x77
  jmp alltraps
801063ba:	e9 c6 f6 ff ff       	jmp    80105a85 <alltraps>

801063bf <vector120>:
.globl vector120
vector120:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $120
801063c1:	6a 78                	push   $0x78
  jmp alltraps
801063c3:	e9 bd f6 ff ff       	jmp    80105a85 <alltraps>

801063c8 <vector121>:
.globl vector121
vector121:
  pushl $0
801063c8:	6a 00                	push   $0x0
  pushl $121
801063ca:	6a 79                	push   $0x79
  jmp alltraps
801063cc:	e9 b4 f6 ff ff       	jmp    80105a85 <alltraps>

801063d1 <vector122>:
.globl vector122
vector122:
  pushl $0
801063d1:	6a 00                	push   $0x0
  pushl $122
801063d3:	6a 7a                	push   $0x7a
  jmp alltraps
801063d5:	e9 ab f6 ff ff       	jmp    80105a85 <alltraps>

801063da <vector123>:
.globl vector123
vector123:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $123
801063dc:	6a 7b                	push   $0x7b
  jmp alltraps
801063de:	e9 a2 f6 ff ff       	jmp    80105a85 <alltraps>

801063e3 <vector124>:
.globl vector124
vector124:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $124
801063e5:	6a 7c                	push   $0x7c
  jmp alltraps
801063e7:	e9 99 f6 ff ff       	jmp    80105a85 <alltraps>

801063ec <vector125>:
.globl vector125
vector125:
  pushl $0
801063ec:	6a 00                	push   $0x0
  pushl $125
801063ee:	6a 7d                	push   $0x7d
  jmp alltraps
801063f0:	e9 90 f6 ff ff       	jmp    80105a85 <alltraps>

801063f5 <vector126>:
.globl vector126
vector126:
  pushl $0
801063f5:	6a 00                	push   $0x0
  pushl $126
801063f7:	6a 7e                	push   $0x7e
  jmp alltraps
801063f9:	e9 87 f6 ff ff       	jmp    80105a85 <alltraps>

801063fe <vector127>:
.globl vector127
vector127:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $127
80106400:	6a 7f                	push   $0x7f
  jmp alltraps
80106402:	e9 7e f6 ff ff       	jmp    80105a85 <alltraps>

80106407 <vector128>:
.globl vector128
vector128:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $128
80106409:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010640e:	e9 72 f6 ff ff       	jmp    80105a85 <alltraps>

80106413 <vector129>:
.globl vector129
vector129:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $129
80106415:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010641a:	e9 66 f6 ff ff       	jmp    80105a85 <alltraps>

8010641f <vector130>:
.globl vector130
vector130:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $130
80106421:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106426:	e9 5a f6 ff ff       	jmp    80105a85 <alltraps>

8010642b <vector131>:
.globl vector131
vector131:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $131
8010642d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106432:	e9 4e f6 ff ff       	jmp    80105a85 <alltraps>

80106437 <vector132>:
.globl vector132
vector132:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $132
80106439:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010643e:	e9 42 f6 ff ff       	jmp    80105a85 <alltraps>

80106443 <vector133>:
.globl vector133
vector133:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $133
80106445:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010644a:	e9 36 f6 ff ff       	jmp    80105a85 <alltraps>

8010644f <vector134>:
.globl vector134
vector134:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $134
80106451:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106456:	e9 2a f6 ff ff       	jmp    80105a85 <alltraps>

8010645b <vector135>:
.globl vector135
vector135:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $135
8010645d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106462:	e9 1e f6 ff ff       	jmp    80105a85 <alltraps>

80106467 <vector136>:
.globl vector136
vector136:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $136
80106469:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010646e:	e9 12 f6 ff ff       	jmp    80105a85 <alltraps>

80106473 <vector137>:
.globl vector137
vector137:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $137
80106475:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010647a:	e9 06 f6 ff ff       	jmp    80105a85 <alltraps>

8010647f <vector138>:
.globl vector138
vector138:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $138
80106481:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106486:	e9 fa f5 ff ff       	jmp    80105a85 <alltraps>

8010648b <vector139>:
.globl vector139
vector139:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $139
8010648d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106492:	e9 ee f5 ff ff       	jmp    80105a85 <alltraps>

80106497 <vector140>:
.globl vector140
vector140:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $140
80106499:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010649e:	e9 e2 f5 ff ff       	jmp    80105a85 <alltraps>

801064a3 <vector141>:
.globl vector141
vector141:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $141
801064a5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801064aa:	e9 d6 f5 ff ff       	jmp    80105a85 <alltraps>

801064af <vector142>:
.globl vector142
vector142:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $142
801064b1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801064b6:	e9 ca f5 ff ff       	jmp    80105a85 <alltraps>

801064bb <vector143>:
.globl vector143
vector143:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $143
801064bd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801064c2:	e9 be f5 ff ff       	jmp    80105a85 <alltraps>

801064c7 <vector144>:
.globl vector144
vector144:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $144
801064c9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801064ce:	e9 b2 f5 ff ff       	jmp    80105a85 <alltraps>

801064d3 <vector145>:
.globl vector145
vector145:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $145
801064d5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801064da:	e9 a6 f5 ff ff       	jmp    80105a85 <alltraps>

801064df <vector146>:
.globl vector146
vector146:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $146
801064e1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801064e6:	e9 9a f5 ff ff       	jmp    80105a85 <alltraps>

801064eb <vector147>:
.globl vector147
vector147:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $147
801064ed:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801064f2:	e9 8e f5 ff ff       	jmp    80105a85 <alltraps>

801064f7 <vector148>:
.globl vector148
vector148:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $148
801064f9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801064fe:	e9 82 f5 ff ff       	jmp    80105a85 <alltraps>

80106503 <vector149>:
.globl vector149
vector149:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $149
80106505:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010650a:	e9 76 f5 ff ff       	jmp    80105a85 <alltraps>

8010650f <vector150>:
.globl vector150
vector150:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $150
80106511:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106516:	e9 6a f5 ff ff       	jmp    80105a85 <alltraps>

8010651b <vector151>:
.globl vector151
vector151:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $151
8010651d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106522:	e9 5e f5 ff ff       	jmp    80105a85 <alltraps>

80106527 <vector152>:
.globl vector152
vector152:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $152
80106529:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010652e:	e9 52 f5 ff ff       	jmp    80105a85 <alltraps>

80106533 <vector153>:
.globl vector153
vector153:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $153
80106535:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010653a:	e9 46 f5 ff ff       	jmp    80105a85 <alltraps>

8010653f <vector154>:
.globl vector154
vector154:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $154
80106541:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106546:	e9 3a f5 ff ff       	jmp    80105a85 <alltraps>

8010654b <vector155>:
.globl vector155
vector155:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $155
8010654d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106552:	e9 2e f5 ff ff       	jmp    80105a85 <alltraps>

80106557 <vector156>:
.globl vector156
vector156:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $156
80106559:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010655e:	e9 22 f5 ff ff       	jmp    80105a85 <alltraps>

80106563 <vector157>:
.globl vector157
vector157:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $157
80106565:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010656a:	e9 16 f5 ff ff       	jmp    80105a85 <alltraps>

8010656f <vector158>:
.globl vector158
vector158:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $158
80106571:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106576:	e9 0a f5 ff ff       	jmp    80105a85 <alltraps>

8010657b <vector159>:
.globl vector159
vector159:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $159
8010657d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106582:	e9 fe f4 ff ff       	jmp    80105a85 <alltraps>

80106587 <vector160>:
.globl vector160
vector160:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $160
80106589:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010658e:	e9 f2 f4 ff ff       	jmp    80105a85 <alltraps>

80106593 <vector161>:
.globl vector161
vector161:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $161
80106595:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010659a:	e9 e6 f4 ff ff       	jmp    80105a85 <alltraps>

8010659f <vector162>:
.globl vector162
vector162:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $162
801065a1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801065a6:	e9 da f4 ff ff       	jmp    80105a85 <alltraps>

801065ab <vector163>:
.globl vector163
vector163:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $163
801065ad:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801065b2:	e9 ce f4 ff ff       	jmp    80105a85 <alltraps>

801065b7 <vector164>:
.globl vector164
vector164:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $164
801065b9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801065be:	e9 c2 f4 ff ff       	jmp    80105a85 <alltraps>

801065c3 <vector165>:
.globl vector165
vector165:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $165
801065c5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801065ca:	e9 b6 f4 ff ff       	jmp    80105a85 <alltraps>

801065cf <vector166>:
.globl vector166
vector166:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $166
801065d1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801065d6:	e9 aa f4 ff ff       	jmp    80105a85 <alltraps>

801065db <vector167>:
.globl vector167
vector167:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $167
801065dd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801065e2:	e9 9e f4 ff ff       	jmp    80105a85 <alltraps>

801065e7 <vector168>:
.globl vector168
vector168:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $168
801065e9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801065ee:	e9 92 f4 ff ff       	jmp    80105a85 <alltraps>

801065f3 <vector169>:
.globl vector169
vector169:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $169
801065f5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801065fa:	e9 86 f4 ff ff       	jmp    80105a85 <alltraps>

801065ff <vector170>:
.globl vector170
vector170:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $170
80106601:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106606:	e9 7a f4 ff ff       	jmp    80105a85 <alltraps>

8010660b <vector171>:
.globl vector171
vector171:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $171
8010660d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106612:	e9 6e f4 ff ff       	jmp    80105a85 <alltraps>

80106617 <vector172>:
.globl vector172
vector172:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $172
80106619:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010661e:	e9 62 f4 ff ff       	jmp    80105a85 <alltraps>

80106623 <vector173>:
.globl vector173
vector173:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $173
80106625:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010662a:	e9 56 f4 ff ff       	jmp    80105a85 <alltraps>

8010662f <vector174>:
.globl vector174
vector174:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $174
80106631:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106636:	e9 4a f4 ff ff       	jmp    80105a85 <alltraps>

8010663b <vector175>:
.globl vector175
vector175:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $175
8010663d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106642:	e9 3e f4 ff ff       	jmp    80105a85 <alltraps>

80106647 <vector176>:
.globl vector176
vector176:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $176
80106649:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010664e:	e9 32 f4 ff ff       	jmp    80105a85 <alltraps>

80106653 <vector177>:
.globl vector177
vector177:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $177
80106655:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010665a:	e9 26 f4 ff ff       	jmp    80105a85 <alltraps>

8010665f <vector178>:
.globl vector178
vector178:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $178
80106661:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106666:	e9 1a f4 ff ff       	jmp    80105a85 <alltraps>

8010666b <vector179>:
.globl vector179
vector179:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $179
8010666d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106672:	e9 0e f4 ff ff       	jmp    80105a85 <alltraps>

80106677 <vector180>:
.globl vector180
vector180:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $180
80106679:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010667e:	e9 02 f4 ff ff       	jmp    80105a85 <alltraps>

80106683 <vector181>:
.globl vector181
vector181:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $181
80106685:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010668a:	e9 f6 f3 ff ff       	jmp    80105a85 <alltraps>

8010668f <vector182>:
.globl vector182
vector182:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $182
80106691:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106696:	e9 ea f3 ff ff       	jmp    80105a85 <alltraps>

8010669b <vector183>:
.globl vector183
vector183:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $183
8010669d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801066a2:	e9 de f3 ff ff       	jmp    80105a85 <alltraps>

801066a7 <vector184>:
.globl vector184
vector184:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $184
801066a9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801066ae:	e9 d2 f3 ff ff       	jmp    80105a85 <alltraps>

801066b3 <vector185>:
.globl vector185
vector185:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $185
801066b5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801066ba:	e9 c6 f3 ff ff       	jmp    80105a85 <alltraps>

801066bf <vector186>:
.globl vector186
vector186:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $186
801066c1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801066c6:	e9 ba f3 ff ff       	jmp    80105a85 <alltraps>

801066cb <vector187>:
.globl vector187
vector187:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $187
801066cd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801066d2:	e9 ae f3 ff ff       	jmp    80105a85 <alltraps>

801066d7 <vector188>:
.globl vector188
vector188:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $188
801066d9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801066de:	e9 a2 f3 ff ff       	jmp    80105a85 <alltraps>

801066e3 <vector189>:
.globl vector189
vector189:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $189
801066e5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801066ea:	e9 96 f3 ff ff       	jmp    80105a85 <alltraps>

801066ef <vector190>:
.globl vector190
vector190:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $190
801066f1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801066f6:	e9 8a f3 ff ff       	jmp    80105a85 <alltraps>

801066fb <vector191>:
.globl vector191
vector191:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $191
801066fd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106702:	e9 7e f3 ff ff       	jmp    80105a85 <alltraps>

80106707 <vector192>:
.globl vector192
vector192:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $192
80106709:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010670e:	e9 72 f3 ff ff       	jmp    80105a85 <alltraps>

80106713 <vector193>:
.globl vector193
vector193:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $193
80106715:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010671a:	e9 66 f3 ff ff       	jmp    80105a85 <alltraps>

8010671f <vector194>:
.globl vector194
vector194:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $194
80106721:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106726:	e9 5a f3 ff ff       	jmp    80105a85 <alltraps>

8010672b <vector195>:
.globl vector195
vector195:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $195
8010672d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106732:	e9 4e f3 ff ff       	jmp    80105a85 <alltraps>

80106737 <vector196>:
.globl vector196
vector196:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $196
80106739:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010673e:	e9 42 f3 ff ff       	jmp    80105a85 <alltraps>

80106743 <vector197>:
.globl vector197
vector197:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $197
80106745:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010674a:	e9 36 f3 ff ff       	jmp    80105a85 <alltraps>

8010674f <vector198>:
.globl vector198
vector198:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $198
80106751:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106756:	e9 2a f3 ff ff       	jmp    80105a85 <alltraps>

8010675b <vector199>:
.globl vector199
vector199:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $199
8010675d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106762:	e9 1e f3 ff ff       	jmp    80105a85 <alltraps>

80106767 <vector200>:
.globl vector200
vector200:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $200
80106769:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010676e:	e9 12 f3 ff ff       	jmp    80105a85 <alltraps>

80106773 <vector201>:
.globl vector201
vector201:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $201
80106775:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010677a:	e9 06 f3 ff ff       	jmp    80105a85 <alltraps>

8010677f <vector202>:
.globl vector202
vector202:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $202
80106781:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106786:	e9 fa f2 ff ff       	jmp    80105a85 <alltraps>

8010678b <vector203>:
.globl vector203
vector203:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $203
8010678d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106792:	e9 ee f2 ff ff       	jmp    80105a85 <alltraps>

80106797 <vector204>:
.globl vector204
vector204:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $204
80106799:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010679e:	e9 e2 f2 ff ff       	jmp    80105a85 <alltraps>

801067a3 <vector205>:
.globl vector205
vector205:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $205
801067a5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801067aa:	e9 d6 f2 ff ff       	jmp    80105a85 <alltraps>

801067af <vector206>:
.globl vector206
vector206:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $206
801067b1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801067b6:	e9 ca f2 ff ff       	jmp    80105a85 <alltraps>

801067bb <vector207>:
.globl vector207
vector207:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $207
801067bd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801067c2:	e9 be f2 ff ff       	jmp    80105a85 <alltraps>

801067c7 <vector208>:
.globl vector208
vector208:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $208
801067c9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801067ce:	e9 b2 f2 ff ff       	jmp    80105a85 <alltraps>

801067d3 <vector209>:
.globl vector209
vector209:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $209
801067d5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801067da:	e9 a6 f2 ff ff       	jmp    80105a85 <alltraps>

801067df <vector210>:
.globl vector210
vector210:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $210
801067e1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801067e6:	e9 9a f2 ff ff       	jmp    80105a85 <alltraps>

801067eb <vector211>:
.globl vector211
vector211:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $211
801067ed:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801067f2:	e9 8e f2 ff ff       	jmp    80105a85 <alltraps>

801067f7 <vector212>:
.globl vector212
vector212:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $212
801067f9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801067fe:	e9 82 f2 ff ff       	jmp    80105a85 <alltraps>

80106803 <vector213>:
.globl vector213
vector213:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $213
80106805:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010680a:	e9 76 f2 ff ff       	jmp    80105a85 <alltraps>

8010680f <vector214>:
.globl vector214
vector214:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $214
80106811:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106816:	e9 6a f2 ff ff       	jmp    80105a85 <alltraps>

8010681b <vector215>:
.globl vector215
vector215:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $215
8010681d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106822:	e9 5e f2 ff ff       	jmp    80105a85 <alltraps>

80106827 <vector216>:
.globl vector216
vector216:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $216
80106829:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010682e:	e9 52 f2 ff ff       	jmp    80105a85 <alltraps>

80106833 <vector217>:
.globl vector217
vector217:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $217
80106835:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010683a:	e9 46 f2 ff ff       	jmp    80105a85 <alltraps>

8010683f <vector218>:
.globl vector218
vector218:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $218
80106841:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106846:	e9 3a f2 ff ff       	jmp    80105a85 <alltraps>

8010684b <vector219>:
.globl vector219
vector219:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $219
8010684d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106852:	e9 2e f2 ff ff       	jmp    80105a85 <alltraps>

80106857 <vector220>:
.globl vector220
vector220:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $220
80106859:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010685e:	e9 22 f2 ff ff       	jmp    80105a85 <alltraps>

80106863 <vector221>:
.globl vector221
vector221:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $221
80106865:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010686a:	e9 16 f2 ff ff       	jmp    80105a85 <alltraps>

8010686f <vector222>:
.globl vector222
vector222:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $222
80106871:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106876:	e9 0a f2 ff ff       	jmp    80105a85 <alltraps>

8010687b <vector223>:
.globl vector223
vector223:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $223
8010687d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106882:	e9 fe f1 ff ff       	jmp    80105a85 <alltraps>

80106887 <vector224>:
.globl vector224
vector224:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $224
80106889:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010688e:	e9 f2 f1 ff ff       	jmp    80105a85 <alltraps>

80106893 <vector225>:
.globl vector225
vector225:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $225
80106895:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010689a:	e9 e6 f1 ff ff       	jmp    80105a85 <alltraps>

8010689f <vector226>:
.globl vector226
vector226:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $226
801068a1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801068a6:	e9 da f1 ff ff       	jmp    80105a85 <alltraps>

801068ab <vector227>:
.globl vector227
vector227:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $227
801068ad:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801068b2:	e9 ce f1 ff ff       	jmp    80105a85 <alltraps>

801068b7 <vector228>:
.globl vector228
vector228:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $228
801068b9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801068be:	e9 c2 f1 ff ff       	jmp    80105a85 <alltraps>

801068c3 <vector229>:
.globl vector229
vector229:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $229
801068c5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801068ca:	e9 b6 f1 ff ff       	jmp    80105a85 <alltraps>

801068cf <vector230>:
.globl vector230
vector230:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $230
801068d1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801068d6:	e9 aa f1 ff ff       	jmp    80105a85 <alltraps>

801068db <vector231>:
.globl vector231
vector231:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $231
801068dd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801068e2:	e9 9e f1 ff ff       	jmp    80105a85 <alltraps>

801068e7 <vector232>:
.globl vector232
vector232:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $232
801068e9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801068ee:	e9 92 f1 ff ff       	jmp    80105a85 <alltraps>

801068f3 <vector233>:
.globl vector233
vector233:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $233
801068f5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801068fa:	e9 86 f1 ff ff       	jmp    80105a85 <alltraps>

801068ff <vector234>:
.globl vector234
vector234:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $234
80106901:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106906:	e9 7a f1 ff ff       	jmp    80105a85 <alltraps>

8010690b <vector235>:
.globl vector235
vector235:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $235
8010690d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106912:	e9 6e f1 ff ff       	jmp    80105a85 <alltraps>

80106917 <vector236>:
.globl vector236
vector236:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $236
80106919:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010691e:	e9 62 f1 ff ff       	jmp    80105a85 <alltraps>

80106923 <vector237>:
.globl vector237
vector237:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $237
80106925:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010692a:	e9 56 f1 ff ff       	jmp    80105a85 <alltraps>

8010692f <vector238>:
.globl vector238
vector238:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $238
80106931:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106936:	e9 4a f1 ff ff       	jmp    80105a85 <alltraps>

8010693b <vector239>:
.globl vector239
vector239:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $239
8010693d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106942:	e9 3e f1 ff ff       	jmp    80105a85 <alltraps>

80106947 <vector240>:
.globl vector240
vector240:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $240
80106949:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010694e:	e9 32 f1 ff ff       	jmp    80105a85 <alltraps>

80106953 <vector241>:
.globl vector241
vector241:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $241
80106955:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010695a:	e9 26 f1 ff ff       	jmp    80105a85 <alltraps>

8010695f <vector242>:
.globl vector242
vector242:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $242
80106961:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106966:	e9 1a f1 ff ff       	jmp    80105a85 <alltraps>

8010696b <vector243>:
.globl vector243
vector243:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $243
8010696d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106972:	e9 0e f1 ff ff       	jmp    80105a85 <alltraps>

80106977 <vector244>:
.globl vector244
vector244:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $244
80106979:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010697e:	e9 02 f1 ff ff       	jmp    80105a85 <alltraps>

80106983 <vector245>:
.globl vector245
vector245:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $245
80106985:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010698a:	e9 f6 f0 ff ff       	jmp    80105a85 <alltraps>

8010698f <vector246>:
.globl vector246
vector246:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $246
80106991:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106996:	e9 ea f0 ff ff       	jmp    80105a85 <alltraps>

8010699b <vector247>:
.globl vector247
vector247:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $247
8010699d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801069a2:	e9 de f0 ff ff       	jmp    80105a85 <alltraps>

801069a7 <vector248>:
.globl vector248
vector248:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $248
801069a9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801069ae:	e9 d2 f0 ff ff       	jmp    80105a85 <alltraps>

801069b3 <vector249>:
.globl vector249
vector249:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $249
801069b5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801069ba:	e9 c6 f0 ff ff       	jmp    80105a85 <alltraps>

801069bf <vector250>:
.globl vector250
vector250:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $250
801069c1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801069c6:	e9 ba f0 ff ff       	jmp    80105a85 <alltraps>

801069cb <vector251>:
.globl vector251
vector251:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $251
801069cd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801069d2:	e9 ae f0 ff ff       	jmp    80105a85 <alltraps>

801069d7 <vector252>:
.globl vector252
vector252:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $252
801069d9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801069de:	e9 a2 f0 ff ff       	jmp    80105a85 <alltraps>

801069e3 <vector253>:
.globl vector253
vector253:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $253
801069e5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801069ea:	e9 96 f0 ff ff       	jmp    80105a85 <alltraps>

801069ef <vector254>:
.globl vector254
vector254:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $254
801069f1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801069f6:	e9 8a f0 ff ff       	jmp    80105a85 <alltraps>

801069fb <vector255>:
.globl vector255
vector255:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $255
801069fd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a02:	e9 7e f0 ff ff       	jmp    80105a85 <alltraps>
80106a07:	66 90                	xchg   %ax,%ax
80106a09:	66 90                	xchg   %ax,%ax
80106a0b:	66 90                	xchg   %ax,%ax
80106a0d:	66 90                	xchg   %ax,%ax
80106a0f:	90                   	nop

80106a10 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a10:	55                   	push   %ebp
80106a11:	89 e5                	mov    %esp,%ebp
80106a13:	57                   	push   %edi
80106a14:	56                   	push   %esi
80106a15:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a16:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106a1c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a22:	83 ec 1c             	sub    $0x1c,%esp
80106a25:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106a28:	39 d3                	cmp    %edx,%ebx
80106a2a:	73 49                	jae    80106a75 <deallocuvm.part.0+0x65>
80106a2c:	89 c7                	mov    %eax,%edi
80106a2e:	eb 0c                	jmp    80106a3c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106a30:	83 c0 01             	add    $0x1,%eax
80106a33:	c1 e0 16             	shl    $0x16,%eax
80106a36:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106a38:	39 da                	cmp    %ebx,%edx
80106a3a:	76 39                	jbe    80106a75 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106a3c:	89 d8                	mov    %ebx,%eax
80106a3e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106a41:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106a44:	f6 c1 01             	test   $0x1,%cl
80106a47:	74 e7                	je     80106a30 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106a49:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a4b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106a51:	c1 ee 0a             	shr    $0xa,%esi
80106a54:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106a5a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106a61:	85 f6                	test   %esi,%esi
80106a63:	74 cb                	je     80106a30 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106a65:	8b 06                	mov    (%esi),%eax
80106a67:	a8 01                	test   $0x1,%al
80106a69:	75 15                	jne    80106a80 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106a6b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a71:	39 da                	cmp    %ebx,%edx
80106a73:	77 c7                	ja     80106a3c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106a75:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a7b:	5b                   	pop    %ebx
80106a7c:	5e                   	pop    %esi
80106a7d:	5f                   	pop    %edi
80106a7e:	5d                   	pop    %ebp
80106a7f:	c3                   	ret    
      if(pa == 0)
80106a80:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a85:	74 25                	je     80106aac <deallocuvm.part.0+0x9c>
      kfree(v);
80106a87:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106a8a:	05 00 00 00 80       	add    $0x80000000,%eax
80106a8f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106a92:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106a98:	50                   	push   %eax
80106a99:	e8 22 ba ff ff       	call   801024c0 <kfree>
      *pte = 0;
80106a9e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106aa4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106aa7:	83 c4 10             	add    $0x10,%esp
80106aaa:	eb 8c                	jmp    80106a38 <deallocuvm.part.0+0x28>
        panic("kfree");
80106aac:	83 ec 0c             	sub    $0xc,%esp
80106aaf:	68 c6 78 10 80       	push   $0x801078c6
80106ab4:	e8 c7 98 ff ff       	call   80100380 <panic>
80106ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ac0 <mappages>:
{
80106ac0:	55                   	push   %ebp
80106ac1:	89 e5                	mov    %esp,%ebp
80106ac3:	57                   	push   %edi
80106ac4:	56                   	push   %esi
80106ac5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106ac6:	89 d3                	mov    %edx,%ebx
80106ac8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106ace:	83 ec 1c             	sub    $0x1c,%esp
80106ad1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ad4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106ad8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106add:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106ae0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ae3:	29 d8                	sub    %ebx,%eax
80106ae5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ae8:	eb 3d                	jmp    80106b27 <mappages+0x67>
80106aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106af0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106af2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106af7:	c1 ea 0a             	shr    $0xa,%edx
80106afa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106b00:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b07:	85 c0                	test   %eax,%eax
80106b09:	74 75                	je     80106b80 <mappages+0xc0>
    if(*pte & PTE_P)
80106b0b:	f6 00 01             	testb  $0x1,(%eax)
80106b0e:	0f 85 86 00 00 00    	jne    80106b9a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106b14:	0b 75 0c             	or     0xc(%ebp),%esi
80106b17:	83 ce 01             	or     $0x1,%esi
80106b1a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b1c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106b1f:	74 6f                	je     80106b90 <mappages+0xd0>
    a += PGSIZE;
80106b21:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106b27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106b2a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b2d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106b30:	89 d8                	mov    %ebx,%eax
80106b32:	c1 e8 16             	shr    $0x16,%eax
80106b35:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106b38:	8b 07                	mov    (%edi),%eax
80106b3a:	a8 01                	test   $0x1,%al
80106b3c:	75 b2                	jne    80106af0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106b3e:	e8 ad bb ff ff       	call   801026f0 <kalloc>
80106b43:	85 c0                	test   %eax,%eax
80106b45:	74 39                	je     80106b80 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106b47:	83 ec 04             	sub    $0x4,%esp
80106b4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106b4d:	68 00 10 00 00       	push   $0x1000
80106b52:	6a 00                	push   $0x0
80106b54:	50                   	push   %eax
80106b55:	e8 16 dd ff ff       	call   80104870 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b5a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106b5d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b60:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106b66:	83 c8 07             	or     $0x7,%eax
80106b69:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106b6b:	89 d8                	mov    %ebx,%eax
80106b6d:	c1 e8 0a             	shr    $0xa,%eax
80106b70:	25 fc 0f 00 00       	and    $0xffc,%eax
80106b75:	01 d0                	add    %edx,%eax
80106b77:	eb 92                	jmp    80106b0b <mappages+0x4b>
80106b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106b80:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b88:	5b                   	pop    %ebx
80106b89:	5e                   	pop    %esi
80106b8a:	5f                   	pop    %edi
80106b8b:	5d                   	pop    %ebp
80106b8c:	c3                   	ret    
80106b8d:	8d 76 00             	lea    0x0(%esi),%esi
80106b90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b93:	31 c0                	xor    %eax,%eax
}
80106b95:	5b                   	pop    %ebx
80106b96:	5e                   	pop    %esi
80106b97:	5f                   	pop    %edi
80106b98:	5d                   	pop    %ebp
80106b99:	c3                   	ret    
      panic("remap");
80106b9a:	83 ec 0c             	sub    $0xc,%esp
80106b9d:	68 60 7f 10 80       	push   $0x80107f60
80106ba2:	e8 d9 97 ff ff       	call   80100380 <panic>
80106ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bae:	66 90                	xchg   %ax,%ax

80106bb0 <seginit>:
{
80106bb0:	55                   	push   %ebp
80106bb1:	89 e5                	mov    %esp,%ebp
80106bb3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106bb6:	e8 a5 cf ff ff       	call   80103b60 <cpuid>
  pd[0] = size-1;
80106bbb:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106bc0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106bc6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106bca:	c7 80 18 a8 14 80 ff 	movl   $0xffff,-0x7feb57e8(%eax)
80106bd1:	ff 00 00 
80106bd4:	c7 80 1c a8 14 80 00 	movl   $0xcf9a00,-0x7feb57e4(%eax)
80106bdb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106bde:	c7 80 20 a8 14 80 ff 	movl   $0xffff,-0x7feb57e0(%eax)
80106be5:	ff 00 00 
80106be8:	c7 80 24 a8 14 80 00 	movl   $0xcf9200,-0x7feb57dc(%eax)
80106bef:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106bf2:	c7 80 28 a8 14 80 ff 	movl   $0xffff,-0x7feb57d8(%eax)
80106bf9:	ff 00 00 
80106bfc:	c7 80 2c a8 14 80 00 	movl   $0xcffa00,-0x7feb57d4(%eax)
80106c03:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c06:	c7 80 30 a8 14 80 ff 	movl   $0xffff,-0x7feb57d0(%eax)
80106c0d:	ff 00 00 
80106c10:	c7 80 34 a8 14 80 00 	movl   $0xcff200,-0x7feb57cc(%eax)
80106c17:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106c1a:	05 10 a8 14 80       	add    $0x8014a810,%eax
  pd[1] = (uint)p;
80106c1f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106c23:	c1 e8 10             	shr    $0x10,%eax
80106c26:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106c2a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106c2d:	0f 01 10             	lgdtl  (%eax)
}
80106c30:	c9                   	leave  
80106c31:	c3                   	ret    
80106c32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c40 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c40:	a1 c4 d4 14 80       	mov    0x8014d4c4,%eax
80106c45:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c4a:	0f 22 d8             	mov    %eax,%cr3
}
80106c4d:	c3                   	ret    
80106c4e:	66 90                	xchg   %ax,%ax

80106c50 <switchuvm>:
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	57                   	push   %edi
80106c54:	56                   	push   %esi
80106c55:	53                   	push   %ebx
80106c56:	83 ec 1c             	sub    $0x1c,%esp
80106c59:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106c5c:	85 f6                	test   %esi,%esi
80106c5e:	0f 84 cb 00 00 00    	je     80106d2f <switchuvm+0xdf>
  if(p->kstack == 0)
80106c64:	8b 46 08             	mov    0x8(%esi),%eax
80106c67:	85 c0                	test   %eax,%eax
80106c69:	0f 84 da 00 00 00    	je     80106d49 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106c6f:	8b 46 04             	mov    0x4(%esi),%eax
80106c72:	85 c0                	test   %eax,%eax
80106c74:	0f 84 c2 00 00 00    	je     80106d3c <switchuvm+0xec>
  pushcli();
80106c7a:	e8 e1 d9 ff ff       	call   80104660 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c7f:	e8 7c ce ff ff       	call   80103b00 <mycpu>
80106c84:	89 c3                	mov    %eax,%ebx
80106c86:	e8 75 ce ff ff       	call   80103b00 <mycpu>
80106c8b:	89 c7                	mov    %eax,%edi
80106c8d:	e8 6e ce ff ff       	call   80103b00 <mycpu>
80106c92:	83 c7 08             	add    $0x8,%edi
80106c95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c98:	e8 63 ce ff ff       	call   80103b00 <mycpu>
80106c9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ca0:	ba 67 00 00 00       	mov    $0x67,%edx
80106ca5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106cac:	83 c0 08             	add    $0x8,%eax
80106caf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106cb6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106cbb:	83 c1 08             	add    $0x8,%ecx
80106cbe:	c1 e8 18             	shr    $0x18,%eax
80106cc1:	c1 e9 10             	shr    $0x10,%ecx
80106cc4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106cca:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106cd0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106cd5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106cdc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106ce1:	e8 1a ce ff ff       	call   80103b00 <mycpu>
80106ce6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ced:	e8 0e ce ff ff       	call   80103b00 <mycpu>
80106cf2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106cf6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106cf9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cff:	e8 fc cd ff ff       	call   80103b00 <mycpu>
80106d04:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d07:	e8 f4 cd ff ff       	call   80103b00 <mycpu>
80106d0c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d10:	b8 28 00 00 00       	mov    $0x28,%eax
80106d15:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106d18:	8b 46 04             	mov    0x4(%esi),%eax
80106d1b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d20:	0f 22 d8             	mov    %eax,%cr3
}
80106d23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d26:	5b                   	pop    %ebx
80106d27:	5e                   	pop    %esi
80106d28:	5f                   	pop    %edi
80106d29:	5d                   	pop    %ebp
  popcli();
80106d2a:	e9 81 d9 ff ff       	jmp    801046b0 <popcli>
    panic("switchuvm: no process");
80106d2f:	83 ec 0c             	sub    $0xc,%esp
80106d32:	68 66 7f 10 80       	push   $0x80107f66
80106d37:	e8 44 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106d3c:	83 ec 0c             	sub    $0xc,%esp
80106d3f:	68 91 7f 10 80       	push   $0x80107f91
80106d44:	e8 37 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106d49:	83 ec 0c             	sub    $0xc,%esp
80106d4c:	68 7c 7f 10 80       	push   $0x80107f7c
80106d51:	e8 2a 96 ff ff       	call   80100380 <panic>
80106d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d5d:	8d 76 00             	lea    0x0(%esi),%esi

80106d60 <inituvm>:
{
80106d60:	55                   	push   %ebp
80106d61:	89 e5                	mov    %esp,%ebp
80106d63:	57                   	push   %edi
80106d64:	56                   	push   %esi
80106d65:	53                   	push   %ebx
80106d66:	83 ec 1c             	sub    $0x1c,%esp
80106d69:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d6c:	8b 75 10             	mov    0x10(%ebp),%esi
80106d6f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106d75:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106d7b:	77 4b                	ja     80106dc8 <inituvm+0x68>
  mem = kalloc();
80106d7d:	e8 6e b9 ff ff       	call   801026f0 <kalloc>
  memset(mem, 0, PGSIZE);
80106d82:	83 ec 04             	sub    $0x4,%esp
80106d85:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106d8a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106d8c:	6a 00                	push   $0x0
80106d8e:	50                   	push   %eax
80106d8f:	e8 dc da ff ff       	call   80104870 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106d94:	58                   	pop    %eax
80106d95:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d9b:	5a                   	pop    %edx
80106d9c:	6a 06                	push   $0x6
80106d9e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106da3:	31 d2                	xor    %edx,%edx
80106da5:	50                   	push   %eax
80106da6:	89 f8                	mov    %edi,%eax
80106da8:	e8 13 fd ff ff       	call   80106ac0 <mappages>
  memmove(mem, init, sz);
80106dad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106db0:	89 75 10             	mov    %esi,0x10(%ebp)
80106db3:	83 c4 10             	add    $0x10,%esp
80106db6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106db9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106dbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dbf:	5b                   	pop    %ebx
80106dc0:	5e                   	pop    %esi
80106dc1:	5f                   	pop    %edi
80106dc2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106dc3:	e9 48 db ff ff       	jmp    80104910 <memmove>
    panic("inituvm: more than a page");
80106dc8:	83 ec 0c             	sub    $0xc,%esp
80106dcb:	68 a5 7f 10 80       	push   $0x80107fa5
80106dd0:	e8 ab 95 ff ff       	call   80100380 <panic>
80106dd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106de0 <loaduvm>:
{
80106de0:	55                   	push   %ebp
80106de1:	89 e5                	mov    %esp,%ebp
80106de3:	57                   	push   %edi
80106de4:	56                   	push   %esi
80106de5:	53                   	push   %ebx
80106de6:	83 ec 1c             	sub    $0x1c,%esp
80106de9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dec:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106def:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106df4:	0f 85 bb 00 00 00    	jne    80106eb5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106dfa:	01 f0                	add    %esi,%eax
80106dfc:	89 f3                	mov    %esi,%ebx
80106dfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e01:	8b 45 14             	mov    0x14(%ebp),%eax
80106e04:	01 f0                	add    %esi,%eax
80106e06:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106e09:	85 f6                	test   %esi,%esi
80106e0b:	0f 84 87 00 00 00    	je     80106e98 <loaduvm+0xb8>
80106e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106e18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106e1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106e1e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106e20:	89 c2                	mov    %eax,%edx
80106e22:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106e25:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106e28:	f6 c2 01             	test   $0x1,%dl
80106e2b:	75 13                	jne    80106e40 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106e2d:	83 ec 0c             	sub    $0xc,%esp
80106e30:	68 bf 7f 10 80       	push   $0x80107fbf
80106e35:	e8 46 95 ff ff       	call   80100380 <panic>
80106e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106e40:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e43:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106e49:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e4e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106e55:	85 c0                	test   %eax,%eax
80106e57:	74 d4                	je     80106e2d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106e59:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e5b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106e5e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106e63:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106e68:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106e6e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e71:	29 d9                	sub    %ebx,%ecx
80106e73:	05 00 00 00 80       	add    $0x80000000,%eax
80106e78:	57                   	push   %edi
80106e79:	51                   	push   %ecx
80106e7a:	50                   	push   %eax
80106e7b:	ff 75 10             	push   0x10(%ebp)
80106e7e:	e8 0d ac ff ff       	call   80101a90 <readi>
80106e83:	83 c4 10             	add    $0x10,%esp
80106e86:	39 f8                	cmp    %edi,%eax
80106e88:	75 1e                	jne    80106ea8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106e8a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106e90:	89 f0                	mov    %esi,%eax
80106e92:	29 d8                	sub    %ebx,%eax
80106e94:	39 c6                	cmp    %eax,%esi
80106e96:	77 80                	ja     80106e18 <loaduvm+0x38>
}
80106e98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e9b:	31 c0                	xor    %eax,%eax
}
80106e9d:	5b                   	pop    %ebx
80106e9e:	5e                   	pop    %esi
80106e9f:	5f                   	pop    %edi
80106ea0:	5d                   	pop    %ebp
80106ea1:	c3                   	ret    
80106ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ea8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106eab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106eb0:	5b                   	pop    %ebx
80106eb1:	5e                   	pop    %esi
80106eb2:	5f                   	pop    %edi
80106eb3:	5d                   	pop    %ebp
80106eb4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106eb5:	83 ec 0c             	sub    $0xc,%esp
80106eb8:	68 d0 80 10 80       	push   $0x801080d0
80106ebd:	e8 be 94 ff ff       	call   80100380 <panic>
80106ec2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ed0 <allocuvm>:
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	57                   	push   %edi
80106ed4:	56                   	push   %esi
80106ed5:	53                   	push   %ebx
80106ed6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106ed9:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106edc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106edf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ee2:	85 c0                	test   %eax,%eax
80106ee4:	0f 88 b6 00 00 00    	js     80106fa0 <allocuvm+0xd0>
  if(newsz < oldsz)
80106eea:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106ef0:	0f 82 9a 00 00 00    	jb     80106f90 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106ef6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106efc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106f02:	39 75 10             	cmp    %esi,0x10(%ebp)
80106f05:	77 44                	ja     80106f4b <allocuvm+0x7b>
80106f07:	e9 87 00 00 00       	jmp    80106f93 <allocuvm+0xc3>
80106f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106f10:	83 ec 04             	sub    $0x4,%esp
80106f13:	68 00 10 00 00       	push   $0x1000
80106f18:	6a 00                	push   $0x0
80106f1a:	50                   	push   %eax
80106f1b:	e8 50 d9 ff ff       	call   80104870 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f20:	58                   	pop    %eax
80106f21:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f27:	5a                   	pop    %edx
80106f28:	6a 06                	push   $0x6
80106f2a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f2f:	89 f2                	mov    %esi,%edx
80106f31:	50                   	push   %eax
80106f32:	89 f8                	mov    %edi,%eax
80106f34:	e8 87 fb ff ff       	call   80106ac0 <mappages>
80106f39:	83 c4 10             	add    $0x10,%esp
80106f3c:	85 c0                	test   %eax,%eax
80106f3e:	78 78                	js     80106fb8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106f40:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106f46:	39 75 10             	cmp    %esi,0x10(%ebp)
80106f49:	76 48                	jbe    80106f93 <allocuvm+0xc3>
    mem = kalloc();
80106f4b:	e8 a0 b7 ff ff       	call   801026f0 <kalloc>
80106f50:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106f52:	85 c0                	test   %eax,%eax
80106f54:	75 ba                	jne    80106f10 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106f56:	83 ec 0c             	sub    $0xc,%esp
80106f59:	68 dd 7f 10 80       	push   $0x80107fdd
80106f5e:	e8 3d 97 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106f63:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f66:	83 c4 10             	add    $0x10,%esp
80106f69:	39 45 10             	cmp    %eax,0x10(%ebp)
80106f6c:	74 32                	je     80106fa0 <allocuvm+0xd0>
80106f6e:	8b 55 10             	mov    0x10(%ebp),%edx
80106f71:	89 c1                	mov    %eax,%ecx
80106f73:	89 f8                	mov    %edi,%eax
80106f75:	e8 96 fa ff ff       	call   80106a10 <deallocuvm.part.0>
      return 0;
80106f7a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106f81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f87:	5b                   	pop    %ebx
80106f88:	5e                   	pop    %esi
80106f89:	5f                   	pop    %edi
80106f8a:	5d                   	pop    %ebp
80106f8b:	c3                   	ret    
80106f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106f90:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106f93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f99:	5b                   	pop    %ebx
80106f9a:	5e                   	pop    %esi
80106f9b:	5f                   	pop    %edi
80106f9c:	5d                   	pop    %ebp
80106f9d:	c3                   	ret    
80106f9e:	66 90                	xchg   %ax,%ax
    return 0;
80106fa0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106fa7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fad:	5b                   	pop    %ebx
80106fae:	5e                   	pop    %esi
80106faf:	5f                   	pop    %edi
80106fb0:	5d                   	pop    %ebp
80106fb1:	c3                   	ret    
80106fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106fb8:	83 ec 0c             	sub    $0xc,%esp
80106fbb:	68 f5 7f 10 80       	push   $0x80107ff5
80106fc0:	e8 db 96 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fc8:	83 c4 10             	add    $0x10,%esp
80106fcb:	39 45 10             	cmp    %eax,0x10(%ebp)
80106fce:	74 0c                	je     80106fdc <allocuvm+0x10c>
80106fd0:	8b 55 10             	mov    0x10(%ebp),%edx
80106fd3:	89 c1                	mov    %eax,%ecx
80106fd5:	89 f8                	mov    %edi,%eax
80106fd7:	e8 34 fa ff ff       	call   80106a10 <deallocuvm.part.0>
      kfree(mem);
80106fdc:	83 ec 0c             	sub    $0xc,%esp
80106fdf:	53                   	push   %ebx
80106fe0:	e8 db b4 ff ff       	call   801024c0 <kfree>
      return 0;
80106fe5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106fec:	83 c4 10             	add    $0x10,%esp
}
80106fef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ff2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ff5:	5b                   	pop    %ebx
80106ff6:	5e                   	pop    %esi
80106ff7:	5f                   	pop    %edi
80106ff8:	5d                   	pop    %ebp
80106ff9:	c3                   	ret    
80106ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107000 <deallocuvm>:
{
80107000:	55                   	push   %ebp
80107001:	89 e5                	mov    %esp,%ebp
80107003:	8b 55 0c             	mov    0xc(%ebp),%edx
80107006:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107009:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010700c:	39 d1                	cmp    %edx,%ecx
8010700e:	73 10                	jae    80107020 <deallocuvm+0x20>
}
80107010:	5d                   	pop    %ebp
80107011:	e9 fa f9 ff ff       	jmp    80106a10 <deallocuvm.part.0>
80107016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010701d:	8d 76 00             	lea    0x0(%esi),%esi
80107020:	89 d0                	mov    %edx,%eax
80107022:	5d                   	pop    %ebp
80107023:	c3                   	ret    
80107024:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010702b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010702f:	90                   	nop

80107030 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107030:	55                   	push   %ebp
80107031:	89 e5                	mov    %esp,%ebp
80107033:	57                   	push   %edi
80107034:	56                   	push   %esi
80107035:	53                   	push   %ebx
80107036:	83 ec 0c             	sub    $0xc,%esp
80107039:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010703c:	85 f6                	test   %esi,%esi
8010703e:	74 59                	je     80107099 <freevm+0x69>
  if(newsz >= oldsz)
80107040:	31 c9                	xor    %ecx,%ecx
80107042:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107047:	89 f0                	mov    %esi,%eax
80107049:	89 f3                	mov    %esi,%ebx
8010704b:	e8 c0 f9 ff ff       	call   80106a10 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107050:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107056:	eb 0f                	jmp    80107067 <freevm+0x37>
80107058:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010705f:	90                   	nop
80107060:	83 c3 04             	add    $0x4,%ebx
80107063:	39 df                	cmp    %ebx,%edi
80107065:	74 23                	je     8010708a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107067:	8b 03                	mov    (%ebx),%eax
80107069:	a8 01                	test   $0x1,%al
8010706b:	74 f3                	je     80107060 <freevm+0x30>
      char *v = P2V(PTE_ADDR(pgdir[i]));
8010706d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107072:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107075:	83 c3 04             	add    $0x4,%ebx
      char *v = P2V(PTE_ADDR(pgdir[i]));
80107078:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010707d:	50                   	push   %eax
8010707e:	e8 3d b4 ff ff       	call   801024c0 <kfree>
80107083:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107086:	39 df                	cmp    %ebx,%edi
80107088:	75 dd                	jne    80107067 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010708a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010708d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107090:	5b                   	pop    %ebx
80107091:	5e                   	pop    %esi
80107092:	5f                   	pop    %edi
80107093:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107094:	e9 27 b4 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107099:	83 ec 0c             	sub    $0xc,%esp
8010709c:	68 11 80 10 80       	push   $0x80108011
801070a1:	e8 da 92 ff ff       	call   80100380 <panic>
801070a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ad:	8d 76 00             	lea    0x0(%esi),%esi

801070b0 <setupkvm>:
{
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	56                   	push   %esi
801070b4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801070b5:	e8 36 b6 ff ff       	call   801026f0 <kalloc>
801070ba:	89 c6                	mov    %eax,%esi
801070bc:	85 c0                	test   %eax,%eax
801070be:	74 42                	je     80107102 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801070c0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070c3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801070c8:	68 00 10 00 00       	push   $0x1000
801070cd:	6a 00                	push   $0x0
801070cf:	50                   	push   %eax
801070d0:	e8 9b d7 ff ff       	call   80104870 <memset>
801070d5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801070d8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801070db:	83 ec 08             	sub    $0x8,%esp
801070de:	8b 4b 08             	mov    0x8(%ebx),%ecx
801070e1:	ff 73 0c             	push   0xc(%ebx)
801070e4:	8b 13                	mov    (%ebx),%edx
801070e6:	50                   	push   %eax
801070e7:	29 c1                	sub    %eax,%ecx
801070e9:	89 f0                	mov    %esi,%eax
801070eb:	e8 d0 f9 ff ff       	call   80106ac0 <mappages>
801070f0:	83 c4 10             	add    $0x10,%esp
801070f3:	85 c0                	test   %eax,%eax
801070f5:	78 19                	js     80107110 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070f7:	83 c3 10             	add    $0x10,%ebx
801070fa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107100:	75 d6                	jne    801070d8 <setupkvm+0x28>
}
80107102:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107105:	89 f0                	mov    %esi,%eax
80107107:	5b                   	pop    %ebx
80107108:	5e                   	pop    %esi
80107109:	5d                   	pop    %ebp
8010710a:	c3                   	ret    
8010710b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010710f:	90                   	nop
      freevm(pgdir);
80107110:	83 ec 0c             	sub    $0xc,%esp
80107113:	56                   	push   %esi
      return 0;
80107114:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107116:	e8 15 ff ff ff       	call   80107030 <freevm>
      return 0;
8010711b:	83 c4 10             	add    $0x10,%esp
}
8010711e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107121:	89 f0                	mov    %esi,%eax
80107123:	5b                   	pop    %ebx
80107124:	5e                   	pop    %esi
80107125:	5d                   	pop    %ebp
80107126:	c3                   	ret    
80107127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010712e:	66 90                	xchg   %ax,%ax

80107130 <kvmalloc>:
{
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107136:	e8 75 ff ff ff       	call   801070b0 <setupkvm>
8010713b:	a3 c4 d4 14 80       	mov    %eax,0x8014d4c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107140:	05 00 00 00 80       	add    $0x80000000,%eax
80107145:	0f 22 d8             	mov    %eax,%cr3
}
80107148:	c9                   	leave  
80107149:	c3                   	ret    
8010714a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107150 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107150:	55                   	push   %ebp
80107151:	89 e5                	mov    %esp,%ebp
80107153:	83 ec 08             	sub    $0x8,%esp
80107156:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107159:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010715c:	89 c1                	mov    %eax,%ecx
8010715e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107161:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107164:	f6 c2 01             	test   $0x1,%dl
80107167:	75 17                	jne    80107180 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107169:	83 ec 0c             	sub    $0xc,%esp
8010716c:	68 22 80 10 80       	push   $0x80108022
80107171:	e8 0a 92 ff ff       	call   80100380 <panic>
80107176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010717d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107180:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107183:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107189:	25 fc 0f 00 00       	and    $0xffc,%eax
8010718e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107195:	85 c0                	test   %eax,%eax
80107197:	74 d0                	je     80107169 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107199:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010719c:	c9                   	leave  
8010719d:	c3                   	ret    
8010719e:	66 90                	xchg   %ax,%ax

801071a0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t* 
copyuvm(pde_t *pgdir, uint sz) {
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	57                   	push   %edi
801071a4:	56                   	push   %esi
801071a5:	53                   	push   %ebx
801071a6:	83 ec 0c             	sub    $0xc,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if ((d = setupkvm()) == 0)
801071a9:	e8 02 ff ff ff       	call   801070b0 <setupkvm>
801071ae:	89 c6                	mov    %eax,%esi
801071b0:	85 c0                	test   %eax,%eax
801071b2:	0f 84 a5 00 00 00    	je     8010725d <copyuvm+0xbd>
    return 0;

  for (i = 0; i < sz; i += PGSIZE) {
801071b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801071bb:	85 c0                	test   %eax,%eax
801071bd:	0f 84 8f 00 00 00    	je     80107252 <copyuvm+0xb2>
801071c3:	31 ff                	xor    %edi,%edi
801071c5:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801071c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801071cb:	89 f8                	mov    %edi,%eax
801071cd:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801071d0:	8b 04 83             	mov    (%ebx,%eax,4),%eax
801071d3:	a8 01                	test   $0x1,%al
801071d5:	75 11                	jne    801071e8 <copyuvm+0x48>
    if ((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801071d7:	83 ec 0c             	sub    $0xc,%esp
801071da:	68 2c 80 10 80       	push   $0x8010802c
801071df:	e8 9c 91 ff ff       	call   80100380 <panic>
801071e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801071e8:	89 fa                	mov    %edi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801071ef:	c1 ea 0a             	shr    $0xa,%edx
801071f2:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801071f8:	8d 94 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%edx
    if ((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801071ff:	85 d2                	test   %edx,%edx
80107201:	74 d4                	je     801071d7 <copyuvm+0x37>
    if (!(*pte & PTE_P))
80107203:	8b 02                	mov    (%edx),%eax
80107205:	a8 01                	test   $0x1,%al
80107207:	74 7f                	je     80107288 <copyuvm+0xe8>
      panic("copyuvm: page not present");

    pa = PTE_ADDR(*pte);
80107209:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
    
    // Mark the page as read-only in both parent and child
    *pte &= ~PTE_W;
8010720b:	89 c1                	mov    %eax,%ecx
    if (mappages(d, (void*)i, PGSIZE, pa, flags & ~PTE_W) < 0)
8010720d:	83 ec 08             	sub    $0x8,%esp
80107210:	25 fd 0f 00 00       	and    $0xffd,%eax
    *pte &= ~PTE_W;
80107215:	83 e1 fd             	and    $0xfffffffd,%ecx
    pa = PTE_ADDR(*pte);
80107218:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    *pte &= ~PTE_W;
8010721e:	89 0a                	mov    %ecx,(%edx)
    if (mappages(d, (void*)i, PGSIZE, pa, flags & ~PTE_W) < 0)
80107220:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107225:	89 fa                	mov    %edi,%edx
80107227:	50                   	push   %eax
80107228:	89 f0                	mov    %esi,%eax
8010722a:	53                   	push   %ebx
8010722b:	e8 90 f8 ff ff       	call   80106ac0 <mappages>
80107230:	83 c4 10             	add    $0x10,%esp
80107233:	85 c0                	test   %eax,%eax
80107235:	78 39                	js     80107270 <copyuvm+0xd0>
      goto bad;

    // Increment the reference count for the shared page
    incr_refc(pa);
80107237:	83 ec 0c             	sub    $0xc,%esp
  for (i = 0; i < sz; i += PGSIZE) {
8010723a:	81 c7 00 10 00 00    	add    $0x1000,%edi
    incr_refc(pa);
80107240:	53                   	push   %ebx
80107241:	e8 6a b5 ff ff       	call   801027b0 <incr_refc>
  for (i = 0; i < sz; i += PGSIZE) {
80107246:	83 c4 10             	add    $0x10,%esp
80107249:	39 7d 0c             	cmp    %edi,0xc(%ebp)
8010724c:	0f 87 76 ff ff ff    	ja     801071c8 <copyuvm+0x28>
  }
  lcr3(V2P(pgdir)); // Flush TLB
80107252:	8b 45 08             	mov    0x8(%ebp),%eax
80107255:	05 00 00 00 80       	add    $0x80000000,%eax
8010725a:	0f 22 d8             	mov    %eax,%cr3
  return d;

bad:
  freevm(d);
  return 0;
}
8010725d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107260:	89 f0                	mov    %esi,%eax
80107262:	5b                   	pop    %ebx
80107263:	5e                   	pop    %esi
80107264:	5f                   	pop    %edi
80107265:	5d                   	pop    %ebp
80107266:	c3                   	ret    
80107267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010726e:	66 90                	xchg   %ax,%ax
  freevm(d);
80107270:	83 ec 0c             	sub    $0xc,%esp
80107273:	56                   	push   %esi
  return 0;
80107274:	31 f6                	xor    %esi,%esi
  freevm(d);
80107276:	e8 b5 fd ff ff       	call   80107030 <freevm>
  return 0;
8010727b:	83 c4 10             	add    $0x10,%esp
}
8010727e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107281:	89 f0                	mov    %esi,%eax
80107283:	5b                   	pop    %ebx
80107284:	5e                   	pop    %esi
80107285:	5f                   	pop    %edi
80107286:	5d                   	pop    %ebp
80107287:	c3                   	ret    
      panic("copyuvm: page not present");
80107288:	83 ec 0c             	sub    $0xc,%esp
8010728b:	68 46 80 10 80       	push   $0x80108046
80107290:	e8 eb 90 ff ff       	call   80100380 <panic>
80107295:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010729c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801072a0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801072a6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801072a9:	89 c1                	mov    %eax,%ecx
801072ab:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801072ae:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801072b1:	f6 c2 01             	test   $0x1,%dl
801072b4:	0f 84 7d 03 00 00    	je     80107637 <uva2ka.cold>
  return &pgtab[PTX(va)];
801072ba:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072bd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801072c3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801072c4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801072c9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801072d0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801072d7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072da:	05 00 00 00 80       	add    $0x80000000,%eax
801072df:	83 fa 05             	cmp    $0x5,%edx
801072e2:	ba 00 00 00 00       	mov    $0x0,%edx
801072e7:	0f 45 c2             	cmovne %edx,%eax
}
801072ea:	c3                   	ret    
801072eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072ef:	90                   	nop

801072f0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	57                   	push   %edi
801072f4:	56                   	push   %esi
801072f5:	53                   	push   %ebx
801072f6:	83 ec 0c             	sub    $0xc,%esp
801072f9:	8b 75 14             	mov    0x14(%ebp),%esi
801072fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801072ff:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107302:	85 f6                	test   %esi,%esi
80107304:	75 51                	jne    80107357 <copyout+0x67>
80107306:	e9 a5 00 00 00       	jmp    801073b0 <copyout+0xc0>
8010730b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010730f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107310:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107316:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010731c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107322:	74 75                	je     80107399 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107324:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107326:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107329:	29 c3                	sub    %eax,%ebx
8010732b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107331:	39 f3                	cmp    %esi,%ebx
80107333:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107336:	29 f8                	sub    %edi,%eax
80107338:	83 ec 04             	sub    $0x4,%esp
8010733b:	01 c1                	add    %eax,%ecx
8010733d:	53                   	push   %ebx
8010733e:	52                   	push   %edx
8010733f:	51                   	push   %ecx
80107340:	e8 cb d5 ff ff       	call   80104910 <memmove>
    len -= n;
    buf += n;
80107345:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107348:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010734e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107351:	01 da                	add    %ebx,%edx
  while(len > 0){
80107353:	29 de                	sub    %ebx,%esi
80107355:	74 59                	je     801073b0 <copyout+0xc0>
  if(*pde & PTE_P){
80107357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010735a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010735c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010735e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107361:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107367:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010736a:	f6 c1 01             	test   $0x1,%cl
8010736d:	0f 84 cb 02 00 00    	je     8010763e <copyout.cold>
  return &pgtab[PTX(va)];
80107373:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107375:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010737b:	c1 eb 0c             	shr    $0xc,%ebx
8010737e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107384:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010738b:	89 d9                	mov    %ebx,%ecx
8010738d:	83 e1 05             	and    $0x5,%ecx
80107390:	83 f9 05             	cmp    $0x5,%ecx
80107393:	0f 84 77 ff ff ff    	je     80107310 <copyout+0x20>
  }
  return 0;
}
80107399:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010739c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073a1:	5b                   	pop    %ebx
801073a2:	5e                   	pop    %esi
801073a3:	5f                   	pop    %edi
801073a4:	5d                   	pop    %ebp
801073a5:	c3                   	ret    
801073a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ad:	8d 76 00             	lea    0x0(%esi),%esi
801073b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073b3:	31 c0                	xor    %eax,%eax
}
801073b5:	5b                   	pop    %ebx
801073b6:	5e                   	pop    %esi
801073b7:	5f                   	pop    %edi
801073b8:	5d                   	pop    %ebp
801073b9:	c3                   	ret    
801073ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073c0 <CoW_handler>:
//PAGEBREAK!
// Blank page.

void
CoW_handler(void)
{
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	57                   	push   %edi
801073c4:	56                   	push   %esi
801073c5:	53                   	push   %ebx
801073c6:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("movl %%cr2,%0" : "=r" (val));
801073c9:	0f 20 d3             	mov    %cr2,%ebx
  uint va = rcr2(); // get the faulting address
  struct proc *p = myproc();
801073cc:	e8 af c7 ff ff       	call   80103b80 <myproc>
  pde = &pgdir[PDX(va)];
801073d1:	89 da                	mov    %ebx,%edx
  if(*pde & PTE_P){
801073d3:	8b 40 04             	mov    0x4(%eax),%eax
  pde = &pgdir[PDX(va)];
801073d6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801073d9:	8b 04 90             	mov    (%eax,%edx,4),%eax
801073dc:	a8 01                	test   $0x1,%al
801073de:	75 10                	jne    801073f0 <CoW_handler+0x30>
  char *mem;
  uint pa;

  pte = walkpgdir(p->pgdir, (void*)va, 0);
  if (!pte) { // PTE가 없는 경우
    panic("CoW_handler: PTE should exist");
801073e0:	83 ec 0c             	sub    $0xc,%esp
801073e3:	68 60 80 10 80       	push   $0x80108060
801073e8:	e8 93 8f ff ff       	call   80100380 <panic>
801073ed:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801073f0:	c1 eb 0a             	shr    $0xa,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801073f8:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
801073fe:	8d bc 18 00 00 00 80 	lea    -0x80000000(%eax,%ebx,1),%edi
  if (!pte) { // PTE가 없는 경우
80107405:	85 ff                	test   %edi,%edi
80107407:	74 d7                	je     801073e0 <CoW_handler+0x20>
  }
  if (!(*pte & PTE_P)) { // page가 할당되지 않은 경우
80107409:	8b 07                	mov    (%edi),%eax
8010740b:	a8 01                	test   $0x1,%al
8010740d:	0f 84 c7 00 00 00    	je     801074da <CoW_handler+0x11a>
    panic("CoW_handler: Page is not present");
  }

  pa = PTE_ADDR(*pte);
80107413:	89 c6                	mov    %eax,%esi
80107415:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if (!(*pte & PTE_W)) { // Check if the page is not writable
8010741b:	a8 02                	test   $0x2,%al
8010741d:	0f 85 aa 00 00 00    	jne    801074cd <CoW_handler+0x10d>
    if (get_refc(pa) > 1) { // 2개 이상의 프로세스가 공유하는 경우
80107423:	83 ec 0c             	sub    $0xc,%esp
80107426:	56                   	push   %esi
80107427:	e8 64 b4 ff ff       	call   80102890 <get_refc>
8010742c:	83 c4 10             	add    $0x10,%esp
8010742f:	83 f8 01             	cmp    $0x1,%eax
80107432:	7e 5c                	jle    80107490 <CoW_handler+0xd0>
      mem = kalloc();
80107434:	e8 b7 b2 ff ff       	call   801026f0 <kalloc>
80107439:	89 c3                	mov    %eax,%ebx
      if (mem == 0) {
8010743b:	85 c0                	test   %eax,%eax
8010743d:	0f 84 a4 00 00 00    	je     801074e7 <CoW_handler+0x127>
        panic("CoW_handler: Out of memory");
      }
      memmove(mem, (char*)P2V(pa), PGSIZE);
80107443:	83 ec 04             	sub    $0x4,%esp
80107446:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010744c:	68 00 10 00 00       	push   $0x1000
80107451:	50                   	push   %eax
80107452:	53                   	push   %ebx
      *pte = V2P(mem) | PTE_P | PTE_W | PTE_U; 
80107453:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107459:	83 cb 07             	or     $0x7,%ebx
      memmove(mem, (char*)P2V(pa), PGSIZE);
8010745c:	e8 af d4 ff ff       	call   80104910 <memmove>
      *pte = V2P(mem) | PTE_P | PTE_W | PTE_U; 
80107461:	89 1f                	mov    %ebx,(%edi)
      decr_refc(pa); // old page의 참조 횟수 감소
80107463:	89 34 24             	mov    %esi,(%esp)
80107466:	e8 a5 b3 ff ff       	call   80102810 <decr_refc>
8010746b:	83 c4 10             	add    $0x10,%esp
    } else if(get_refc(pa) == 1) { // 1개의 프로세스만 사용하는 경우
      *pte |= PTE_W; // page를 writable로 설정
    } else if(get_refc(pa) == 0) {
      panic("CoW_handler: refc is 0");
    }
    lcr3(V2P(myproc()->pgdir)); // refresh the TLB
8010746e:	e8 0d c7 ff ff       	call   80103b80 <myproc>
80107473:	8b 40 04             	mov    0x4(%eax),%eax
80107476:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010747b:	0f 22 d8             	mov    %eax,%cr3
  } else { // page is writable
    panic("CoW_handler: Page is writable");
  }
}
8010747e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107481:	5b                   	pop    %ebx
80107482:	5e                   	pop    %esi
80107483:	5f                   	pop    %edi
80107484:	5d                   	pop    %ebp
80107485:	c3                   	ret    
80107486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010748d:	8d 76 00             	lea    0x0(%esi),%esi
    } else if(get_refc(pa) == 1) { // 1개의 프로세스만 사용하는 경우
80107490:	83 ec 0c             	sub    $0xc,%esp
80107493:	56                   	push   %esi
80107494:	e8 f7 b3 ff ff       	call   80102890 <get_refc>
80107499:	83 c4 10             	add    $0x10,%esp
8010749c:	83 f8 01             	cmp    $0x1,%eax
8010749f:	75 0f                	jne    801074b0 <CoW_handler+0xf0>
      *pte |= PTE_W; // page를 writable로 설정
801074a1:	83 0f 02             	orl    $0x2,(%edi)
801074a4:	eb c8                	jmp    8010746e <CoW_handler+0xae>
801074a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ad:	8d 76 00             	lea    0x0(%esi),%esi
    } else if(get_refc(pa) == 0) {
801074b0:	83 ec 0c             	sub    $0xc,%esp
801074b3:	56                   	push   %esi
801074b4:	e8 d7 b3 ff ff       	call   80102890 <get_refc>
801074b9:	83 c4 10             	add    $0x10,%esp
801074bc:	85 c0                	test   %eax,%eax
801074be:	75 ae                	jne    8010746e <CoW_handler+0xae>
      panic("CoW_handler: refc is 0");
801074c0:	83 ec 0c             	sub    $0xc,%esp
801074c3:	68 99 80 10 80       	push   $0x80108099
801074c8:	e8 b3 8e ff ff       	call   80100380 <panic>
    panic("CoW_handler: Page is writable");
801074cd:	83 ec 0c             	sub    $0xc,%esp
801074d0:	68 b0 80 10 80       	push   $0x801080b0
801074d5:	e8 a6 8e ff ff       	call   80100380 <panic>
    panic("CoW_handler: Page is not present");
801074da:	83 ec 0c             	sub    $0xc,%esp
801074dd:	68 f4 80 10 80       	push   $0x801080f4
801074e2:	e8 99 8e ff ff       	call   80100380 <panic>
        panic("CoW_handler: Out of memory");
801074e7:	83 ec 0c             	sub    $0xc,%esp
801074ea:	68 7e 80 10 80       	push   $0x8010807e
801074ef:	e8 8c 8e ff ff       	call   80100380 <panic>
801074f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074ff:	90                   	nop

80107500 <countvp>:

int
countvp(void)
{
80107500:	55                   	push   %ebp
80107501:	89 e5                	mov    %esp,%ebp
80107503:	57                   	push   %edi
80107504:	56                   	push   %esi
80107505:	53                   	push   %ebx
80107506:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p = myproc();
80107509:	e8 72 c6 ff ff       	call   80103b80 <myproc>
  pde_t *pgdir = p->pgdir;
  uint sz = p->sz; // process의 가상 주소 공간 크기
8010750e:	8b 18                	mov    (%eax),%ebx
  pde_t *pgdir = p->pgdir;
80107510:	8b 70 04             	mov    0x4(%eax),%esi
  int count = 0;

  for (uint va = 0; va < sz; va += PGSIZE) {
80107513:	85 db                	test   %ebx,%ebx
80107515:	74 59                	je     80107570 <countvp+0x70>
80107517:	31 c0                	xor    %eax,%eax
  int count = 0;
80107519:	31 c9                	xor    %ecx,%ecx
8010751b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010751f:	90                   	nop
  pde = &pgdir[PDX(va)];
80107520:	89 c2                	mov    %eax,%edx
80107522:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107525:	8b 14 96             	mov    (%esi,%edx,4),%edx
80107528:	f6 c2 01             	test   $0x1,%dl
8010752b:	74 27                	je     80107554 <countvp+0x54>
  return &pgtab[PTX(va)];
8010752d:	89 c7                	mov    %eax,%edi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010752f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107535:	c1 ef 0a             	shr    $0xa,%edi
80107538:	81 e7 fc 0f 00 00    	and    $0xffc,%edi
8010753e:	8d 94 3a 00 00 00 80 	lea    -0x80000000(%edx,%edi,1),%edx
    // logical page에 해당하는 pte를 찾음
    pte_t *pte = walkpgdir(pgdir, (void *)va, 0);
    if (pte && (*pte & PTE_P)) { // page가 할당된 경우
80107545:	85 d2                	test   %edx,%edx
80107547:	74 0b                	je     80107554 <countvp+0x54>
80107549:	8b 12                	mov    (%edx),%edx
8010754b:	83 e2 01             	and    $0x1,%edx
      count++;
8010754e:	83 fa 01             	cmp    $0x1,%edx
80107551:	83 d9 ff             	sbb    $0xffffffff,%ecx
  for (uint va = 0; va < sz; va += PGSIZE) {
80107554:	05 00 10 00 00       	add    $0x1000,%eax
80107559:	39 c3                	cmp    %eax,%ebx
8010755b:	77 c3                	ja     80107520 <countvp+0x20>
    }
  }

  return count;
}
8010755d:	83 c4 0c             	add    $0xc,%esp
80107560:	89 c8                	mov    %ecx,%eax
80107562:	5b                   	pop    %ebx
80107563:	5e                   	pop    %esi
80107564:	5f                   	pop    %edi
80107565:	5d                   	pop    %ebp
80107566:	c3                   	ret    
80107567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010756e:	66 90                	xchg   %ax,%ax
80107570:	83 c4 0c             	add    $0xc,%esp
  int count = 0;
80107573:	31 c9                	xor    %ecx,%ecx
}
80107575:	5b                   	pop    %ebx
80107576:	89 c8                	mov    %ecx,%eax
80107578:	5e                   	pop    %esi
80107579:	5f                   	pop    %edi
8010757a:	5d                   	pop    %ebp
8010757b:	c3                   	ret    
8010757c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107580 <countpp>:

int
countpp(void)
{
80107580:	55                   	push   %ebp
80107581:	89 e5                	mov    %esp,%ebp
80107583:	56                   	push   %esi
80107584:	53                   	push   %ebx
  struct proc *p = myproc();
80107585:	e8 f6 c5 ff ff       	call   80103b80 <myproc>
  pde_t *pgdir = p->pgdir; // page directory
  int count = 0;
8010758a:	31 c9                	xor    %ecx,%ecx
  pde_t *pgdir = p->pgdir; // page directory
8010758c:	8b 58 04             	mov    0x4(%eax),%ebx

  for (uint pa = 0; pa < KERNBASE; pa += PGSIZE) {
8010758f:	31 c0                	xor    %eax,%eax
80107591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107598:	89 c2                	mov    %eax,%edx
8010759a:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
8010759d:	8b 14 93             	mov    (%ebx,%edx,4),%edx
801075a0:	f6 c2 01             	test   $0x1,%dl
801075a3:	74 27                	je     801075cc <countpp+0x4c>
  return &pgtab[PTX(va)];
801075a5:	89 c6                	mov    %eax,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075a7:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801075ad:	c1 ee 0a             	shr    $0xa,%esi
801075b0:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
801075b6:	8d 94 32 00 00 00 80 	lea    -0x80000000(%edx,%esi,1),%edx
    pte_t *pte = walkpgdir(pgdir, (void *)pa, 0); // PTE를 찾음
    if (pte && (*pte & PTE_P)) { // 유효한 물리 주소가 할당된 PTE인 경우
801075bd:	85 d2                	test   %edx,%edx
801075bf:	74 0b                	je     801075cc <countpp+0x4c>
801075c1:	8b 12                	mov    (%edx),%edx
801075c3:	83 e2 01             	and    $0x1,%edx
      count++;
801075c6:	83 fa 01             	cmp    $0x1,%edx
801075c9:	83 d9 ff             	sbb    $0xffffffff,%ecx
  for (uint pa = 0; pa < KERNBASE; pa += PGSIZE) {
801075cc:	05 00 10 00 00       	add    $0x1000,%eax
801075d1:	79 c5                	jns    80107598 <countpp+0x18>
    if (pa >= KERNBASE){
      continue;
    }
  }
  return count;
}
801075d3:	5b                   	pop    %ebx
801075d4:	89 c8                	mov    %ecx,%eax
801075d6:	5e                   	pop    %esi
801075d7:	5d                   	pop    %ebp
801075d8:	c3                   	ret    
801075d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075e0 <countptp>:

int
countptp(void)
{
801075e0:	55                   	push   %ebp
801075e1:	89 e5                	mov    %esp,%ebp
801075e3:	53                   	push   %ebx
  struct proc *p = myproc();
  pde_t *pgdir = p->pgdir;
  int count = 0;

  count++; // page directory에 포함된 page table
801075e4:	bb 01 00 00 00       	mov    $0x1,%ebx
{
801075e9:	83 ec 04             	sub    $0x4,%esp
  struct proc *p = myproc();
801075ec:	e8 8f c5 ff ff       	call   80103b80 <myproc>
  pde_t *pgdir = p->pgdir;
801075f1:	8b 48 04             	mov    0x4(%eax),%ecx
801075f4:	31 c0                	xor    %eax,%eax
801075f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075fd:	8d 76 00             	lea    0x0(%esi),%esi

  for (int i = 0; i < NPDENTRIES; i++) { 
    if (pgdir[i] & PTE_P) {  
80107600:	8b 14 01             	mov    (%ecx,%eax,1),%edx
80107603:	f6 c2 01             	test   $0x1,%dl
80107606:	74 1e                	je     80107626 <countptp+0x46>
      pte_t *pgtab = (pte_t*)P2V(PTE_ADDR(pgdir[i])); // page table을 찾음
80107608:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx

      if (pgtab == 0)
8010760e:	81 fa 00 00 00 80    	cmp    $0x80000000,%edx
80107614:	74 10                	je     80107626 <countptp+0x46>
        continue;
      if (pgtab[i] & PTE_P) { // page table entry가 할당된 경우
80107616:	8b 94 10 00 00 00 80 	mov    -0x80000000(%eax,%edx,1),%edx
8010761d:	83 e2 01             	and    $0x1,%edx
        count++;
80107620:	83 fa 01             	cmp    $0x1,%edx
80107623:	83 db ff             	sbb    $0xffffffff,%ebx
  for (int i = 0; i < NPDENTRIES; i++) { 
80107626:	83 c0 04             	add    $0x4,%eax
80107629:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010762e:	75 d0                	jne    80107600 <countptp+0x20>
      }
    }
  }

  return count;
80107630:	89 d8                	mov    %ebx,%eax
80107632:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107635:	c9                   	leave  
80107636:	c3                   	ret    

80107637 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107637:	a1 00 00 00 00       	mov    0x0,%eax
8010763c:	0f 0b                	ud2    

8010763e <copyout.cold>:
8010763e:	a1 00 00 00 00       	mov    0x0,%eax
80107643:	0f 0b                	ud2    
