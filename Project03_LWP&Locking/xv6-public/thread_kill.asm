
_thread_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
}

thread_t t1[NUM_THREAD], t2[NUM_THREAD];

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 24             	sub    $0x24,%esp
  int i, retval;
  int pid;
  
  printf(1, "Thread kill test start\n");
  13:	68 07 09 00 00       	push   $0x907
  18:	6a 01                	push   $0x1
  1a:	e8 61 05 00 00       	call   580 <printf>
  pid = fork();
  1f:	e8 d7 03 00 00       	call   3fb <fork>
  if (pid < 0) {
  24:	83 c4 10             	add    $0x10,%esp
  27:	85 c0                	test   %eax,%eax
  29:	0f 88 d6 00 00 00    	js     105 <main+0x105>
  2f:	89 c3                	mov    %eax,%ebx
    printf(1, "Fork failed!!\n");
    exit();
  }
  else if (pid == 0) {
  31:	74 4d                	je     80 <main+0x80>
  33:	31 f6                	xor    %esi,%esi
    printf(1, "This code shouldn't be executed!!\n");
    exit();
  }
  else {
    for (i = 0; i < NUM_THREAD; i++) {
      if (i == 0)
  35:	85 f6                	test   %esi,%esi
  37:	74 26                	je     5f <main+0x5f>
        thread_create(&t2[i], thread2, (void *)pid);
      else
        thread_create(&t2[i], thread2, (void *)0);
  39:	83 ec 04             	sub    $0x4,%esp
  3c:	8d 04 b5 94 0c 00 00 	lea    0xc94(,%esi,4),%eax
  43:	6a 00                	push   $0x0
  45:	68 50 01 00 00       	push   $0x150
  4a:	50                   	push   %eax
  4b:	e8 53 04 00 00       	call   4a3 <thread_create>
    for (i = 0; i < NUM_THREAD; i++) {
  50:	83 c4 10             	add    $0x10,%esp
  53:	83 fe 04             	cmp    $0x4,%esi
  56:	74 69                	je     c1 <main+0xc1>
  58:	83 c6 01             	add    $0x1,%esi
      if (i == 0)
  5b:	85 f6                	test   %esi,%esi
  5d:	75 da                	jne    39 <main+0x39>
        thread_create(&t2[i], thread2, (void *)pid);
  5f:	83 ec 04             	sub    $0x4,%esp
  62:	53                   	push   %ebx
  63:	68 50 01 00 00       	push   $0x150
  68:	68 94 0c 00 00       	push   $0xc94
  6d:	e8 31 04 00 00       	call   4a3 <thread_create>
  72:	83 c4 10             	add    $0x10,%esp
  75:	eb e1                	jmp    58 <main+0x58>
  77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  7e:	66 90                	xchg   %ax,%ax
      thread_create(&t1[i], thread1, (void *)i);
  80:	83 ec 04             	sub    $0x4,%esp
  83:	8d 04 9d a8 0c 00 00 	lea    0xca8(,%ebx,4),%eax
  8a:	53                   	push   %ebx
    for (i = 0; i < NUM_THREAD; i++)
  8b:	83 c3 01             	add    $0x1,%ebx
      thread_create(&t1[i], thread1, (void *)i);
  8e:	68 20 01 00 00       	push   $0x120
  93:	50                   	push   %eax
  94:	e8 0a 04 00 00       	call   4a3 <thread_create>
    for (i = 0; i < NUM_THREAD; i++)
  99:	83 c4 10             	add    $0x10,%esp
  9c:	83 fb 05             	cmp    $0x5,%ebx
  9f:	75 df                	jne    80 <main+0x80>
    sleep(300);
  a1:	83 ec 0c             	sub    $0xc,%esp
  a4:	68 2c 01 00 00       	push   $0x12c
  a9:	e8 e5 03 00 00       	call   493 <sleep>
    printf(1, "This code shouldn't be executed!!\n");
  ae:	5a                   	pop    %edx
  af:	59                   	pop    %ecx
  b0:	68 a8 08 00 00       	push   $0x8a8
  b5:	6a 01                	push   $0x1
  b7:	e8 c4 04 00 00       	call   580 <printf>
    exit();
  bc:	e8 42 03 00 00       	call   403 <exit>
    }
    for (i = 0; i < NUM_THREAD; i++)
  c1:	31 db                	xor    %ebx,%ebx
  c3:	8d 75 e4             	lea    -0x1c(%ebp),%esi
      thread_join(t2[i], (void **)&retval);
  c6:	83 ec 08             	sub    $0x8,%esp
  c9:	56                   	push   %esi
  ca:	ff 34 9d 94 0c 00 00 	push   0xc94(,%ebx,4)
    for (i = 0; i < NUM_THREAD; i++)
  d1:	83 c3 01             	add    $0x1,%ebx
      thread_join(t2[i], (void **)&retval);
  d4:	e8 da 03 00 00       	call   4b3 <thread_join>
    for (i = 0; i < NUM_THREAD; i++)
  d9:	83 c4 10             	add    $0x10,%esp
  dc:	83 fb 05             	cmp    $0x5,%ebx
  df:	75 e5                	jne    c6 <main+0xc6>
  e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    while (wait() != -1)
  e8:	e8 1e 03 00 00       	call   40b <wait>
  ed:	83 f8 ff             	cmp    $0xffffffff,%eax
  f0:	75 f6                	jne    e8 <main+0xe8>
      ;
    printf(1, "Kill test finished\n");
  f2:	50                   	push   %eax
  f3:	50                   	push   %eax
  f4:	68 2e 09 00 00       	push   $0x92e
  f9:	6a 01                	push   $0x1
  fb:	e8 80 04 00 00       	call   580 <printf>
    exit();
 100:	e8 fe 02 00 00       	call   403 <exit>
    printf(1, "Fork failed!!\n");
 105:	53                   	push   %ebx
 106:	53                   	push   %ebx
 107:	68 1f 09 00 00       	push   $0x91f
 10c:	6a 01                	push   $0x1
 10e:	e8 6d 04 00 00       	call   580 <printf>
    exit();
 113:	e8 eb 02 00 00       	call   403 <exit>
 118:	66 90                	xchg   %ax,%ax
 11a:	66 90                	xchg   %ax,%ax
 11c:	66 90                	xchg   %ax,%ax
 11e:	66 90                	xchg   %ax,%ax

00000120 <thread1>:
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	83 ec 14             	sub    $0x14,%esp
  sleep(200);
 126:	68 c8 00 00 00       	push   $0xc8
 12b:	e8 63 03 00 00       	call   493 <sleep>
  printf(1, "This code shouldn't be executed!!\n");
 130:	58                   	pop    %eax
 131:	5a                   	pop    %edx
 132:	68 a8 08 00 00       	push   $0x8a8
 137:	6a 01                	push   $0x1
 139:	e8 42 04 00 00       	call   580 <printf>
  exit();
 13e:	e8 c0 02 00 00       	call   403 <exit>
 143:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 14a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000150 <thread2>:
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	53                   	push   %ebx
 154:	83 ec 10             	sub    $0x10,%esp
 157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  sleep(100);
 15a:	6a 64                	push   $0x64
 15c:	e8 32 03 00 00       	call   493 <sleep>
  if (val != 0) {
 161:	83 c4 10             	add    $0x10,%esp
 164:	85 db                	test   %ebx,%ebx
 166:	74 1b                	je     183 <thread2+0x33>
    printf(1, "Killing process %d\n", val);
 168:	83 ec 04             	sub    $0x4,%esp
 16b:	53                   	push   %ebx
 16c:	68 f3 08 00 00       	push   $0x8f3
 171:	6a 01                	push   $0x1
 173:	e8 08 04 00 00       	call   580 <printf>
    kill(val);
 178:	89 1c 24             	mov    %ebx,(%esp)
 17b:	e8 b3 02 00 00       	call   433 <kill>
 180:	83 c4 10             	add    $0x10,%esp
  printf(1, "This code should be executed 5 times.\n");
 183:	83 ec 08             	sub    $0x8,%esp
 186:	68 cc 08 00 00       	push   $0x8cc
 18b:	6a 01                	push   $0x1
 18d:	e8 ee 03 00 00       	call   580 <printf>
  thread_exit(0);
 192:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 199:	e8 0d 03 00 00       	call   4ab <thread_exit>
}
 19e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1a1:	31 c0                	xor    %eax,%eax
 1a3:	c9                   	leave  
 1a4:	c3                   	ret    
 1a5:	66 90                	xchg   %ax,%ax
 1a7:	66 90                	xchg   %ax,%ax
 1a9:	66 90                	xchg   %ax,%ax
 1ab:	66 90                	xchg   %ax,%ax
 1ad:	66 90                	xchg   %ax,%ax
 1af:	90                   	nop

000001b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1b0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b1:	31 c0                	xor    %eax,%eax
{
 1b3:	89 e5                	mov    %esp,%ebp
 1b5:	53                   	push   %ebx
 1b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 1c0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1c4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1c7:	83 c0 01             	add    $0x1,%eax
 1ca:	84 d2                	test   %dl,%dl
 1cc:	75 f2                	jne    1c0 <strcpy+0x10>
    ;
  return os;
}
 1ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1d1:	89 c8                	mov    %ecx,%eax
 1d3:	c9                   	leave  
 1d4:	c3                   	ret    
 1d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	53                   	push   %ebx
 1e4:	8b 55 08             	mov    0x8(%ebp),%edx
 1e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1ea:	0f b6 02             	movzbl (%edx),%eax
 1ed:	84 c0                	test   %al,%al
 1ef:	75 17                	jne    208 <strcmp+0x28>
 1f1:	eb 3a                	jmp    22d <strcmp+0x4d>
 1f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1f7:	90                   	nop
 1f8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 1fc:	83 c2 01             	add    $0x1,%edx
 1ff:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 202:	84 c0                	test   %al,%al
 204:	74 1a                	je     220 <strcmp+0x40>
    p++, q++;
 206:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 208:	0f b6 19             	movzbl (%ecx),%ebx
 20b:	38 c3                	cmp    %al,%bl
 20d:	74 e9                	je     1f8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 20f:	29 d8                	sub    %ebx,%eax
}
 211:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 214:	c9                   	leave  
 215:	c3                   	ret    
 216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 21d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 220:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 224:	31 c0                	xor    %eax,%eax
 226:	29 d8                	sub    %ebx,%eax
}
 228:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 22b:	c9                   	leave  
 22c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 22d:	0f b6 19             	movzbl (%ecx),%ebx
 230:	31 c0                	xor    %eax,%eax
 232:	eb db                	jmp    20f <strcmp+0x2f>
 234:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 23f:	90                   	nop

