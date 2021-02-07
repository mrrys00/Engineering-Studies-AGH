// Check if all brackets are correctly started and closed

#include <stdio.h>

int search_for_bracket(char bracket_close, int level) {
	char c;
	int res;
	do {
//		c=fgetc(stdin);
        c = getchar();
		if(c == bracket_close) {
			if(c=='\n') return level;
			return 0;                                    // OK - proper finish
	    }
		res = 0;
		switch(c) {
			case '\n': return -2;                        // Err - unexpected finish
			case ')': case ']': case '}':   return -1;   // Err - wrong finish
			case '(':  res = search_for_bracket(')', level+1);  break;
			case '[':  res = search_for_bracket(']', level+1);  break; 
			case '{':  res = search_for_bracket('}', level+1);  break; 
		} 
	}	while(res==0);		
	return res;
}
int main(void) {
	int res, level = 0;
	printf("Wpisuj kolejne wyrazenia, az do niepoprawnego: \n");
    do {
		res = search_for_bracket('\n',level);    // EOF
	    if(res==0) printf("Poprawny. Wpisz nastepny\n");
	} while(res==0);
	printf("BLAD!!! - koniec\n");
	return 0;
}
