CXX = g++

CaXXFLAGS += -std=c++11

objects =  \
	test.o \

default :
	@echo "no platform"

barbonelle : CXXFLAGS += -DCM3GPIO_HW -DPWR_SWITCH   -DFIX_ABL_LINK
barbonelle : $(objects)
	$(CXX)  -o a.out $(objects) -l wiringPi

PHONY : clean

clean :
	rm $(objects)

