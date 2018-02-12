ZIP = zip

.PHONY: all clean

all: pong.love

pong.love:
	@ cd game && $(ZIP) -9 -q -r ../pong.love . && cd ..

clean:
	@ rm -f pong.love