00000240 <strlen>:

uint
strlen(const char *s)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 246:	80 3a 00             	cmpb   $0x0,(%edx)
 249:	74 15                	je     260 <strlen+0x20>
 24b:	31 c0                	xor    %eax,%eax
 24d:	8d 76 00             	lea    0x0(%esi),%esi
 250:	83 c0 01             	add    $0x1,%eax
 253:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 257:	89 c1                	mov    %eax,%ecx
 259:	75 f5                	jne    250 <strlen+0x10>
    ;
  return n;
}
 25b:	89 c8                	mov    %ecx,%eax
 25d:	5d                   	pop    %ebp
 25e:	c3                   	ret    
 25f:	90                   	nop
  for(n = 0; s[n]; n++)
 260:	31 c9                	xor    %ecx,%ecx
}
 262:	5d                   	pop    %ebp
 263:	89 c8                	mov    %ecx,%eax
 265:	c3                   	ret    
 266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26d:	8d 76 00             	lea    0x0(%esi),%esi

00000270 <memset>:

void*
memset(void *dst, int c, uint n)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	57                   	push   %edi
 274:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 277:	8b 4d 10             	mov    0x10(%ebp),%ecx
 27a:	8b 45 0c             	mov    0xc(%ebp),%eax
 27d:	89 d7                	mov    %edx,%edi
 27f:	fc                   	cld    
 280:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 282:	8b 7d fc             	mov    -0x4(%ebp),%edi
 285:	89 d0                	mov    %edx,%eax
 287:	c9                   	leave  
 288:	c3                   	ret    
 289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000290 <strchr>:

