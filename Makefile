# Build shortcuts for the daily-drive binary.
#
# `make install` is the one to remember: a plain `cargo install` drops the
# `image` feature, and with it cover art.

CARGO ?= cargo
PKG := spotify_player

# Extra features on top of the defaults (rodio-backend, media-control, rustls-tls).
FEATURES ?= image

# Feature set CI tests and lints against (.github/workflows/ci.yml, RUST_FEATURES).
CI_FEATURES := rodio-backend,media-control,image,notify,fzf

.DEFAULT_GOAL := help
.PHONY: help install build run test lint fmt fmt-check check

help: ## List targets
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "} {printf "  %-10s %s\n", $$1, $$2}'

install: ## Build and install the release binary to ~/.cargo/bin (defaults + FEATURES)
	$(CARGO) install --path $(PKG) --locked --features "$(FEATURES)"

build: ## Release build into target/release (defaults + FEATURES)
	$(CARGO) build --release --locked -p $(PKG) --features "$(FEATURES)"

run: ## Run a debug build (defaults + FEATURES)
	$(CARGO) run -p $(PKG) --features "$(FEATURES)"

test: ## Run tests with CI's feature set
	$(CARGO) test --no-default-features --features "$(CI_FEATURES)"

lint: ## Clippy with CI's feature set, warnings as errors
	$(CARGO) clippy --all-targets --no-default-features --features "$(CI_FEATURES)" -- -D warnings

fmt: ## Format the code
	$(CARGO) fmt --all

fmt-check: ## Check formatting, as CI does
	$(CARGO) fmt --all -- --check

check: fmt-check lint test ## Everything CI checks, before pushing
