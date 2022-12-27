#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc,char **argv)
{
	unsigned long int i,n;
	
	if (argc!=3)
	{
		fprintf(stderr,"Usage: %s <count> <wait>\n",argv[0]);
		return 1;
	}
	
	n=strtoul(argv[1],NULL,10);
	
	for (i=0;i<n;i++)
	{
		putchar('1');
	}
	fclose(stdout);
	
	sleep(strtoul(argv[2],NULL,10));
	
	return 0;
}