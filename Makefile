lint:
	@terraform fmt

lint-check:
	@terraform fmt -diff=true -check=true
