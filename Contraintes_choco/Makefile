CPATHS = choco.jar:.

JFLAGS = -g -cp $(CPATHS)
JC     = /etu/linux/stow/jdk1.6.0_03/bin/javac
JAVA   = /etu/linux/stow/jdk1.6.0_03/bin/java

RM     = rm

all: run
	
VisuMobile.class: VisuMobile.java Mobile.class
	$(JC) $(JFLAGS) $<

Mobile.class: Mobile.java
	$(JC) $(JFLAGS) $<

run: VisuMobile.class
	$(JAVA) -cp choco.jar:. VisuMobile

clean:
	$(RM) *.class
