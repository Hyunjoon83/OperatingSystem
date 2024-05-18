#include <stdio.h>
#include <pthread.h>
#include <stdbool.h>

int shared_resource = 0;

#define NUM_ITERS 10000
#define NUM_THREADS 1000

void lock();
void unlock();

typedef struct {
    volatile bool flag[NUM_THREADS]; // true: 자신의 차례, false: 아직 자신의 차례가 아님
    volatile int turn[NUM_THREADS]; // 현재 thread의 번호
} lock_t;

lock_t mutex;

void init_lock(lock_t *m){
    for(int i=0; i<NUM_THREADS; i++){
        m->flag[i] = false;
        m->turn[i] = 0;
    }
}

void lock(int tid){
    mutex.flag[tid] = true; // 자신의 차례를 알림

    int max = 0;
    for(int i=0; i<NUM_THREADS; i++){
        if(max < mutex.turn[i]){ 
            max = mutex.turn[i];
        }
    }

    mutex.turn[tid] = max + 1; // 현재 thread의 번호
    mutex.flag[tid] = false; // 아직 자신의 차례가 아님

    for(int j=0; j<NUM_THREADS; j++){
        while(mutex.flag[j]); 
        while(mutex.turn[j] != 0 && (mutex.turn[j] < mutex.turn[tid] || (mutex.turn[j] == mutex.turn[tid] && j < tid)));
    }
}

void unlock(int tid) {
    mutex.turn[tid] = 0; 
}


void* thread_func(void* arg) {
    int tid = *(int*)arg; // *(int*)arg : arg가 가리키는 주소에 있는 값을 int로 변환
    
    lock(tid);
    
        for(int i = 0; i < NUM_ITERS; i++)    shared_resource++; // critical section
    
    unlock(tid);
    
    pthread_exit(NULL);
}

int main() {
    pthread_t threads[NUM_THREADS];
    int tids[NUM_THREADS];
    
    for (int i = 0; i < NUM_THREADS; i++) {
        tids[i] = i;
        pthread_create(&threads[i], NULL, thread_func, &tids[i]);
    }
    
    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    printf("shared: %d\n", shared_resource);
    
    return 0;
}