char*
strchr(const char *s, char c)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 29a:	0f b6 10             	movzbl (%eax),%edx
 29d:	84 d2                	test   %dl,%dl
 29f:	75 12                	jne    2b3 <strchr+0x23>
 2a1:	eb 1d                	jmp    2c0 <strchr+0x30>
 2a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2a7:	90                   	nop
 2a8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 2ac:	83 c0 01             	add    $0x1,%eax
 2af:	84 d2                	test   %dl,%dl
 2b1:	74 0d                	je     2c0 <strchr+0x30>
    if(*s == c)
 2b3:	38 d1                	cmp    %dl,%cl
 2b5:	75 f1                	jne    2a8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 2b7:	5d                   	pop    %ebp
 2b8:	c3                   	ret    
 2b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 2c0:	31 c0                	xor    %eax,%eax
}
 2c2:	5d                   	pop    %ebp
 2c3:	c3                   	ret    
 2c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2cf:	90                   	nop

000002d0 <gets>:

char*
gets(char *buf, int max)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	57                   	push   %edi
 2d4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 2d5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 2d8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 2d9:	31 db                	xor    %ebx,%ebx
{
 2db:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 2de:	eb 27                	jmp    307 <gets+0x37>
    cc = read(0, &c, 1);
 2e0:	83 ec 04             	sub    $0x4,%esp
 2e3:	6a 01                	push   $0x1
 2e5:	57                   	push   %edi
 2e6:	6a 00                	push   $0x0
 2e8:	e8 2e 01 00 00       	call   41b <read>
    if(cc < 1)
 2ed:	83 c4 10             	add    $0x10,%esp
 2f0:	85 c0                	test   %eax,%eax
 2f2:	7e 1d                	jle    311 <gets+0x41>
      break;
    buf[i++] = c;
 2f4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2f8:	8b 55 08             	mov    0x8(%ebp),%edx
 2fb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 2ff:	3c 0a                	cmp    $0xa,%al
 301:	74 1d                	je     320 <gets+0x50>
 303:	3c 0d                	cmp    $0xd,%al
 305:	74 19                	je     320 <gets+0x50>
  for(i=0; i+1 < max; ){
 307:	89 de                	mov    %ebx,%esi
 309:	83 c3 01             	add    $0x1,%ebx
 30c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 30f:	7c cf                	jl     2e0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 311:	8b 45 08             	mov    0x8(%ebp),%eax
 314:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 318:	8d 65 f4             	lea    -0xc(%ebp),%esp
 31b:	5b                   	pop    %ebx
 31c:	5e                   	pop    %esi
 31d:	5f                   	pop    %edi
 31e:	5d                   	pop    %ebp
 31f:	c3                   	ret    
  buf[i] = '\0';
 320:	8b 45 08             	mov    0x8(%ebp),%eax
 323:	89 de                	mov    %ebx,%esi
 325:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 329:	8d 65 f4             	lea    -0xc(%ebp),%esp
 32c:	5b                   	pop    %ebx
 32d:	5e                   	pop    %esi
 32e:	5f                   	pop    %edi
 32f:	5d                   	pop    %ebp
 330:	c3                   	ret    
 331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 338:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 33f:	90                   	nop

00000340 <stat>:

int
stat(const char *n, struct stat *st)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	56                   	push   %esi
 344:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 345:	83 ec 08             	sub    $0x8,%esp
 348:	6a 00                	push   $0x0
 34a:	ff 75 08             	push   0x8(%ebp)
 34d:	e8 f1 00 00 00       	call   443 <open>
  if(fd < 0)
 352:	83 c4 10             	add    $0x10,%esp
 355:	85 c0                	test   %eax,%eax
 357:	78 27                	js     380 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 359:	83 ec 08             	sub    $0x8,%esp
 35c:	ff 75 0c             	push   0xc(%ebp)
 35f:	89 c3                	mov    %eax,%ebx
 361:	50                   	push   %eax
 362:	e8 f4 00 00 00       	call   45b <fstat>
  close(fd);
 367:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 36a:	89 c6                	mov    %eax,%esi
  close(fd);
 36c:	e8 ba 00 00 00       	call   42b <close>
  return r;
 371:	83 c4 10             	add    $0x10,%esp
}
 374:	8d 65 f8             	lea    -0x8(%ebp),%esp
 377:	89 f0                	mov    %esi,%eax
 379:	5b                   	pop    %ebx
 37a:	5e                   	pop    %esi
 37b:	5d                   	pop    %ebp
 37c:	c3                   	ret    
 37d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 380:	be ff ff ff ff       	mov    $0xffffffff,%esi
 385:	eb ed                	jmp    374 <stat+0x34>
 387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 38e:	66 90                	xchg   %ax,%ax

00000390 <atoi>:

int
atoi(const char *s)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	53                   	push   %ebx
 394:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 397:	0f be 02             	movsbl (%edx),%eax
 39a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 39d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 3a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 3a5:	77 1e                	ja     3c5 <atoi+0x35>
 3a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ae:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 3b0:	83 c2 01             	add    $0x1,%edx
 3b3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 3b6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 3ba:	0f be 02             	movsbl (%edx),%eax
 3bd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3c0:	80 fb 09             	cmp    $0x9,%bl
 3c3:	76 eb                	jbe    3b0 <atoi+0x20>
  return n;
}
 3c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3c8:	89 c8                	mov    %ecx,%eax
 3ca:	c9                   	leave  
 3cb:	c3                   	ret    
 3cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	8b 45 10             	mov    0x10(%ebp),%eax
 3d7:	8b 55 08             	mov    0x8(%ebp),%edx
 3da:	56                   	push   %esi
 3db:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3de:	85 c0                	test   %eax,%eax
 3e0:	7e 13                	jle    3f5 <memmove+0x25>
 3e2:	01 d0                	add    %edx,%eax
  dst = vdst;
 3e4:	89 d7                	mov    %edx,%edi
 3e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ed:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 3f0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 3f1:	39 f8                	cmp    %edi,%eax
 3f3:	75 fb                	jne    3f0 <memmove+0x20>
  return vdst;
}
 3f5:	5e                   	pop    %esi
 3f6:	89 d0                	mov    %edx,%eax
 3f8:	5f                   	pop    %edi
 3f9:	5d                   	pop    %ebp
 3fa:	c3                   	ret    

