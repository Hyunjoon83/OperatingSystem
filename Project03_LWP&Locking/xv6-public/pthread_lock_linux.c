#include <stdio.h>
#include <pthread.h>

int shared_resource = 0;

#define NUM_ITERS 100
#define NUM_THREADS 100

void lock();
void unlock();

typedef struct {
    volatile int flag[NUM_THREADS]; // lock 상태
    volatile int turn[NUM_THREADS]; // 차례
} lock_t;

lock_t mutex;

void lock(int thread_id)
{
    for(int j=0; j<NUM_THREADS; j++){
        mutex.turn[j] = thread_id; // j번째 스레드의 차례
        mutex.flag[thread_id] = j; // j번째 스레드의 flag

        if(j == thread_id) // 자신의 차례일 때 -> critical section 진입
            break;
        else{
            for(int k=0; k<NUM_THREADS; k++){
                if(mutex.flag[k] != j && mutex.turn[j] == thread_id){ 
                    break;
                }
            }
        }
    }
}

void unlock(int thread_id) 
{
    mutex.flag[thread_id] = 0; 
}


void* thread_func(void* arg) {
    int tid = *(int*)arg; // *(int*)arg : arg가 가리키는 주소에 있는 값을 int로 변환
    
    lock(tid);
    
        for(int i = 0; i < NUM_ITERS; i++)    shared_resource++; // critical section
    
    unlock(tid);
    
    pthread_exit(NULL);
}

int main() {
    int n = NUM_THREADS;
    pthread_t threads[n];
    int tids[n];
    
    for (int i = 0; i < n; i++) {
        tids[i] = i;
        pthread_create(&threads[i], NULL, thread_func, &tids[i]);
    }
    
    for (int i = 0; i < n; i++) {
        pthread_join(threads[i], NULL);
    }

    printf("shared: %d\n", shared_resource);
    
    return 0;
}