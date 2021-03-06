class Map {
  int[][] worldMap=
  {
    {8,8,8,8,8,8,8,8,8,8,8,4,4,6,4,4,6,4,6,4,4,4,6,4},
    {8,0,0,0,0,0,0,0,0,0,8,4,0,0,0,0,0,0,0,0,0,0,0,4},
    {8,0,3,3,0,0,0,0,0,8,8,4,0,0,0,0,0,0,0,0,0,0,0,6},
    {8,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6},
    {8,0,3,3,0,0,0,0,0,8,8,4,0,0,0,0,0,0,0,0,0,0,0,4},
    {8,0,0,0,0,0,0,0,0,0,8,4,0,0,0,0,0,6,6,6,0,6,4,6},
    {8,8,8,8,0,8,8,8,8,8,8,4,4,4,4,4,4,6,0,0,0,0,0,6},
    {7,7,7,7,0,7,7,7,7,0,8,0,8,0,8,0,8,4,0,4,0,6,0,6},
    {7,7,0,0,0,0,0,0,7,8,0,8,0,8,0,8,8,6,0,0,0,0,0,6},
    {7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,6,0,0,0,0,0,4},
    {7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,6,0,6,0,6,0,6},
    {7,7,0,0,0,0,0,0,7,8,0,8,0,8,0,8,8,6,4,6,0,6,6,6},
    {7,7,7,7,0,7,7,7,7,8,8,4,0,6,8,4,8,3,3,3,0,3,3,3},
    {2,2,2,2,0,2,2,2,2,4,6,4,0,0,6,0,6,3,0,0,0,0,0,3},
    {2,2,0,0,0,0,0,2,2,4,0,0,0,0,0,0,4,3,0,0,0,0,0,3},
    {2,0,0,0,0,0,0,0,2,4,0,0,0,0,0,0,4,3,0,0,0,0,0,3},
    {1,0,0,0,0,0,0,0,1,4,4,4,4,4,6,0,6,3,3,0,0,0,3,3},
    {2,0,0,0,0,0,0,0,2,2,2,1,2,2,2,6,6,0,0,5,0,5,0,5},
    {2,2,0,0,0,0,0,2,2,2,0,0,0,2,2,0,5,0,5,0,0,0,5,5},
    {2,0,0,0,0,0,0,0,2,0,0,0,0,0,2,5,0,5,0,5,0,5,0,5},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5},
    {2,0,0,0,0,0,0,0,2,0,0,0,0,0,2,5,0,5,0,5,0,5,0,5},
    {2,2,0,0,0,0,0,2,2,2,0,0,0,2,2,0,5,0,5,0,0,0,5,5},
    {2,2,2,2,1,2,2,2,2,2,2,1,2,2,2,5,5,5,5,5,5,5,5,5}
  };
  
  float[] cast(PVector rayPos, PVector rayDir) {
    //length of ray from current position to next x or y-side
    PVector sideDist = new PVector();
  
     //length of ray from one x or y-side to next x or y-side
    PVector deltaDist = new PVector(sqrt(1 + (rayDir.y * rayDir.y) / (rayDir.x * rayDir.x)), 
                                    sqrt(1 + (rayDir.x * rayDir.x) / (rayDir.y * rayDir.y)));
  
    //which box of the map we're in
    PVector map = new PVector(int(rayPos.x), int(rayPos.y));
    
    int hit = 0; //was there a wall hit?
    int side = 0; //was a NS or a EW wall hit?
    
    //what direction to step in x or y-direction (either +1 or -1)
    PVector step = new PVector();
    
    //calculate step and initial sideDist
    if (rayDir.x < 0) {
      step.x = -1;
      sideDist.x = (rayPos.x - map.x) * deltaDist.x;
    }
    else {
      step.x = 1;
      sideDist.x = (map.x + 1.0 - rayPos.x) * deltaDist.x;
    }
    if (rayDir.y < 0) {
      step.y = -1;
      sideDist.y = (rayPos.y - map.y) * deltaDist.y;
    }
    else {
      step.y = 1;
      sideDist.y = (map.y + 1.0 - rayPos.y) * deltaDist.y;
    }
    //perform DDA
    while (hit == 0) {
      //jump to next map square, OR in x-direction, OR in y-direction
      if (sideDist.x < sideDist.y) {
        sideDist.x += deltaDist.x;
        map.x += step.x;
        side = 0;
      }
      else {
        sideDist.y += deltaDist.y;
        map.y += step.y;
        side = 1;
      }
      //Check if ray has hit a wall
      if (worldMap[int(map.x)][int(map.y)] > 0) hit = 1;
    }
    
    //Calculate distance projected on camera direction (oblique distance will give fisheye effect!)
    float perpWallDist;
    if (side == 0) perpWallDist = (map.x - rayPos.x + (1 - step.x) / 2) / rayDir.x;
    else           perpWallDist = (map.y - rayPos.y + (1 - step.y) / 2) / rayDir.y;
    
    return new float[] {map.x, map.y, side, perpWallDist};
  }
}