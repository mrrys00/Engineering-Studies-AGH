.PHONY: draw_graph
draw_graph%:
	go build -o main$* cmd/elasticDeformation/main.go
	./main$* $*
	gnuplot -p makeGraph.plt