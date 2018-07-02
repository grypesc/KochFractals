#include <stdio.h>
#include <stdlib.h>

char image[3000054];
int width=1000;
int height=1000;
char* pixelArray;//wskazanie na pierwszy piksel

extern void paintPixel(int x, int y);
extern void drawLine(int x1, int y1, int x2, int y2);
extern void kochRecursion(int x1, int y1, int x2, int y2, int depth);

void createBMP();
void saveImage();
////////////////////////////////////////////////////////////////////////////////

int main()
{
  char c;
  int vertexArray[60];
  puts("**********************************\nKochs curves");
  int x1,y1,x2,y2, depth,i,j, scanfDepthOnly=0;
  while(1)
  {
    if(scanfDepthOnly==0)
    {
      i=0, j=0;
      puts("Enter coordinates of first vertex, x and y must range from 200 to 800");
      while (scanf("%d %d",&x1,&y1 )==2)
      {
        while ( getchar() != '\n' );
        if(x1<=199 || x1>=801 || y1<=199 || y1>=801){
          puts("x and y must be beetwen 200 and 800, enter the point once again");
          continue;
        }
        vertexArray[i]=x1;
        i++;
        vertexArray[i]=y1;
        i++;
        if (i>=60)
          break;
        puts("Enter coordinates of next vertex, type 'w' once you have finished");
      }
    while ( getchar() != '\n' );
    }
    puts ("Enter the depth of recursion");
    scanf(" %d", &depth);

    createBMP();
    for (j=0;j<i-2;j=j+2)
      kochRecursion(vertexArray[j],vertexArray[j+1],vertexArray[j+2],vertexArray[j+3],depth);
    kochRecursion(vertexArray[i-2],vertexArray[i-1],vertexArray[0],vertexArray[1],depth);
    saveImage();
    puts("Curve was exported to out.bmp.\nz - change of the depth of recursion\nu - create a new curve \nw - exit");
    scanfDepthOnly=0;
    scanf(" %c", &c);
    while ( getchar() != '\n' );
    if (c=='w') break;
    if (c=='z') { scanfDepthOnly=1;}

  }
	return 0;
}


////////////////////////////////////////////////////////////////////////////////

void createBMP()
{
  FILE *f = fopen("../in.bmp", "r");
  if (f==NULL){
    puts("Couldn't find in.bmp");
    exit(0);
  }
  char current;
  int i;
  for (i=0;i<3000054;i++)
  {
    fscanf(f, "%c",&current);
    image[i]=current;
  }
  pixelArray=image+54;
  fclose(f);
}

void saveImage()
{
  FILE *file = fopen("out.bmp", "w");
  int i=0;
  for(i;i<3000054;i++)
    fprintf(file,"%c", image[i]);
  fclose(file);
}
