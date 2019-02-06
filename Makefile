CXXFLAGS += -Wall -std=c++14 -g

.PHONY: test clean

Xs := $(wildcard *.x)
SRCs := $(shell hx-files.sh $(Xs))
DOCs := $(Xs:.x=.html)
EXE := iaa

test: $(EXE)
	@echo "  running $(EXE)"
	@rm -f a.out
	@./$(EXE)
	@./a.out >got.txt
	@diff expected.txt got.txt

$(SRCs): $(Xs)
	@echo "  HX"
	@hx

$(EXE): $(SRCs)
	@echo "  CXX $@"
	@$(CXX) $(CXXFLAGS) -o $@ $^ -lstdc++fs

clean:
	@echo "  RM generated files"
	@rm -f $(SRCs) $(EXE) $(DOCs)

