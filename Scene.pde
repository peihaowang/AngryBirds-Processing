
class Scene
{

  ArrayList<Box>      m_boxes;
  ArrayList<Boundary> m_boundaries;
  
  ArrayList<Bird>     m_birds;
  ArrayList<Pig>      m_pigs;
  
  PVector             m_catapultCenter;
  PVector             m_catapultInner;
  PVector             m_catapultOuter;
  
  boolean             m_dragging;

  boolean             m_leapMotion;
  
  Scene()
  {
    m_boundaries = new ArrayList<Boundary>();
    m_boundaries.add(new Boundary(width / 2, -10, width, 20));  //top
    m_boundaries.add(new Boundary(width / 2, height + 10, width, 20));  //bottom
    m_boundaries.add(new Boundary(-10, height / 2, 20, height));  //left
    m_boundaries.add(new Boundary(width + 10, height / 2, 20, height)); //right
    
    m_boxes = new ArrayList<Box>();
    m_birds = new ArrayList<Bird>();
    m_pigs = new ArrayList<Pig>();

    m_catapultCenter = new PVector(150, height - 150);
    m_catapultInner = new PVector(170, height - 150);
    m_catapultOuter = new PVector(130, height - 150);

    m_dragging = false;
    
    m_leapMotion = true;
  }
  
  void addPig(Pig pig) { m_pigs.add(pig); }
  void addBox(Box box) { m_boxes.add(box); }

  void addBird(Bird bird)
  {
    m_birds.add(bird); int i = m_birds.size() - 1;
    if(i == 0){
      bird.m_pos.set(m_catapultCenter);
    }else{
      bird.m_pos.set(m_catapultCenter.x - i * 30, height - 20);
    }
  }

  void onDraw()
  {
      background(255);

      pushMatrix();
      pushStyle();
      // We must always step through time!
      box2d.step();
    
      // Boxes that leave the screen, we delete them
      // (note they have to be deleted from both the box2d world and our list
    
      for(Boundary b : m_boundaries){
        b.onUpdate();
      }
    
      for(int i = m_boxes.size() - 1; i >= 0; i--){
        Box b = m_boxes.get(i);
        b.onUpdate();
        if(b.onIntrospect()){
          m_boxes.remove(i);
        }
      }
        
      for(int i = m_pigs.size() - 1; i >= 0; i--){
        Pig p = m_pigs.get(i);
        p.onUpdate();
        if(p.onIntrospect()){
          m_pigs.remove(i);
        }
      }

      PVector birdJoint = new PVector(-1.0, -1.0);
      if(!m_birds.isEmpty()){
        Bird b = m_birds.get(0);
        if(!b.gone()){
          birdJoint.set(b.m_pos.x <= m_catapultCenter.x ? b.m_pos.x - b.m_w / 2 : b.m_pos.x + b.m_w / 2, b.m_pos.y);
        }
      }
      
      imageMode(CENTER);
      image(imgCatapultRight, m_catapultCenter.x, height - 100);

      if(birdJoint.x >= 0 && birdJoint.y >= 0){
        strokeWeight(5);
        stroke(0);
        line(birdJoint.x, birdJoint.y, m_catapultInner.x, m_catapultInner.y);
      }
      
      for(int i = m_birds.size() - 1; i >= 0; i--){
        Bird b = m_birds.get(i);
        b.onUpdate();
        if(b.onIntrospect()){
          m_birds.remove(i);
          if(!m_birds.isEmpty()){
            Bird nextBird = m_birds.get(0);
            nextBird.m_pos.set(m_catapultCenter.x, m_catapultCenter.y);
          }
        }
      }

      if(birdJoint.x >= 0 && birdJoint.y >= 0){
        strokeWeight(5);
        stroke(0);
        line(birdJoint.x, birdJoint.y, m_catapultOuter.x, m_catapultOuter.y);
      }

      imageMode(CENTER);
      image(imgCatapultLeft, m_catapultCenter.x, height - 100);

      // Leap motion controlling
      if(m_leapMotion){
        for(Hand hand : leapMotion.getHands()){
          PVector handPosition = hand.getPosition();
          float handGrab = hand.getGrabStrength();
          //println(handPosition.x, handPosition.y);
          
          // Keep tweak the range of x, y to make the operation better
          float handX = map(handPosition.x, 700, 1400, 0, width);
          float handY = map(handPosition.y, 400, 700, 0, height);
          float handWidth = 70, handHeight = 70;
          
          if(handX < handWidth / 2) handX = handWidth / 2;
          else if(handX > width - handWidth / 2) handX = width - handWidth / 2;
          if(handY < handHeight / 2) handY = handHeight / 2;
          else if(handY > height - handHeight / 2) handY = height - handHeight / 2;

          tint(255, 225);
          if(handGrab >= 0.8){
            onCursorDragged(handX, handY);
            imageMode(CENTER);
            image(imgCloseHand, handX, handY, 60, 60);
          }else{
            onCursorReleased(handX, handY);
            imageMode(CENTER);
            image(imgOpenHand, handX, handY, 60, 60);
          }
          //hand.draw();
        }
      }
      
      popStyle();
      popMatrix();
  }
  
  void onCursorDragged(float x, float y)
  {
    if(!m_birds.isEmpty()){
      Bird b = m_birds.get(0);
      if(!b.gone() && b.m_pos.x - b.m_w / 2 < x && x < b.m_pos.x + b.m_w / 2 && b.m_pos.y - b.m_h / 2 < y && y < b.m_pos.y + b.m_h / 2){
        if(!m_dragging) m_dragging = true;
      }
      if(m_dragging){
        float theta = atan2(y - m_catapultCenter.y, x - m_catapultCenter.x);
        float dist = sqrt(pow(x - m_catapultCenter.x, 2.0) + pow(y - m_catapultCenter.y, 2.0)), maxDist = sqrt(pow(70 * cos(theta), 2.0) + pow(30 * sin(theta), 2.0));
        float birdX = x, birdY = y;
        if(dist > maxDist){
          birdX = m_catapultCenter.x + maxDist * cos(theta);
          birdY = m_catapultCenter.y + maxDist * sin(theta);
        }
        b.m_pos.set(birdX, birdY);
      }
    }
  }
  
  void onCursorReleased(float x, float y)
  {
    if(m_dragging){
      m_dragging = false;
      if(!m_birds.isEmpty()){
        Bird b = m_birds.get(0);
        if(!b.gone()){
          float dist = sqrt(pow(x - m_catapultCenter.x, 2.0) + pow(y - m_catapultCenter.y, 2.0));
          m_birds.get(0).go(dist / 2, new Vec2(m_catapultCenter.x, m_catapultCenter.y));
        }
      }
    }
  }

}
