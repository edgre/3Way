#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>


#define STRT_E 0x0b0b
#define NMBR 11
#define ITERATIONS 100
typedef unsigned int word32;

void rndcon_gen(word32 strt, word32* rtab)
{ /* generates the round constants */
    int i;
    for (i = 0; i <= NMBR; i++)
    {
        rtab[i] = strt;
        strt <<= 1;
        if (strt&0x10000)strt ^= 0x11011;
    }
}



void gamma1(word32* a)
{
    word32 b[3];
    /* the nonlinear step */
    b[0] = a[0] ^ (a[1] | (~a[2]));
    b[1] = a[1] ^ (a[2] | (~a[0]));
    b[2] = a[2] ^ (a[0] | (~a[1]));

    a[0] = b[0]; a[1] = b[1]; a[2] = b[2];
}

void pi_1(word32* a)
{
    a[0] = (a[0] >> 10) ^ (a[0] << 22);
    a[2] = (a[2] << 1) ^ (a[2] >> 31);
}


void pi_2(word32* a)
{
    a[0] = (a[0] << 1) ^ (a[0] >> 31);
    a[2] = (a[2] >> 10) ^ (a[2] << 22);
}


void theta(word32* a)
{
    word32 b[3];
    b[0] = a[0] ^ (a[0] >> 16) ^ (a[1] << 16) ^ (a[1] >> 16) ^ (a[2] << 16) ^ (a[1] >> 24) ^ (a[2] << 8) ^ (a[2] >> 8) ^ (a[0] << 24) ^ (a[2] >> 16) ^ (a[0] << 16) ^ (a[2] >> 24) ^ (a[0] << 8);

    b[1] = a[1] ^ (a[1] >> 16) ^ (a[2] << 16) ^ (a[2] >> 16) ^ (a[0] << 16) ^
        (a[2] >> 24) ^ (a[0] << 8) ^ (a[0] >> 8) ^ (a[1] << 24) ^
        (a[0] >> 16) ^ (a[1] << 16) ^ (a[0] >> 24) ^ (a[1] << 8);

    b[2] = a[2] ^ (a[2] >> 16) ^ (a[0] << 16) ^ (a[0] >> 16) ^ (a[1] << 16) ^
        (a[0] >> 24) ^ (a[1] << 8) ^ (a[1] >> 8) ^ (a[2] << 24) ^
        (a[1] >> 16) ^ (a[2] << 16) ^ (a[1] >> 24) ^ (a[2] << 8);

    a[0] = b[0]; a[1] = b[1]; a[2] = b[2];

}

void rho(word32* a)
{
    theta(a);
    pi_1(a);
    gamma1(a);
    pi_2(a);
}


void encrypt(word32* a, word32* k)
{
    char i;
    word32 rcon[NMBR + 1];
    rndcon_gen(STRT_E, rcon);
    for (i = 0; i < NMBR; i++)
    {
        a[0] ^= k[0] ^ (rcon[i] << 16);
        a[1] ^= k[1];
        a[2] ^= k[2] ^ rcon[i];
        rho(a);
    }
    a[0] ^= k[0] ^ (rcon[NMBR] << 16);
    a[1] ^= k[1];
    a[2] ^= k[2] ^ rcon[NMBR];
    theta(a);
}

void check(char* ch)
{
    FILE *file = fopen("c_output.txt", "w");
    if (file == NULL) {
        fprintf(stderr, "Ошибка открытия файла!\n");
        exit(0);
    }

    srand(time(NULL)); // Инициализация генератора случайных чисел
    for (int i = 0; i < ITERATIONS; i++) {
        word32 input_a[3]; 
        input_a[0] = rand() & 0xFFFFFFFF; // Генерация случайного 32-битного числа
        input_a[1] = rand() & 0xFFFFFFFF; // Генерация случайного 32-битного числа
        input_a[2] = rand() & 0xFFFFFFFF; // Генерация случайного 32-битного числа
        

        word32 output_a[3];
        output_a[0] = input_a[0];
        output_a[1] = input_a[1];
        output_a[2] = input_a[2];

        if (ch=="pi_2") {pi_2(output_a);} // Применение функции pi_2
        if (ch=="gamma1") {gamma1(output_a);}
        if (ch=="pi_1") {pi_1(output_a);}
        if (ch=="theta") {theta(output_a);}
        printf("Input:  %u %u %u\n", input_a[0], input_a[1], input_a[2]);
        printf("Output: %u %u %u\n", output_a[0], output_a[1], output_a[2]);

        // Запись входных значений и выходных значений в файл
        fprintf(file, "%u %u %u %u %u %u\n", input_a[0], input_a[1], input_a[2], output_a[0], output_a[1], output_a[2]);
    }

    fclose(file); // Закрытие файла
}


void check_round_en(char* ch)
{
    FILE *file;
    if(ch=="round") file=fopen("c_output.txt", "w");
    if(ch=="encrypt") file=fopen("c_output.txt", "w");
    if (file == NULL) {
        fprintf(stderr, "Ошибка открытия файла!\n");
        exit(0);
    }

    srand(time(NULL)); // Инициализация генератора случайных чисел
    for (int i = 0; i < ITERATIONS; i++) {
        word32 input_a[3]; 
        input_a[0] = rand() & 0xFFFFFFFF; // Генерация случайного 32-битного числа
        input_a[1] = rand() & 0xFFFFFFFF; // Генерация случайного 32-битного числа
        input_a[2] = rand() & 0xFFFFFFFF; // Генерация случайного 32-битного числа
        
        word32 key[3];
        key[0] = rand() & 0xFFFFFFFF; // Генерация случайного 32-битного числа
        key[1] = rand() & 0xFFFFFFFF; // Генерация случайного 32-битного числа
        key[2] = rand() & 0xFFFFFFFF; // Генерация случайного 32-битного числа
        
        word32 output_a[3];
        output_a[0] = input_a[0];
        output_a[1] = input_a[1];
        output_a[2] = input_a[2];
        
        if (ch=="round") rho(output_a);
        if (ch=="encrypt") encrypt(output_a, key);
        
        printf("Input:  %u %u %u\n", input_a[0], input_a[1], input_a[2]);
        printf("Key:  %u %u %u\n", key[0], key[1], key[2]);
        printf("Output: %u %u %u\n", output_a[0], output_a[1], output_a[2]);

        // Запись входных значений и выходных значений в файл
        fprintf(file, "%u %u %u %u %u %u %u %u %u\n", input_a[0], input_a[1], input_a[2], output_a[0], output_a[1], output_a[2], key[0], key[1], key[2]);
     }


}


int main( int argc, char *argv[])
{
    if (argc < 2) {
        fprintf(stderr, "Ошибка: Не передан аргумент функции.\n");
        return 1;
    }
    if (strcmp(argv[1], "pi_2") == 0) {check("pi_2");}
    if (strcmp(argv[1], "gamma1") == 0) {check("gamma1");}
    if (strcmp(argv[1], "pi_1") == 0) {check("pi_1");}
    if (strcmp(argv[1], "theta") == 0) {check("theta");}
    if (strcmp(argv[1], "round") == 0) {check_round_en("round");}
    if (strcmp(argv[1], "encrypt") == 0) {check_round_en("encrypt");}
    
    return 0;
}
    
   
