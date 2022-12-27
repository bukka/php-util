#include <stdio.h>
#include <errno.h>

#define BUF_SIZE 64

int main(int argc,char **argv)
{
	char buf[BUF_SIZE];
	size_t n;
	FILE *fp;
	
	if (argc!=2)
	{
		fprintf(stderr,"Usage: %s <fifo>\n",argv[0]);
		return 1;
	}

	fp=fopen(argv[1],"r");
	if (!fp)
	{
		perror("fopen");
		return 0;
	}
	
	while ((n=fread(buf,1,BUF_SIZE,fp))==BUF_SIZE) fprintf(stderr,"n: %zu ",n);
	if (errno!=0) perror("fread");
	fprintf(stderr,"n: %zu EOF: %d\n",n,feof(fp));
	
	return 0;
}