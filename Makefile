default: test doc CurrentTime.run ShowDST.run

SRCS = Data/Fixed.hs \
	System/Time/Clock.hs \
	System/Time/TAI.hs \
	System/Time/Calendar/Private.hs \
	System/Time/Calendar/Timezone.hs \
	System/Time/Calendar/TimeOfDay.hs \
	System/Time/Calendar/Calendar.hs \
	System/Time/Calendar/Gregorian.hs \
	System/Time/Calendar.hs

TestFixed: TestFixed.o Data/Fixed.o
	ghc $^ -o $@

TestTime: TestTime.o libTimeLib.a
	ghc $^ -o $@

CurrentTime: CurrentTime.o libTimeLib.a
	ghc $^ -o $@

ShowDST: ShowDST.o libTimeLib.a
	ghc $^ -o $@

TimeZone: TimeZone.o libTimeLib.a
	ghc $^ -o $@

TimeZone.ref: FORCE
	date +%z > $@

timestuff.o: timestuff.c timestuff.h
	gcc -o $@ -c $<

libTimeLib.a: $(patsubst %.hs,%.o,$(SRCS)) timestuff.o
	rm -f $@
	ar cru $@ $^
	ranlib $@

test: TestFixed.diff TestTime.diff TimeZone.diff

clean:
	rm -rf TimeZone TimeZone.ref CurrentTime TestTime TestFixed doc haddock *.out *.a *.o *.hi $(patsubst %.hs,%.o,$(SRCS)) $(patsubst %.hs,%.hi,$(SRCS)) Makefile.bak

doc: haddock/index.html

haddock/index.html: $(SRCS)
	mkdir -p haddock
	haddock -h -o haddock $^

%.diff: %.ref %.out
	diff -u $^

%.out: %
	./$< > $@

%.run: %
	./$<

%.hi: %.o
	@:

%.o: %.hs
	ghc -c $< -o $@

FORCE:

.SECONDARY:

depend: TestFixed.hs CurrentTime.hs TestTime.hs $(SRCS)
	ghc -M $^

# DO NOT DELETE: Beginning of Haskell dependencies
TestFixed.o : TestFixed.hs
TestFixed.o : ./Data/Fixed.hi
CurrentTime.o : CurrentTime.hs
CurrentTime.o : ./System/Time/Calendar.hi
CurrentTime.o : ./System/Time/TAI.hi
CurrentTime.o : ./System/Time/Clock.hi
TestTime.o : TestTime.hs
TestTime.o : ./System/Time/Calendar.hi
TestTime.o : ./System/Time/TAI.hi
TestTime.o : ./System/Time/Clock.hi
Data/Fixed.o : Data/Fixed.hs
System/Time/Clock.o : System/Time/Clock.hs
System/Time/Clock.o : Data/Fixed.hi
System/Time/TAI.o : System/Time/TAI.hs
System/Time/TAI.o : System/Time/Clock.hi
System/Time/Calendar/Private.o : System/Time/Calendar/Private.hs
System/Time/Calendar/Timezone.o : System/Time/Calendar/Timezone.hs
System/Time/Calendar/Timezone.o : System/Time/Clock.hi
System/Time/Calendar/Timezone.o : System/Time/Calendar/Private.hi
System/Time/Calendar/TimeOfDay.o : System/Time/Calendar/TimeOfDay.hs
System/Time/Calendar/TimeOfDay.o : Data/Fixed.hi
System/Time/Calendar/TimeOfDay.o : System/Time/Calendar/Timezone.hi
System/Time/Calendar/TimeOfDay.o : System/Time/Clock.hi
System/Time/Calendar/Calendar.o : System/Time/Calendar/Calendar.hs
System/Time/Calendar/Calendar.o : System/Time/Calendar/TimeOfDay.hi
System/Time/Calendar/Calendar.o : System/Time/Calendar/Timezone.hi
System/Time/Calendar/Calendar.o : System/Time/Clock.hi
System/Time/Calendar/Gregorian.o : System/Time/Calendar/Gregorian.hs
System/Time/Calendar/Gregorian.o : System/Time/Clock.hi
System/Time/Calendar/Gregorian.o : System/Time/Calendar/Private.hi
System/Time/Calendar/Gregorian.o : System/Time/Calendar/Calendar.hi
System/Time/Calendar.o : System/Time/Calendar.hs
System/Time/Calendar.o : System/Time/Calendar/Gregorian.hi
System/Time/Calendar.o : System/Time/Calendar/Calendar.hi
System/Time/Calendar.o : System/Time/Calendar/TimeOfDay.hi
System/Time/Calendar.o : System/Time/Calendar/Timezone.hi
# DO NOT DELETE: End of Haskell dependencies