000003fb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3fb:	b8 01 00 00 00       	mov    $0x1,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <exit>:
SYSCALL(exit)
 403:	b8 02 00 00 00       	mov    $0x2,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <wait>:
SYSCALL(wait)
 40b:	b8 03 00 00 00       	mov    $0x3,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <pipe>:
SYSCALL(pipe)
 413:	b8 04 00 00 00       	mov    $0x4,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <read>:
SYSCALL(read)
 41b:	b8 05 00 00 00       	mov    $0x5,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <write>:
SYSCALL(write)
 423:	b8 10 00 00 00       	mov    $0x10,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <close>:
SYSCALL(close)
 42b:	b8 15 00 00 00       	mov    $0x15,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <kill>:
SYSCALL(kill)
 433:	b8 06 00 00 00       	mov    $0x6,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <exec>:
SYSCALL(exec)
 43b:	b8 07 00 00 00       	mov    $0x7,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <open>:
SYSCALL(open)
 443:	b8 0f 00 00 00       	mov    $0xf,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <mknod>:
SYSCALL(mknod)
 44b:	b8 11 00 00 00       	mov    $0x11,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <unlink>:
SYSCALL(unlink)
 453:	b8 12 00 00 00       	mov    $0x12,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <fstat>:
SYSCALL(fstat)
 45b:	b8 08 00 00 00       	mov    $0x8,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <link>:
