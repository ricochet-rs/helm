
docs:
    helm-docs --skip-version-footer && prettier -w .

[working-directory: 'charts/ricochet']
helm-deps:
    helm dependency update

lint-markdown:
    markdownlint-cli2 *.{md,markdown}

lint-helm:
    helm lint charts/*

lint-yaml:
    yamllint --strict -f colored .

lint-editorconfig:
    editorconfig-checker

lint-prettier:
    prettier --check .

lint:
    just lint-markdown
    just lint-helm
    just lint-yaml
    just lint-editorconfig
    just lint-prettier

test:
    helm unittest charts/ricochet
