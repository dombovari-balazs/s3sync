AWS_PROFILE=beeco


init:
	AWS_PROFILE=$(AWS_PROFILE) terraform -chdir=infrastructure init 

plan:
	AWS_PROFILE=$(AWS_PROFILE) terraform -chdir=infrastructure plan 


test:
	AWS_PROFILE=$(AWS_PROFILE) terraform -chdir=infrastructure test 

apply:
	AWS_PROFILE=$(AWS_PROFILE) terraform -chdir=infrastructure apply 


setup_venv:
	python3 -m venv lambda/s3sync/.venv && \
	lambda/s3sync/.venv/bin/pip install -r lambda/s3sync/requirements.txt

export_dependency_list:
	lambda/s3sync/.venv/bin/pip freeze > lambda/s3sync/requirements.txt