#include <stdio.h>
#include <string.h> 
#define MAXQ 9300000
#define MAXL 21

int e[MAXQ+1]; char f[MAXQ+1]; char used[265000][MAXL+1];
int begin,end,N;
char s[MAXL];int D[MAXQ];

void encod(char* s,int* x,char* y)
{
    int i=0,flag=1;
    *x=0;
    while(s[i]!='O')
    {
       if(s[i]=='A') *x=(*x<<1)+1;
       else *x=(*x<<1); 
       i++;
    }   
    *y=2*N-i-2;i+=2;
    while(s[i]!='\0')
    {
       if(s[i]=='A') *x=(*x<<1)+1;
       else *x=(*x<<1); 
       i++;
    }                    
}
        
void decod(char* s,int x,char y)
{
    int i=2*N-1,j;
    s[2*N]='\0';
    for(j=1;j<=y;j++)
    {
       if(x%2==1) s[i--]='A';
       else s[i--]='B';
       x/=2;
    }      
    s[i--]='O';s[i--]='O';
    while(i>=0)
    {
       if(x%2==1) s[i--]='A';
       else s[i--]='B';
       x/=2;
    }      
}           

void gener()
{
     int i,j=0;int x;char y,a[MAXL],b[MAXL];
     decod(a,e[begin],f[begin]);
//printf("gener a=%s\n",a); 
     while(a[j]!='O') j++;
     for(i=0;i<2*N-1;i++)
     {  
        if(a[i]!='O'&& a[i+1]!='O')
        {
           strcpy(b,a);           
           b[j]=a[i];b[j+1]=a[i+1];b[i]='O';b[i+1]='O';
           encod(b,&x,&y);
//           printf("gener %d %d\n",x,y);        
           if(!used[x][y]) 
           {  e[++end]=x;f[end]=y;used[x][y]=1;D[end]=begin;
//              printf("e=%d f=%d\n",e[end],f[end]);
           }   
        }
     }                                             
}
int check()
{
    int i=0,j=0;char s[MAXL+1];
    decod(s,e[begin],f[begin]);
    while(s[i]!='B')
    {   
      if(s[i]=='A')j++;
      i++;
    }  
    if(j==N-1) return 1;
    else return 0;
}   
 
 int BFS()
{  int x,y,i; 
   begin=0;end=-1;
   ++end;encod(s,&e[end],&f[end]);used[e[end]][f[end]]=1;D[end]=-1;
//printf("e=%d f=%d\n",e[end],f[end]);   
   while(begin<=end)
    { 
       if(check()) return begin;                        
       gener();begin++;
    }
    return -1;
 }
int main()
{
    int i,j,k,t,T;
    scanf("%d",&T);
for(t=1;t<=T;t++)
{        
    scanf("%s",s);N=strlen(s)/2;
    j=1<<2*N-2;
    for(i=0;i<j;i++)
       for(k=0;k<=2*N;k++)
          used[i][k]=0;
    i=BFS();
    j=0;
    if(i>=0)
    {  do
       {
//         decod(s,e[i],f[i]);   
//         printf("%s\n",s);
         i=D[i];if(i>=0)j++;
         }  
       while(i>=0);     
       printf("%d\n",j);
    }   
    else printf("-1\n");   
}    
}
