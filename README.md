# Security PR Agent

[![Patch and Push Docker Image](https://github.com/hi120ki/security-pr-agent/actions/workflows/push-image.yaml/badge.svg)](https://github.com/hi120ki/security-pr-agent/actions/workflows/push-image.yaml)

This project is a security-focused PR review tool based on [PR Agent](https://github.com/Codium-ai/pr-agent). It automatically analyzes PR changes and provides comprehensive reviews from a security perspective.

## Key Features

- Security-focused PR Review
  - Authentication & Authorization Issues
  - Input Validation & Sanitization
  - Data Protection
  - API Security
  - Web Security
  - Infrastructure & Configuration
  - Dependency Management

## Usage

### Setup GitHub Actions Workflow for OpenAI

```yaml
name: Security PR Agent

on:
  pull_request:
    types: [opened, reopened, ready_for_review]
  issue_comment:

jobs:
  pr_agent_job:
    if: ${{ github.event.sender.type != 'Bot' }}
    runs-on: ubuntu-latest
    permissions:
      issues: write
      pull-requests: write
      contents: write

    name: Run security pr agent on every pull request, respond to user comments

    steps:
      - name: Security PR Agent action step
        id: pragent
        uses: docker://ghcr.io/hi120ki/security-pr-agent:2025-04-24
        env:
          OPENAI_KEY: ${{ secrets.OPENAI_API_KEY }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          github_action_config.auto_review: true
          github_action_config.auto_improve: false
```

## Customization

You can customize the security review criteria and prompts by editing the `pr_reviewer_prompts.toml` file.

## License

This project is licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).

## Acknowledgments

This project is based on [PR Agent](https://github.com/Codium-ai/pr-agent). We thank the PR Agent team for their excellent work.
