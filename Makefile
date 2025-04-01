AWS_PROFILE=beeco


init:
	AWS_PROFILE=$(AWS_PROFILE) terraform -chdir=infrastructure init 

plan:
	AWS_PROFILE=$(AWS_PROFILE) terraform -chdir=infrastructure plan 


test:
	AWS_PROFILE=$(AWS_PROFILE) terraform -chdir=infrastructure test 

apply:
	AWS_PROFILE=$(AWS_PROFILE) terraform -chdir=infrastructure apply 