import com.dhchoi.*;
import processing.sound.*;


Math math;
processing.sound.Amplitude ampSound;
processing.sound.FFT fftSound;
processing.sound.SoundFile fileSound;
processing.sound.BeatDetector BATIDA;

int[] freq = {512, 1024, 2048, 4096, 8192, 16384};
int teste = freq[1]; //baixo cap frequencia
int bands = freq[4]; //cima cap frequencia
float[] spectrum = new float[bands];
int raio = 100;
boolean circulo, passa;
float corR = 255;
float corG = 255;
float corB = 255;
float rodaX = 0;
float rodaY = 0;
float rodaZ = 0;
CountdownTimer timer = CountdownTimerService.getNewCountdownTimer(this).configure(100, 100);

void setup() {
  size(700, 700, P3D);
  ampSound = new processing.sound.Amplitude(this);
  BATIDA = new processing.sound.BeatDetector(this);
  fileSound = new processing.sound.SoundFile(this, "04-pursuit.wav");
  fftSound = new processing.sound.FFT(this, bands);
  
  fftSound.input(fileSound);
  ampSound.input(fileSound);
  BATIDA.input(fileSound);
  BATIDA.sensitivity(130);
  fileSound.play(1, 0.1); 
}

void draw() {
  background(50, 50, 50);
  if (fileSound == null) {}else{
    visualizer_circulo(raio, width/2, height*0.35, 50);
    println(frameRate);
  }
}

void visualizer_circulo(int r, float translateX, float translateY, int mult){
  Circulo(translateX, translateY);
  translate(translateX, translateY);

  fftSound.analyze(spectrum);

  for(int i = teste; i < bands; i++){
    double radiano = (math.PI / 180) * i;
    float x = (float)math.cos(radiano) * r;
    float y = (float)math.sin(radiano) * r;
    stroke(corR, corG, corB);
    float freqX = x - (spectrum[i]*x*8)*-mult;
    float freqY = y - (spectrum[i]*y*8)*-mult;
    line(x, y, freqX, freqY);
  }
  rodaX+=spectrum[50]*500;
  rodaY+=spectrum[1]+2;
  rodaZ+=spectrum[200]*200;
}

void Circulo(float x, float y){
  pushMatrix();
    translate(x, y+2.7);
    noFill();
    stroke(corR, corG, corB);
    if(BATIDA.isBeat()){
      timer.start();
      strokeWeight(2);
    }
    rotateX(radians(rodaX));
    rotateY(radians(rodaY));
    rotateZ(radians(rodaZ));
    sphere(raio-4);
    //translate(-x, -y-3);
  popMatrix();
}

void onFinishEvent(CountdownTimer t) {
  strokeWeight(1);
  corR = random(150, 200);
  corG = random(150, 200);
  corB = random(150, 200);
  map(random(1000), 0, 1000, 0, 255);
}
