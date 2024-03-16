fmt:
	cargo fmt --all

sort:
	cargo sort --workspace --grouped

lint: fmt sort

check:
	cargo check --all --all-targets --all-features

clippy:
	cargo clippy --all --all-targets --all-features

clippy-fix:
	cargo clippy --fix

typos:
	typos -w

doc:
	RUSTDOCFLAGS="-D rustdoc::broken-intra-doc-links" cargo doc --all-features --no-deps

doc-open:
	RUSTDOCFLAGS="-D rustdoc::broken-intra-doc-links" cargo doc --all-features --no-deps --open

hack:
	cargo hack check --each-feature --no-dev-deps --workspace

test:
	cargo test --all-features --workspace

qa: lint check clippy doc hack test

watch-docs:
	cargo watch -x doc

watch-check:
	cargo watch -x check -x test

rama +ARGS:
    cargo run -p rama-cli -- {{ARGS}}

rama-fp *ARGS:
	cargo run -p rama-fp -- {{ARGS}}

rama-fp-generate-self-signed-cert:
	mkdir -p rama-fp/infra || true
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout rama-fp/infra/rama-fp.key \
		-out rama-fp/infra/rama-fp.crt

watch-rama-fp:
	RUST_LOG=debug cargo watch -x 'run -p rama-fp'

docker-build:
    docker build -t rama:latest -f Dockerfile .

example NAME:
		cargo run -p rama --example {{NAME}}

report-code-lines:
	find . -type f -name '*.rs' -exec cat {} + \
		| grep -v target | tr -d ' ' | grep -v '^$' | grep -v '^//' \
		| wc -l
