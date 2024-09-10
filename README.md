# github-action-pycodestyle
GitHub Action to run pycodestyle. I use this personally to check if the code in my PRs is compliant with the pycodestyle rules. Feel free to use it in your projects. If you have any suggestions for improvements, please open an issue or a PR.

# 1. Inputs

# 1.1. `base`

Base branch to compare against. This is the branch that the PR is being compared to. If not specified, this will be the pull request's base branch.

# 1.2. `exclude`

Comma-separated list of paths to exclude from the check.

# 1.3. `github_token`

The default GitHub token. This is used to comment on the PR. If not specified, the token will be taken from the `GITHUB_TOKEN` environment variable.

# 2. Outputs

This action will write comments to the PR with the results of the pycodestyle check.

# 3. Example Usage

You can use this action by adding the following to your workflow file:

```yaml
uses: petrabarus/github-action-pycodestyle@v1
with:
  base: main
  exclude: '*.pyc,*.pyo,*.pyd'
```

# 4. Inspiration

I took inspiration from [andymckay/pycodestyle-action](https://github.com/marketplace/actions/pycodestyle).

# 5. License

This project is licensed under the BSD 2-Clause License. See the [LICENSE](LICENSE) file for more details.
