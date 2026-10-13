SDL_CFLAGS = `sdl2-config --cflags`
SDL_LDFLAGS = `sdl2-config --libs`


all:
	verilator -Wall --trace -cc test_hvsync_generator_top.v hvsync_generator.v --exe sim_main.cpp \
        -CFLAGS "${SDL_CFLAGS}" -LDFLAGS "${SDL_LDFLAGS}"
	make -C obj_dir -f Vtest_hvsync_generator_top.mk Vtest_hvsync_generator_top

clean:
	rm -f -r obj_dir