SYSCALL(link)
 463:	b8 13 00 00 00       	mov    $0x13,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <mkdir>:
SYSCALL(mkdir)
 46b:	b8 14 00 00 00       	mov    $0x14,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <chdir>:
SYSCALL(chdir)
 473:	b8 09 00 00 00       	mov    $0x9,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <dup>:
SYSCALL(dup)
 47b:	b8 0a 00 00 00       	mov    $0xa,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <getpid>:
SYSCALL(getpid)
 483:	b8 0b 00 00 00       	mov    $0xb,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <sbrk>:
SYSCALL(sbrk)
 48b:	b8 0c 00 00 00       	mov    $0xc,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <sleep>:
SYSCALL(sleep)
 493:	b8 0d 00 00 00       	mov    $0xd,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <uptime>:
SYSCALL(uptime)
 49b:	b8 0e 00 00 00       	mov    $0xe,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <thread_create>:
SYSCALL(thread_create)
 4a3:	b8 16 00 00 00       	mov    $0x16,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <thread_exit>:
SYSCALL(thread_exit)
 4ab:	b8 17 00 00 00       	mov    $0x17,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <thread_join>:
SYSCALL(thread_join)
 4b3:	b8 18 00 00 00       	mov    $0x18,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <kill_threads>:
SYSCALL(kill_threads)
 4bb:	b8 19 00 00 00       	mov    $0x19,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    
 4c3:	66 90                	xchg   %ax,%ax
 4c5:	66 90                	xchg   %ax,%ax
 4c7:	66 90                	xchg   %ax,%ax
 4c9:	66 90                	xchg   %ax,%ax
 4cb:	66 90                	xchg   %ax,%ax
 4cd:	66 90                	xchg   %ax,%ax
 4cf:	90                   	nop

000004d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	57                   	push   %edi
 4d4:	56                   	push   %esi
 4d5:	53                   	push   %ebx
 4d6:	83 ec 3c             	sub    $0x3c,%esp
 4d9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4dc:	89 d1                	mov    %edx,%ecx
{
 4de:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 4e1:	85 d2                	test   %edx,%edx
 4e3:	0f 89 7f 00 00 00    	jns    568 <printint+0x98>
 4e9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4ed:	74 79                	je     568 <printint+0x98>
    neg = 1;
 4ef:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 4f6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 4f8:	31 db                	xor    %ebx,%ebx
 4fa:	8d 75 d7             	lea    -0x29(%ebp),%esi
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 500:	89 c8                	mov    %ecx,%eax
 502:	31 d2                	xor    %edx,%edx
 504:	89 cf                	mov    %ecx,%edi
 506:	f7 75 c4             	divl   -0x3c(%ebp)
 509:	0f b6 92 a4 09 00 00 	movzbl 0x9a4(%edx),%edx
 510:	89 45 c0             	mov    %eax,-0x40(%ebp)
 513:	89 d8                	mov    %ebx,%eax
 515:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 518:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 51b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 51e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 521:	76 dd                	jbe    500 <printint+0x30>
  if(neg)
 523:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 526:	85 c9                	test   %ecx,%ecx
 528:	74 0c                	je     536 <printint+0x66>
    buf[i++] = '-';
 52a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 52f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 531:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 536:	8b 7d b8             	mov    -0x48(%ebp),%edi
 539:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 53d:	eb 07                	jmp    546 <printint+0x76>
 53f:	90                   	nop
    putc(fd, buf[i]);
 540:	0f b6 13             	movzbl (%ebx),%edx
 543:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 546:	83 ec 04             	sub    $0x4,%esp
 549:	88 55 d7             	mov    %dl,-0x29(%ebp)
 54c:	6a 01                	push   $0x1
 54e:	56                   	push   %esi
 54f:	57                   	push   %edi
 550:	e8 ce fe ff ff       	call   423 <write>
  while(--i >= 0)
 555:	83 c4 10             	add    $0x10,%esp
 558:	39 de                	cmp    %ebx,%esi
 55a:	75 e4                	jne    540 <printint+0x70>
}
 55c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 55f:	5b                   	pop    %ebx
 560:	5e                   	pop    %esi
 561:	5f                   	pop    %edi
 562:	5d                   	pop    %ebp
 563:	c3                   	ret    
 564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 568:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 56f:	eb 87                	jmp    4f8 <printint+0x28>
 571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 578:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 57f:	90                   	nop

