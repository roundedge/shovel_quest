//level type flags
int GRASS=0;
int DIRT=1;
int EARTH=2;

//screen dimensions
int screenWidth=400;
int screenHeight=400;

//world dimensions
int depth=20;
int levelWidth=40;
int levelHeight=40;


//square proportions
float squareWidth=10;
float squareHeight=10;

//Player Character info
int pi=10;
int pj=10;
int pz=0;



class terrain{//each square on the gamelevel will contain a terrain object, this is the base class
  boolean SOLID;
  int I,J,Z;
  world W;
  
   terrain(boolean solid,int IPos,int JPos, int ZPos, world w){
     SOLID=solid;
     I=IPos;
     J=JPos;
     Z=ZPos;
     W=w;
   } 

   void dig(){
      terrain temp = new terrain(SOLID,I,J,Z,W);
      ondig(temp);
   } 
 
   void ondig(terrain T){
      level lev=W.levels[Z];
      lev.landScape[I][J]=T; 
   }
 
 
   void display(float x, float y){
     fill(255,0,255);
     rect(x,y,squareWidth,squareHeight); 
   }
  
}




class grass extends terrain{
 
   grass(int i,int j, int z, world w){
      super(false,i,j,z,w); 
   } 
 
   void dig(){
    terrain temp=new dirt(super.I,super.J,super.Z,super.W);
    super.ondig(temp);  
   }

   void display(float x, float y){
     fill(0,255,0);
     noStroke();
     rect(x,y,squareWidth,squareHeight); 
   } 
}

class dirt extends terrain{
 
   dirt(int i,int j, int z, world w){
    super(false,i,j,z,w); 
   } 
 
   void dig(){
    terrain temp=new dirt(super.I,super.J,super.Z,super.W);
    super.ondig(temp);  
   }
 
   void display(float x, float y){
     fill(204,153,0);
     noStroke();
     rect(x,y,squareWidth,squareHeight);   
   }  
}


class earth extends terrain{
 
   earth(int i,int j, int z,world w){
    super(true,i,j,z,w); 
   } 
 
   void dig(){
    terrain temp=new dirt(super.I,super.J,super.Z,super.W);
    super.ondig(temp);  
   }
 
   void display(float x, float y){
     fill(0,255,0);
     noStroke();
     rect(x,y,squareWidth,squareHeight);
   }
} 


class level{//the game consists of a 'depth' number of levels, in a stack. they handle most of the world, including the locations of npcs and items
  terrain[][] landScape;
  ArrayList[][] junk; //a two dimensional array of arraylists, each arraylist contains the items at given points on the level
  ArrayList[][] dudes;// same as above, but for npcs
  int w,h,Z;
  int[] FLAGS; //level flags indicate what kind of objects are generated in the level, eg Geodes, rivers, pits, magma pockets 
  world W;
  
  level(int z,
        int WIDTH, int HEIGHT,
        int type, int[] flags, String fileName,
        world gw){
    
    Z=z;      
    w=WIDTH;
    h=HEIGHT;
    world W=gw;
    landScape= new terrain[w][h];
    junk= new ArrayList[w][h];
    dudes= new ArrayList[w][h];
    arraycopy(flags, FLAGS);
    constructLevel(type);
  }
  
  void constructLevel(int type){
     if(type==GRASS){
       for(int i=0; i<WIDTH; i++){
        for(int j=0; j<HEIGHT; j++){
          grass temp=new grass(i,j,Z,W);
          landScape[i][j]=temp;
        } 
       }
     }else if(type==EARTH){
        for(int i=0; i<WIDTH; i++){
         for(int j=0; j<HEIGHT; j++){
           earth temp=new earth(i,j,Z,W);
         }
        } 
     }
  }
  
  void display(float winWidth, float winHeight,
               float winX, float winY,
               float levX, float levY){
    fill(0,0,0);
    rect(winX,winY, winWidth, winHeight);
    //float levWidth=w*squareWidth;
    //float levHeight=h*squareHeight;
    float startItemp = (winX-levX)/squareWidth;
    if(startItemp<0){
      startItemp=0;
    }
    int endI =floor(startItemp+ (winWidth/squareWidth));
    int startI=floor(startItemp);
    
    float startJtemp = (winY-levY)/squareHeight;
    if(startJtemp<0){
     startJtemp=0; 
    }
    int endJ = floor(startJtemp+(winHeight/squareHeight));
    int startJ =floor(startJtemp);
    
    for(int i=startI; i<endI+1; i++){
      for(int j=startJ; j<endJ+1; j++){
         landScape[i][j].display(levX+i*squareWidth, levY+j*squareHeight);
      }
    }
  }
  
}

class world{
   int w,h,d;
   level[] levels;
   boolean initialized=false;
  
   world(int WIDTH, int HEIGHT, int DEPTH){
    w=WIDTH;
    h=HEIGHT;
    d=DEPTH;
    levels = new level[d];
   } 
  
   void init(int[] types, String[] levelFiles, world self){
      for(int i=0;i<d;i++){
        //generate level extras
        int[] flags=new int[1];
        flags[0]=2;
        //create level
        level tempLevel=new level(i,w,h,types[i],flags, levelFiles[i], self);
        levels[i]=tempLevel;
    } 
  }
}





world GameWorld= new world(levelWidth, levelHeight, depth);

void setup(){
  //construct level types by depth
  int[] types=new int[depth];
  for(int i=0; i<depth; i++){
    if(i==0){
     types[i]=GRASS; 
    }else{
     types[i]=EARTH; 
    }
  }
  
  //construct level files
  String[] levelFiles=new String[depth];
  for(int i=0; i<depth; i++){
     levelFiles[i]="none";
  }
  
  GameWorld.init(types, levelFiles, GameWorld);
  
}

void draw(){
  
}
