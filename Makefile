build/Makefile: scripts/mkmk.R recipes
	Rscript scripts/mkmk.R

clean:
	rm -rf build