00000580 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	57                   	push   %edi
 584:	56                   	push   %esi
 585:	53                   	push   %ebx
 586:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 589:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 58c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 58f:	0f b6 13             	movzbl (%ebx),%edx
 592:	84 d2                	test   %dl,%dl
 594:	74 6a                	je     600 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 596:	8d 45 10             	lea    0x10(%ebp),%eax
 599:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 59c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 59f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 5a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5a4:	eb 36                	jmp    5dc <printf+0x5c>
 5a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ad:	8d 76 00             	lea    0x0(%esi),%esi
 5b0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5b3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 5b8:	83 f8 25             	cmp    $0x25,%eax
 5bb:	74 15                	je     5d2 <printf+0x52>
  write(fd, &c, 1);
 5bd:	83 ec 04             	sub    $0x4,%esp
 5c0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 5c3:	6a 01                	push   $0x1
 5c5:	57                   	push   %edi
 5c6:	56                   	push   %esi
 5c7:	e8 57 fe ff ff       	call   423 <write>
 5cc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 5cf:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 5d2:	0f b6 13             	movzbl (%ebx),%edx
 5d5:	83 c3 01             	add    $0x1,%ebx
 5d8:	84 d2                	test   %dl,%dl
 5da:	74 24                	je     600 <printf+0x80>
    c = fmt[i] & 0xff;
 5dc:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 5df:	85 c9                	test   %ecx,%ecx
 5e1:	74 cd                	je     5b0 <printf+0x30>
      }
    } else if(state == '%'){
 5e3:	83 f9 25             	cmp    $0x25,%ecx
 5e6:	75 ea                	jne    5d2 <printf+0x52>
      if(c == 'd'){
 5e8:	83 f8 25             	cmp    $0x25,%eax
 5eb:	0f 84 07 01 00 00    	je     6f8 <printf+0x178>
 5f1:	83 e8 63             	sub    $0x63,%eax
 5f4:	83 f8 15             	cmp    $0x15,%eax
 5f7:	77 17                	ja     610 <printf+0x90>
 5f9:	ff 24 85 4c 09 00 00 	jmp    *0x94c(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 600:	8d 65 f4             	lea    -0xc(%ebp),%esp
 603:	5b                   	pop    %ebx
 604:	5e                   	pop    %esi
 605:	5f                   	pop    %edi
 606:	5d                   	pop    %ebp
 607:	c3                   	ret    
 608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 60f:	90                   	nop
  write(fd, &c, 1);
 610:	83 ec 04             	sub    $0x4,%esp
 613:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 616:	6a 01                	push   $0x1
 618:	57                   	push   %edi
 619:	56                   	push   %esi
 61a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 61e:	e8 00 fe ff ff       	call   423 <write>
        putc(fd, c);
 623:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 627:	83 c4 0c             	add    $0xc,%esp
 62a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 62d:	6a 01                	push   $0x1
 62f:	57                   	push   %edi
 630:	56                   	push   %esi
 631:	e8 ed fd ff ff       	call   423 <write>
        putc(fd, c);
 636:	83 c4 10             	add    $0x10,%esp
      state = 0;
 639:	31 c9                	xor    %ecx,%ecx
 63b:	eb 95                	jmp    5d2 <printf+0x52>
 63d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 640:	83 ec 0c             	sub    $0xc,%esp
 643:	b9 10 00 00 00       	mov    $0x10,%ecx
 648:	6a 00                	push   $0x0
 64a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 64d:	8b 10                	mov    (%eax),%edx
 64f:	89 f0                	mov    %esi,%eax
 651:	e8 7a fe ff ff       	call   4d0 <printint>
        ap++;
 656:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 65a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 65d:	31 c9                	xor    %ecx,%ecx
 65f:	e9 6e ff ff ff       	jmp    5d2 <printf+0x52>
 664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 668:	8b 45 d0             	mov    -0x30(%ebp),%eax
 66b:	8b 10                	mov    (%eax),%edx
        ap++;
 66d:	83 c0 04             	add    $0x4,%eax
 670:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 673:	85 d2                	test   %edx,%edx
 675:	0f 84 8d 00 00 00    	je     708 <printf+0x188>
        while(*s != 0){
 67b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 67e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 680:	84 c0                	test   %al,%al
 682:	0f 84 4a ff ff ff    	je     5d2 <printf+0x52>
 688:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 68b:	89 d3                	mov    %edx,%ebx
 68d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 690:	83 ec 04             	sub    $0x4,%esp
          s++;
 693:	83 c3 01             	add    $0x1,%ebx
 696:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 699:	6a 01                	push   $0x1
 69b:	57                   	push   %edi
 69c:	56                   	push   %esi
 69d:	e8 81 fd ff ff       	call   423 <write>
        while(*s != 0){
 6a2:	0f b6 03             	movzbl (%ebx),%eax
 6a5:	83 c4 10             	add    $0x10,%esp
 6a8:	84 c0                	test   %al,%al
 6aa:	75 e4                	jne    690 <printf+0x110>
      state = 0;
 6ac:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 6af:	31 c9                	xor    %ecx,%ecx
 6b1:	e9 1c ff ff ff       	jmp    5d2 <printf+0x52>
 6b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6bd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 6c0:	83 ec 0c             	sub    $0xc,%esp
 6c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6c8:	6a 01                	push   $0x1
 6ca:	e9 7b ff ff ff       	jmp    64a <printf+0xca>
 6cf:	90                   	nop
        putc(fd, *ap);
 6d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 6d3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 6d6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 6d8:	6a 01                	push   $0x1
 6da:	57                   	push   %edi
 6db:	56                   	push   %esi
        putc(fd, *ap);
 6dc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6df:	e8 3f fd ff ff       	call   423 <write>
        ap++;
 6e4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 6e8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6eb:	31 c9                	xor    %ecx,%ecx
 6ed:	e9 e0 fe ff ff       	jmp    5d2 <printf+0x52>
 6f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 6f8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 6fb:	83 ec 04             	sub    $0x4,%esp
 6fe:	e9 2a ff ff ff       	jmp    62d <printf+0xad>
 703:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 707:	90                   	nop
          s = "(null)";
 708:	ba 42 09 00 00       	mov    $0x942,%edx
        while(*s != 0){
 70d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 710:	b8 28 00 00 00       	mov    $0x28,%eax
 715:	89 d3                	mov    %edx,%ebx
 717:	e9 74 ff ff ff       	jmp    690 <printf+0x110>
 71c:	66 90                	xchg   %ax,%ax
 71e:	66 90                	xchg   %ax,%ax

00000720 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 720:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 721:	a1 bc 0c 00 00       	mov    0xcbc,%eax
{
 726:	89 e5                	mov    %esp,%ebp
 728:	57                   	push   %edi
 729:	56                   	push   %esi
 72a:	53                   	push   %ebx
 72b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 72e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 738:	89 c2                	mov    %eax,%edx
 73a:	8b 00                	mov    (%eax),%eax
 73c:	39 ca                	cmp    %ecx,%edx
 73e:	73 30                	jae    770 <free+0x50>
 740:	39 c1                	cmp    %eax,%ecx
 742:	72 04                	jb     748 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 744:	39 c2                	cmp    %eax,%edx
 746:	72 f0                	jb     738 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 748:	8b 73 fc             	mov    -0x4(%ebx),%esi
 74b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 74e:	39 f8                	cmp    %edi,%eax
 750:	74 30                	je     782 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 752:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 755:	8b 42 04             	mov    0x4(%edx),%eax
 758:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 75b:	39 f1                	cmp    %esi,%ecx
 75d:	74 3a                	je     799 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 75f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 761:	5b                   	pop    %ebx
  freep = p;
 762:	89 15 bc 0c 00 00    	mov    %edx,0xcbc
}
 768:	5e                   	pop    %esi
 769:	5f                   	pop    %edi
 76a:	5d                   	pop    %ebp
 76b:	c3                   	ret    
 76c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 770:	39 c2                	cmp    %eax,%edx
 772:	72 c4                	jb     738 <free+0x18>
 774:	39 c1                	cmp    %eax,%ecx
 776:	73 c0                	jae    738 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 778:	8b 73 fc             	mov    -0x4(%ebx),%esi
 77b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 77e:	39 f8                	cmp    %edi,%eax
 780:	75 d0                	jne    752 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 782:	03 70 04             	add    0x4(%eax),%esi
 785:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 788:	8b 02                	mov    (%edx),%eax
 78a:	8b 00                	mov    (%eax),%eax
 78c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 78f:	8b 42 04             	mov    0x4(%edx),%eax
 792:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 795:	39 f1                	cmp    %esi,%ecx
 797:	75 c6                	jne    75f <free+0x3f>
    p->s.size += bp->s.size;
 799:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 79c:	89 15 bc 0c 00 00    	mov    %edx,0xcbc
    p->s.size += bp->s.size;
 7a2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 7a5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 7a8:	89 0a                	mov    %ecx,(%edx)
}
 7aa:	5b                   	pop    %ebx
 7ab:	5e                   	pop    %esi
 7ac:	5f                   	pop    %edi
 7ad:	5d                   	pop    %ebp
 7ae:	c3                   	ret    
 7af:	90                   	nop

000007b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b0:	55                   	push   %ebp
 7b1:	89 e5                	mov    %esp,%ebp
 7b3:	57                   	push   %edi
 7b4:	56                   	push   %esi
 7b5:	53                   	push   %ebx
 7b6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7bc:	8b 3d bc 0c 00 00    	mov    0xcbc,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c2:	8d 70 07             	lea    0x7(%eax),%esi
 7c5:	c1 ee 03             	shr    $0x3,%esi
 7c8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 7cb:	85 ff                	test   %edi,%edi
 7cd:	0f 84 9d 00 00 00    	je     870 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 7d5:	8b 4a 04             	mov    0x4(%edx),%ecx
 7d8:	39 f1                	cmp    %esi,%ecx
 7da:	73 6a                	jae    846 <malloc+0x96>
 7dc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7e1:	39 de                	cmp    %ebx,%esi
 7e3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 7e6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 7ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 7f0:	eb 17                	jmp    809 <malloc+0x59>
 7f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7fa:	8b 48 04             	mov    0x4(%eax),%ecx
 7fd:	39 f1                	cmp    %esi,%ecx
 7ff:	73 4f                	jae    850 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 801:	8b 3d bc 0c 00 00    	mov    0xcbc,%edi
 807:	89 c2                	mov    %eax,%edx
 809:	39 d7                	cmp    %edx,%edi
 80b:	75 eb                	jne    7f8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 80d:	83 ec 0c             	sub    $0xc,%esp
 810:	ff 75 e4             	push   -0x1c(%ebp)
 813:	e8 73 fc ff ff       	call   48b <sbrk>
  if(p == (char*)-1)
 818:	83 c4 10             	add    $0x10,%esp
 81b:	83 f8 ff             	cmp    $0xffffffff,%eax
 81e:	74 1c                	je     83c <malloc+0x8c>
  hp->s.size = nu;
 820:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 823:	83 ec 0c             	sub    $0xc,%esp
 826:	83 c0 08             	add    $0x8,%eax
 829:	50                   	push   %eax
 82a:	e8 f1 fe ff ff       	call   720 <free>
  return freep;
 82f:	8b 15 bc 0c 00 00    	mov    0xcbc,%edx
      if((p = morecore(nunits)) == 0)
 835:	83 c4 10             	add    $0x10,%esp
 838:	85 d2                	test   %edx,%edx
 83a:	75 bc                	jne    7f8 <malloc+0x48>
        return 0;
  }
}
 83c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 83f:	31 c0                	xor    %eax,%eax
}
 841:	5b                   	pop    %ebx
 842:	5e                   	pop    %esi
 843:	5f                   	pop    %edi
 844:	5d                   	pop    %ebp
 845:	c3                   	ret    
    if(p->s.size >= nunits){
 846:	89 d0                	mov    %edx,%eax
 848:	89 fa                	mov    %edi,%edx
 84a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 850:	39 ce                	cmp    %ecx,%esi
 852:	74 4c                	je     8a0 <malloc+0xf0>
        p->s.size -= nunits;
 854:	29 f1                	sub    %esi,%ecx
 856:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 859:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 85c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 85f:	89 15 bc 0c 00 00    	mov    %edx,0xcbc
}
 865:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 868:	83 c0 08             	add    $0x8,%eax
}
 86b:	5b                   	pop    %ebx
 86c:	5e                   	pop    %esi
 86d:	5f                   	pop    %edi
 86e:	5d                   	pop    %ebp
 86f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 870:	c7 05 bc 0c 00 00 c0 	movl   $0xcc0,0xcbc
 877:	0c 00 00 
    base.s.size = 0;
 87a:	bf c0 0c 00 00       	mov    $0xcc0,%edi
    base.s.ptr = freep = prevp = &base;
 87f:	c7 05 c0 0c 00 00 c0 	movl   $0xcc0,0xcc0
 886:	0c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 889:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 88b:	c7 05 c4 0c 00 00 00 	movl   $0x0,0xcc4
 892:	00 00 00 
    if(p->s.size >= nunits){
 895:	e9 42 ff ff ff       	jmp    7dc <malloc+0x2c>
 89a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 8a0:	8b 08                	mov    (%eax),%ecx
 8a2:	89 0a                	mov    %ecx,(%edx)
 8a4:	eb b9                	jmp    85f <malloc+0xaf>
