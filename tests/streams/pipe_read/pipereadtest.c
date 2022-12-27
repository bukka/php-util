#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>

#define BUF_SIZE 8192

int main(int argc,char **argv)
{
	int fd[2];
	pid_t child;
	
	if (argc!=3)
	{
		execv("./closewait",argv);
		return 0;
	}
	
	if (0!=pipe(fd))
	{
		perror("fopen");
		return 0;
	}
	
	if ((child=fork())==0)
	{ //child
		close(fd[0]);
		dup2(fd[1],1);
		close(fd[1]);
		execv("./closewait",argv);
		// returns only on error
		perror("execv");
	}
	else if (child>0)
	{ //parent
		char buf[BUF_SIZE];
		size_t n;
		int desc;
		
		close(fd[1]);
		
		while ((n=read(fd[0], buf, BUF_SIZE)) == BUF_SIZE) fprintf(stderr,"n: %zu ",n);
		if (errno!=0) perror("read");
		fprintf(stderr,"n: %zu EOF: %d\n",n, n == 0);
	}
	else
	{ //fork error
		perror("fork");
	}
	
	return 0;
}