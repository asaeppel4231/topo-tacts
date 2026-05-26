#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char begin_comment[11];
char end_comment  [11];
char comment_char;
char banner_text  [256];

int banner_width;

int get_text_begin_pos(char* banner_text){
    int inner_space = banner_width - 2;
    int remaining   = inner_space - strlen(banner_text);
//    printf("Remaining: %d\n", remaining);
    return remaining / 2;
}

void remove_newline_from_string(char* string){
    if( strchr(string, '\n') ){
        string[strlen(string)-1] = '\0';
    }
}

int main(){
    printf("Please input a string of the begin of a comment: ");
    fgets(begin_comment, 11, stdin);
    remove_newline_from_string(begin_comment);
    printf("Please input a string of the end of a comment: ");
    fgets(end_comment, 11, stdin);
    remove_newline_from_string(end_comment);
    printf("Please input a character to decorate the banner: ");
    int ch;
    comment_char = fgetc(stdin);
    while((ch = getchar()) != '\n' && ch != EOF ) {}
    printf("\n");
    printf("Please input your banner text: ");
    fgets(banner_text, 256, stdin);
    remove_newline_from_string(banner_text);
    printf("Please input the banner width: ");
    char buf[11];
    fgets(buf, 11, stdin);
    banner_width = (int) strtol(buf, NULL, 10);
    if( banner_width < strlen(banner_text) ){
        return -1;
    }
    printf("Here's your banner (you may copy it to your clipboard): \n");
    printf("%s", begin_comment);
    for( int i= 0; i < banner_width-1-strlen(begin_comment); i++ ){
        printf("%c", comment_char);
    }
    printf("\n");
    printf("%c", comment_char);
    for( int i=0; i < get_text_begin_pos(banner_text)-1; i++ ){
        printf(" ");
    }
    printf("%s", banner_text);
    for( int i=0; i < (banner_width - 2) - strlen(banner_text) - get_text_begin_pos(banner_text); i++ ){
        printf(" ");
    }
    printf("%c", comment_char);
    printf("\n");
    for( int i= 0; i < banner_width-1-strlen(end_comment); i++ ){
        printf("%c", comment_char);
    }
    printf("%s", end_comment);
    printf("\n");
}
