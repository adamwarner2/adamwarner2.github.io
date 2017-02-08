String[] names;
int[] values;
float[] centerX;
float[] centerY;
float[] labels;
float origX, origY;
float graphWidth, graphHeight;
String xName, yName;
int maxVal = 0;
float barWidth;
boolean bar = true;
float lerp;
void setup() {
  surface.setResizable(true);
  loadData();
}

void draw() {
  background(200, 200, 200);
  drawAxes();
  if (bar) {
    drawBar();
  } else {
    drawLine();
  }


  checkMouse();
}

void loadData() {
  String[] lines = loadStrings("data.csv");
  String[] firstLine = split(lines[0], ",");
  xName = firstLine[0];
  yName = firstLine[1];
  names = new String[lines.length - 1];
  values = new int[lines.length - 1];
  centerX = new float[lines.length - 1];
  centerY = new float[lines.length - 1];


  for (int i = 1; i < lines.length; ++i) {
    String[] row = split(lines[i], ",");
    names[i-1] = row[0];
    values[i -1] = (int)parseFloat(row[1]);
    if (values[i-1] > maxVal) {
      maxVal = values[i-1];
    }
  }

  barWidth = (float) (width*0.9)/(names.length);

  for (int i=0; i<values.length; i++) {
    float h = (((float)values[i]/maxVal)*graphHeight);
    centerX[i] = (i*barWidth + 0.1*width) + 0.5*barWidth;
    centerY[i] = graphHeight-h;
  }
  
  float increment = maxVal/10.0;
  labels = new float[10];
  for(int i = 0; i < labels.length; ++i) {
    labels[i] = i*increment;
  }
  
}

void drawBar() {
  fill(226, 229, 100);
  barWidth = (float) (width*0.9)/(names.length);

  for (int i=0; i<values.length; i++) {
    float h = (((float)values[i]/maxVal)*graphHeight);
    rect(i*barWidth + 0.1*width, graphHeight-h, barWidth, h);
    //println("i: " + i  + " " + (graphHeight - h) + " max: " + maxVal + " height: " + h );
  }
}

void drawLine() {
  fill(226, 229, 100);
  barWidth = (float) (width*0.9)/(names.length);

  for (int i=0; i<values.length; i++) {
    float h = (((float)values[i]/maxVal)*graphHeight);
    ellipse((i*barWidth + 0.1*width) + 0.5*barWidth, graphHeight-h, graphWidth*0.02, graphHeight*0.02);
    centerX[i] = (i*barWidth + 0.1*width) + 0.5*barWidth;
    centerY[i] = graphHeight-h;
  }

  for (int i=0; i<values.length - 1; i++) {
    line(centerX[i], centerY[i], centerX[i + 1], centerY[i + 1]);
  }
}


void drawAxes() {
  origX = width*0.1;
  origY = height*0.9;
  graphWidth = width*0.9;
  graphHeight = height*0.9;
  barWidth = (float) (width*0.9)/(names.length);


  line(origX, origY, width, origY);
  line(origX, origY, origX, 0);

  fill(0, 102, 153);
  textSize(width*0.02);
  text(xName, graphWidth*0.5, height*0.98); 

  int x = (int)(graphWidth*0.02);
  int y = (int)(graphHeight * 0.5); 
  pushMatrix();
  translate(x, y);
  rotate(HALF_PI + PI);
  text(yName, 0, 0);
  popMatrix();

  fill(255, 255, 255);
  rect(width*0.9, 0, 0.1*width, height*0.05);

  fill(0, 0, 0);
  if (bar) {
    text("Line", width*0.92, height*0.04);
  } else {
    text("Bar", width*0.92, height*0.04);
  }

  for (int i = 0; i < values.length; ++i) {
    float h = (((float)values[i]/maxVal)*graphHeight);

    centerX[i] = (i*barWidth + 0.1*width) + 0.5*barWidth;
    centerY[i] = graphHeight-h;
    line(centerX[i], origY, centerX[i], 0.92*height);

    int x1 = (int)(centerX[i]);
    int y1 = (int)(height * 0.98); 
    pushMatrix();
    translate(x1, y1);
    rotate(HALF_PI + PI);
    text(names[i], 0, 0);
    popMatrix();
  }

  float increment = (graphHeight)/10;
  for (int i = 0; i < 10; ++i) {
    line(0.08*width, origY - (i*increment), origX, origY - (i*increment));
    text(labels[i], 0.02*width, origY - (i*increment));
  }
  
  
}

void checkMouse() {
  if (bar) {
    if ((mouseX > origX) && (mouseY < origY)) {
      int index = ((int)(mouseX/barWidth)) - 1;
      float barHeight = graphHeight - ((float)values[index]/maxVal)*graphHeight;
      if ((mouseY > barHeight) && (mouseY < origY) ) {
        fill(255, 255, 255);
        rect(mouseX, mouseY, graphWidth*0.1, graphHeight*0.1);
        String label = "(" + names[index] + "," + values[index] + ")";
        fill(0, 0, 0);
        textSize(width*0.0125);
        text(label, mouseX + graphWidth*0.02, mouseY + graphHeight*0.05);
      }
    }
  } else {
    /*for(int i = 0; i < values.length; ++i) {
     if((mouseX > (centerX[i] - graphWidth * 0.01)) && (mouseX < (centerX[i] + graphWidth * 0.01)) && (mouseY > (centerY[i] - graphHeight * 0.01)) && (mouseY < (centerY[i] + graphHeight * 0.01))) {
     println(i);
     }
     else {
     println(false);
     }
     }
     }*/
    if ((mouseX > origX) && (mouseY < origY)) {
      int index = ((int)(mouseX/barWidth)) - 1;
      //float barHeight = graphHeight - ((float)values[index]/maxVal)*graphHeight;
      if ((mouseX > (centerX[index] - graphWidth * 0.01)) && (mouseX < (centerX[index] + graphWidth * 0.01)) && (mouseY > (centerY[index] - graphHeight * 0.01)) && (mouseY < (centerY[index] + graphHeight * 0.01))) {        
        fill(255, 255, 255);
        rect(mouseX, mouseY, graphWidth*0.1, graphHeight*0.1);
        String label = "(" + names[index] + "," + values[index] + ")";
        fill(0, 0, 0);
        textSize(width*0.0125);
        text(label, mouseX + graphWidth*0.02, mouseY + graphHeight*0.05);
      }
    }
  }
}

void mouseClicked() {
  if ((mouseX > width*0.9) && (mouseY < height*0.05)) {
    /**float wid = barWidth;
     if (bar) {
     while (wid > graphWidth*0.02) {
     clear();
     background(200, 200, 200);
     drawAxes();
     for (int i=0; i<values.length; i++) {
     float h = (((float)values[i]/maxVal)*graphHeight);
     rect(i*barWidth + 0.1*width, graphHeight-h, wid, h);
     wid = wid - 0.01;
     delay(10);
     }
     println(wid);
     }
     }**/

    /**if (bar) {
      fill(226, 229, 100);
      barWidth = (float) (width*0.9)/(names.length);
      for (int i=0; i<values.length; i++) {
        float h = (((float)values[i]/maxVal)*graphHeight);
        while (h > graphHeight*0.02) {
          background(200, 200, 200);
          
          drawAxes();
          fill(226, 229, 100);

          rect(i*barWidth + 0.1*width, centerY[i], barWidth, h);
          h = lerp(h, 0, 0.02);
        }
        //println("i: " + i  + " " + (graphHeight - h) + " max: " + maxVal + " height: " + h );
      }
    }**/
    bar = !bar;
  }
}