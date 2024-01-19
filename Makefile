.PHONY: get codegen gen fix

# Get dependencies
get:
	@dart pub get --directory backend
	@dart pub get --directory frontend
	@dart pub get --directory shared

# Codegeneration
codegen:
	@dart pub get --directory shared
	@(cd shared && dart run build_runner build --delete-conflicting-outputs)
	@dart pub get --directory backend
	@(cd backend && dart run build_runner build --delete-conflicting-outputs)
	@dart format --fix -l 120 shared backend

# Codegeneration
gen: codegen

# Codefix
fix: get
	@dart fix --apply .
	@dart format --fix -l 120 .
