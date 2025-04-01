AWS_PROFILE=beeco


init:
	AWS_PROFILE=$(AWS_PROFILE) terraform -chdir=infrastructure init 

plan:
	AWS_PROFILE=$(AWS_PROFILE) terraform -chdir=infrastructure plan 


test:
	AWS_PROFILE=$(AWS_PROFILE) terraform -chdir=infrastructure test 

apply:
	AWS_PROFILE=$(AWS_PROFILE) terraform -chdir=infrastructure apply 


update-requirements:
	@echo "📦 Exporting installed dependencies to requirements.txt..."
	lambda/s3sync/.venv/bin/pip freeze > lambda/s3sync/requirements.txt

venv:
	@echo "🔧 Creating virtualenv at lambda/s3sync/.venv..."
	python3 -m venv lambda/s3sync/.venv && \
	lambda/s3sync/.venv/bin/pip install -r lambda/s3sync/requirements.txt 
	

test: 
	@echo "🧪 Running tests with 🐍 virtual environment..."
	@echo "📁 PYTHONPATH: lambda/s3sync"
	@echo "🚀 Starting pytest...\n"
	PYTHONPATH=lambda/s3sync lambda/s3sync/.venv/bin/pytest -v --color=yes


