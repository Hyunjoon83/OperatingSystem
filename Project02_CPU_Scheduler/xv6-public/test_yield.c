#include "types.h"
#include "stat.h"
#include "user.h"

#define NUM_LOOP 100

int main(int argc, char *argv[]){
    // Parent와 Child가 번갈아가면서 실행되는지 확인
    int pid = fork();
    if (pid == 0){ // Child process
        for (int i = 0; i < NUM_LOOP; i++){
            printf(1, "Child\n");
            yield();
        }
    }else{ // Parent process
        for (int i = 0; i < NUM_LOOP; i++){
            printf(1, "Parent\n");
            yield();
        }
        wait();
    }
    exit();
}