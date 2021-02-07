#include <stdio.h>
#include <string.h>

#define MAXCHAR 1500        // assume one line length is lower than 1500 characters


void removeMultilineComments(char* line, int* ifInsideComment);
void removeOneLineComments(char* line, int* ifInsideComment);

int main(void) {
    char *inputFileName = "./simpsonsIntegration2.c";
    char line[MAXCHAR];
    int ifInsideComment = 0;          // True Flase - auxilary variable 

    FILE *inputFile = fopen(inputFileName, "r");
    FILE *outputFile = fopen("simpsonsIntegrationNoComments.c", "w");
    
    if (inputFile == NULL) {               // check if file exists
        printf("Could not open file %s", inputFileName);
        return 1;
    }

    while (fgets(line, MAXCHAR, inputFile) != NULL) {      // read file line by line
        removeOneLineComments(line, &ifInsideComment);
        removeMultilineComments(line, &ifInsideComment);

        fputs(line, outputFile);        // append to file
    }

    fclose(inputFile);
    fclose(outputFile);        // safe finish file edition
    return 0;
}

void removeOneLineComments(char* line, int* ifInsideComment) {      // remove one line comments
    char* start = strstr(line, "//");

    if(start != NULL) {
        *start = '\n';
        *(start + 1) = '\0';
        *ifInsideComment = 0;
    } else return;
}

void removeMultilineComments(char* line, int* ifInsideComment) {      // recursion function to remove multiline comments

    if(*ifInsideComment == 1) {
        char* finish = strstr(line, "*/");

        if(finish != NULL) {
            finish = finish + 2;
            *ifInsideComment = 0;
            removeMultilineComments(finish, ifInsideComment);
            *line = '\0';
            strcat(line, finish);
            return;
        }

        *line = '\0';
        return;
    }

    char* start = strstr(line, "/*");
    if(start == NULL) {
        return;
    }

    char* finish = strstr(start, "*/");
    *start = '\0';
    if(finish == NULL) {
        strcat(line, "\n");
        *ifInsideComment = 1;
        return;
    }
    finish = finish + 2;                  // nie bierz konca komentarza "*/" do kodu

    removeMultilineComments(finish, ifInsideComment);
    strcat(line, finish);

}