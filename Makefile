CPP=/mingw64/bin/g++
CFLAGS=-municode -static-libgcc -static-libstdc++ -I/mingw64/include -L/mingw64/lib -lSDL_image -lSDL_mixer -lSDL_ttf -lSDLmain -lSDL

chaos_neo.exe: chaos_neo.cpp
	$(CPP) -o chaos_neo.exe chaos_neo.cpp $(CFLAGS)
