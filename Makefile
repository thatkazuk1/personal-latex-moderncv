.PHONY: all backend platform fullstack clean

LATEX    = pdflatex
SRC      = main.tex
OUT_DIR  = build

all: backend platform fullstack

backend:
	@mkdir -p $(OUT_DIR)
	$(LATEX) -interaction=nonstopmode -output-directory=$(OUT_DIR) -jobname=desmond_edem_backend $(SRC)
	$(LATEX) -interaction=nonstopmode -output-directory=$(OUT_DIR) -jobname=desmond_edem_backend $(SRC)

platform:
	@mkdir -p $(OUT_DIR)
	$(LATEX) -interaction=nonstopmode -output-directory=$(OUT_DIR) -jobname=desmond_edem_platform "\def\variantplatform{}\input{$(SRC)}"
	$(LATEX) -interaction=nonstopmode -output-directory=$(OUT_DIR) -jobname=desmond_edem_platform "\def\variantplatform{}\input{$(SRC)}"

fullstack:
	@mkdir -p $(OUT_DIR)
	$(LATEX) -interaction=nonstopmode -output-directory=$(OUT_DIR) -jobname=desmond_edem_fullstack "\def\variantfullstack{}\input{$(SRC)}"
	$(LATEX) -interaction=nonstopmode -output-directory=$(OUT_DIR) -jobname=desmond_edem_fullstack "\def\variantfullstack{}\input{$(SRC)}"

clean:
	rm -rf $(OUT_DIR)
