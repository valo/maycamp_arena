#include <stdio.h>
#include <stdlib.h>
#include <string.h>

long long a[62][62];
char s[65];


void initTable()
{
   int i,j;
   for(i=0;i<60;i++)
      for(j=0;j<60;j++)
         a[i][j]=(long long)0;
}

long long get()
{
   int i,j;
   for(j=1;j<=strlen(s);j++)
      for(i=0;i<strlen(s)+1-j;i++)
      {
         if(j==1) a[i][j]=1;
         else if(j==2)
              { 
                if(s[i]==s[i+1]) a[i][j]=3;
                else a[i][j]=2;
              }
              else
              {
                a[i][j]=a[i][j-1]+a[i+1][j-1];
                if(s[i]!=s[i+j-1]) a[i][j]-=a[i+1][j-2];
                else a[i][j]+=1; 
              }                                       
      }
      
}

void show(long long n)
{
   int d,i; char s[65];
   strcpy(s,"");
   do
   {
         d=(n-(n/10)*10);
         for(i=strlen(s)+1;i>0;i--)s[i]=s[i-1];
         s[0]='0'+d;
         n=(n/10);
   }       
   while(n!=0);
   printf("%s\n",s);
 }
int main()
{
  int t,T,i,j;
  scanf("%d",&T);
  for(t=1;t<=T;t++)
  {  
   scanf("%s",s);
   initTable();
   get();
   show(a[0][strlen(s)]);
  }
}
