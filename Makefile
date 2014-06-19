ZIP = zip

.PHONY: all clean

all: pong.love

pong.love:
	@ $(ZIP) -9 -q -r pong.love . -i 'fonts/*' -i 'images/*' -i 'sounds/*' -i '*.lua'

clean:
	@ rm -f pong.love
