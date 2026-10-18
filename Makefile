SDL_CFLAGS = `sdl2-config --cflags`
SDL_LDFLAGS = `sdl2-config --libs`

#make -C obj_dir -f Vtest_hvsync_generator_top.mk Vtest_hvsync_generator_top
SRC_HVSYNC_GENE=test_hvsync_generator_top.v hvsync_generator.v
SRC_BITMAP=test_bitmap.v hvsync_generator.v car_bitmap.v 

test_hvsync_generator:
	verilator -Wall --trace -cc $(SRC_HVSYNC_GENE) -exe sim_main_gene.cpp \
        -CFLAGS "${SDL_CFLAGS}" -LDFLAGS "${SDL_LDFLAGS}"
	make -C obj_dir -f Vtest_hvsync_generator_top.mk Vtest_hvsync_generator_top

test_bitmap:
	verilator -Wall --trace -cc $(SRC_BITMAP) -exe sim_main.cpp \
        -CFLAGS "${SDL_CFLAGS}" -LDFLAGS "${SDL_LDFLAGS}"
	make -C obj_dir -f Vtest_bitmap.mk Vtest_bitmap

clean:
	rm -f -r obj_dir




