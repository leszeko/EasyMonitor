/*hdmon.c
 display disk activity in %
 need /sys (2.6 kernels)
 
 Usage: hdmon hdx
*/

#include <stdio.h>
#include <time.h>

int usage(char* progname)
{
 printf("Usage:\n");
 printf("      %s sdx hdx\n",progname);
}

int main(int argc, char** argv)
{
 FILE* stats;
 char str[100];
 char* field=NULL;
 char* diskname=NULL;
 char filename[100];
 int new_value=0;
 int old_value=0;
 int i=0; 
 struct timespec ts;
 struct timespec rem;
 
 ts.tv_sec=0;
 ts.tv_nsec=500000000;
 
 if (argc!=2)
  {
   usage(argv[0]);
   return(1);
  }
  
 diskname = argv[1];
 strcpy(filename,"/sys/block/");
 strcat(filename,diskname);
 strcat(filename,"/stat");
 
 
 while (i<2)
 {
  stats=fopen(filename,"r");
  if (stats==NULL) 
    {
     printf ("Device %s not found...\n\n", argv[1]);
     usage(argv[0]);
     return(1);
    }
  fread(str,99,1,stats);
  field=str+83;
  field[10]=0;
  old_value=new_value;
  new_value=atoi(field);
  if (i) 
   printf("%i\n",(new_value-old_value)/5);
  fclose(stats);
  i++;
  if (i<2) 
   nanosleep(&ts,&rem);
 }
 return(0);
}
