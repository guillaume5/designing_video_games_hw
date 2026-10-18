#include "Vtest_hvsync_generator_top.h"
#include "verilated.h"
#include <verilated_vcd_c.h>
#include <iostream>
#include <SDL2/SDL.h>


#define MAX_SIM_TIME 100
#define DISPLAY_DELAY 20


vluint32_t sim_time = 0;

typedef struct Pixel {  // for SDL texture
    uint8_t a;  // transparency
    uint8_t b;  // blue
    uint8_t g;  // green
    uint8_t r;  // red
} Pixel;

volatile bool update = false;

//Uint32 (SDLCALL * SDL_TimerCallback) (Uint32 interval, void *param)
Uint32 timer_handler(Uint32 intervall, void* param){
  //cout << "x" << endl;
  update = true;
  return 0;
}



int main(int argc, char** argv) {
  const int windowWidth = 256;
  const int windowHeight = 240;

  bool color = false;

  if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER) < 0) {
    return 1;
    std::cout << "Initialization failed" << std::endl;
  }

  SDL_Window *window = SDL_CreateWindow("CRT",
          SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, windowWidth,
          windowHeight, SDL_WINDOW_SHOWN);
  
  if (window == NULL) {
    SDL_Quit();
    return 2;
  }
          
  // SDL_RENDERER_ACCELERATED
  SDL_Renderer *sdl_renderer = SDL_CreateRenderer(window, 0, SDL_RENDERER_SOFTWARE | SDL_RENDERER_PRESENTVSYNC) ;
  
  SDL_Texture*  sdl_texture = sdl_texture = SDL_CreateTexture(sdl_renderer, SDL_PIXELFORMAT_RGBA8888,
        SDL_TEXTUREACCESS_TARGET, windowWidth, windowHeight);
  if (!sdl_texture) {
    printf("Texture creation failed: %s\n", SDL_GetError());
    return 1;
  }
  
  Pixel screenbuffer[windowHeight*windowWidth];
  
  int pointLocationx = 0;
  int pointLocationy = 0;

  bool quit = false;
  SDL_Event event;
  
  uint32_t cnt = 0;
  
  //VerilatedContext* contextp = new VerilatedContext;
  //contextp->commandArgs(argc, argv);

  Vtest_hvsync_generator_top* top = new Vtest_hvsync_generator_top();
  
  //Verilated::traceEverOn(true);
  //VerilatedVcdC *m_trace = new VerilatedVcdC;
  //top->trace(m_trace, 5);
  //m_trace->open("waveform.vcd");
  
  top->clk = 0;
  top->reset = 0;

  SDL_TimerID timerID = SDL_AddTimer(DISPLAY_DELAY, timer_handler, nullptr);
  
  //while (!contextp->gotFinish()) { top->eval(); }
  while (!quit) {
    top->clk ^= 1;
    top->eval();
    
    if(top->clk==1){
      uint8_t color = top->rgb;
      uint16_t hpos = top->hpos;
      uint16_t vpos = top->vpos;
      uint8_t display_on = top->display_on;
      
      
      
      
      if (display_on){ // vpos>=8 && vpos<248 && hpos>=23 && hpos<279
        Pixel* p = &screenbuffer[vpos*windowWidth+hpos];
        p->a = 0xFF;
        p->b = ((color >> 2) & 1)*0xFF;
        p->g = ((color >> 1) & 1) *0xFF;
        p->r = (color & 1)*0xFF;
      }
     
      
      
    }
    
    //m_trace->dump(sim_time);
    sim_time++;
    
    if (update) {
      update = false;
      while (SDL_PollEvent(&event)) {
        if (event.type == SDL_QUIT) {
          quit = true;
        }
      }
      
      /*for(int i=0;i<windowWidth*windowHeight;i++){
        Pixel* p = &screenbuffer[i];
        p->a = 0xFF;
        p->b = 0x00;
        p->g = cnt%2==1?0xFF:0x00;
        p->r = cnt%2==0?0xFF:0x00;
      }*/
    
      
      SDL_RemoveTimer(timerID);
      SDL_UpdateTexture(sdl_texture, NULL, screenbuffer, windowWidth*sizeof(Pixel));
      SDL_RenderClear(sdl_renderer);
      SDL_RenderCopy(sdl_renderer, sdl_texture, NULL, NULL);
      SDL_RenderPresent(sdl_renderer);

      timerID = SDL_AddTimer(DISPLAY_DELAY, timer_handler, nullptr);
      cnt++;
      if(cnt%100==0)
        std::cout << sim_time << std::endl;
    }
  }

  //m_trace->close();
  delete top;
  //delete contextp;

  return 0;
}
