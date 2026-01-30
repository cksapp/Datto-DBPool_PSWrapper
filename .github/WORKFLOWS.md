# GitHub Actions CI/CD Pipeline

This document describes the integrated CI/CD pipeline for the Datto.DBPool.API PowerShell module.

## Workflow Architecture

The pipeline follows GitHub Actions best practices using **reusable workflows** for the CI layer:

- **CI (Continuous Integration):** Runs on every code change (push/PR) with fresh tests
- **CD (Continuous Deployment):** Runs only on manual dispatch or version tags, depends on CI passing

## Workflow Overview

```text
┌──────────────────────────────────────────────────────────────────────────────┐
│                 CONTINUOUS INTEGRATION (Every Code Change)                   │
│                              [ci.yml]                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Triggers:                                                                   │
│  • Push to /src or /Datto.DBPool.API                                        │
│  • Pull requests to main                                                    │
│  • Called by build-and-release.yml (reusable workflow)                      │
│                                                                              │
│  Jobs (Runs in Parallel):                                                   │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │  [test]         ──→  Pester Tests (Linux + Windows Matrix)             │ │
│  │                      • CHANGELOG ↔ Manifest version match              │ │
│  │                      • Unit tests                                      │ │
│  │                      • Module build verification                       │ │
│  │                      • Runs: ./build.ps1 -Task Test -Bootstrap         │ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │  [analyze]      ──→  PSScriptAnalyzer Code Quality                     │ │
│  │                      • Static code analysis                            │ │
│  │                      • Security rules                                  │ │
│  │                      • SARIF results → GitHub Security tab             │ │
  │                      • Runs: microsoft/psscriptanalyzer-action         │ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │  [quality-gate] ──→  Pass/Fail Gate                                    │ │
│  │                      • Depends on: test + analyze                      │ │
│  │                      • Blocks deployment if either fails               │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  All jobs must pass for code to be merge-able and release-able             │
└──────────────────────────────────────┬───────────────────────────────────────┘
                                       │ CI Passes
                                       ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│                  CONTINUOUS DEPLOYMENT (Controlled Release)                  │
│                        [build-and-release.yml]                              │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Triggers:                                                                   │
│  • Manual: workflow_dispatch button                                         │
│  • Git Tag: Push tags matching v*.*.* pattern                              │
│                                                                              │
│  Jobs:                                                                       │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │  [ci] (Reusable)                                                       │ │
│  │  • Calls: ./.github/workflows/ci.yml                                   │ │
│  │  • Ensures fresh CI passes before proceeding to release                │ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │  [build-and-release] (Depends on: ci)                                 │ │
│  │                                                                         │ │
│  │  1. Determine Source (Git tag vs manual trigger)                       │ │
│  │  2. Build Module (PowerShellBuild, psake)                              │ │
│  │  3. Extract Version (CHANGELOG.md regex parse)                         │ │
│  │  4. Validate Version (Tag ↔ CHANGELOG ↔ Manifest)                      │ │
│  │  5. Check Version Changed (vs last GitHub release)                     │ │
│  │  6. Generate Release Notes (from CHANGELOG section)                    │ │
│  │  7. Create Archive (Datto.DBPool.API-{version}.zip)                    │ │
│  │  8. Create GitHub Release (with tag v{version})                        │ │
│  │  9. Upload Artifact (module zip to release)                            │ │
│  │  10. Trigger Docs Build (Build_DocsSite.yml)                           │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  All validations must pass; release is created only if all checks succeed   │
└──────────────────────────────────────┬───────────────────────────────────────┘
                                       │ Release Published
                                       ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│                     POWERSHELL GALLERY PUBLICATION                          │
│                        [publish-psgallery.yml]                              │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Triggered: Automatically when GitHub release is published                  │
│                                                                              │
│  Steps:                                                                      │
│  1. Download Release Artifact                                               │
│  2. Extract Module from Archive                                             │
│  3. Validate Module Structure                                               │
│  4. Publish to PowerShell Gallery (Publish-Module cmdlet)                   │
│  5. Trigger Docs Update                                                     │
│                                                                              │
└──────────────────────────────────────┬───────────────────────────────────────┘
                                       │
                                       ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│                        DOCUMENTATION BUILD                                   │
│                        [Build_DocsSite.yml]                                  │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Triggered:                                                                  │
│  • Manual: workflow_dispatch                                                │
│  • Changes: docs/** or mkdocs.yml                                           │
│  • Auto: After build-and-release.yml or publish-psgallery.yml              │
│                                                                              │
│  Steps:                                                                      │
│  1. Build MkDocs                                                             │
│  2. Deploy to GitHub Pages                                                  │
│  3. Update with Latest Version Info                                         │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

## Architecture Rationale

### Why Reusable Workflows (ci.yml)?

1. **Single Source of Truth:** CI logic defined once, used everywhere
2. **Guaranteed Fresh Tests:** Every release runs CI fresh, not relying on past results
3. **Maintainability:** Changes to CI automatically apply to all trigger points
4. **GitHub Best Practice:** Follows official GitHub Actions recommendations
5. **Explicit Dependencies:** Clear job dependencies prevent concurrent issues

### Why Separate CI from CD?

- **CI (Continuous Integration):** Runs automatically on every code change
  - Validates code quality before merge
  - Developers get immediate feedback
  - Pull requests require CI to pass

- **CD (Continuous Deployment):** Controlled release process
  - Only runs on manual approval or version tags
  - Prevents accidental releases
  - Clearly separates development from production

## Detailed Workflow Documentation

### 1. ci.yml - Continuous Integration (Reusable Workflow)

**File:** `.github/workflows/ci.yml`

**Triggers:**

- Direct: Push to `/src` or `/Datto.DBPool.API` directories
- Direct: Pull requests to `main` branch
- Called: By `build-and-release.yml` using `uses: ./.github/workflows/ci.yml`

**Purpose:** Comprehensive code quality and functionality validation

**Jobs (Run in Parallel):**

#### [test] - Pester Testing & Module Build

**Strategy:** Matrix on `os: [ubuntu-latest, windows-latest]`

**Steps:**

1. Checkout code (full history)
2. Setup PowerShell 7.3.12
3. Execute `./build.ps1 -Task Test -Bootstrap`
   - Manifest.tests.ps1: Validates CHANGELOG ↔ manifest version match
   - Help.tests.ps1: Validates all functions have documentation
   - Meta.tests.ps1: Validates module structure and metadata
   - Pester: Runs unit tests for all functions
   - Build: Compiles module to verify no syntax errors

**Fails If:**

- CHANGELOG version differs from manifest
- Help documentation missing or incomplete
- Pester tests fail
- Module compilation fails

#### [analyze] - PSScriptAnalyzer Code Quality

**Steps:**

1. Checkout code
2. Run PSScriptAnalyzer using `microsoft/psscriptanalyzer-action`
   - Analyzes all PowerShell files recursively
   - Applies security rules: PSAvoidGlobalAliases, PSAvoidUsingConvertToSecureStringWithPlainText
   - Generates SARIF (Static Analysis Results Format) output
3. Upload SARIF to GitHub Security tab (`github/codeql-action/upload-sarif`)

**Detects:**

- Security vulnerabilities
- Code style violations
- Incorrect cmdlet usage
- Parameter validation issues

#### [quality-gate] - Pass/Fail Guard

**Depends On:** `[test, analyze]`

**Purpose:** Ensures all CI jobs passed before release can proceed

**Implementation:** Simple pass job that fails if dependencies fail

---

### 2. build-and-release.yml - Release Creation (CD Pipeline)

**File:** `.github/workflows/build-and-release.yml`

**Triggers:**

- Manual: `workflow_dispatch` (button in Actions tab)
- Git Tags: Push of tags matching `v*.*.*` pattern (e.g., `v0.2.3`, `v1.0.0`)

**Purpose:** Create official GitHub release with version-controlled artifacts

**Requires CI to Pass:**

The workflow explicitly calls the reusable CI workflow at the start:

```yaml
jobs:
  ci:
    uses: ./.github/workflows/ci.yml

  build-and-release:
    needs: ci  # Cannot proceed until CI passes
```

This ensures fresh CI results before any release steps execute.

**Release Job Steps:**

1. **Determine Source**
   - Detects if triggered by git tag or manual dispatch
   - Extracts tag version if present

2. **Setup & Build**
   - Checkout code with full history
   - Setup PowerShell
   - Run `./build.ps1 -Bootstrap` to compile module

3. **Extract Version**
   - Parses `CHANGELOG.md` with regex: `^##\s\[(?<Version>(\d+\.){1,3}\d+)\]`
   - Extracts version from first matching section header

4. **Validate Version Matches**
   - If triggered by tag: ensures `git-tag-version == CHANGELOG-version`
   - Error if mismatch detected

5. **Get Previous Release**
   - Uses `git describe --tags --abbrev=0` to find last release tag

6. **Validate Version Changed**
   - Compares current version with previous release
   - Fails if versions are identical
   - Ensures every release has version bump

7. **Generate Release Notes**
   - Extracts section from `CHANGELOG.md` for current version
   - Format: Content between `## [X.Y.Z]` headers
   - Fallback: Uses git log `--pretty=format` if no CHANGELOG section

8. **Create Archive**
   - Zips module directory: `Datto.DBPool.API/{version}/`
   - Output: `Datto.DBPool.API-{version}.zip`
   - Includes PSM1, PSD1, help XML, all subdirectories

9. **Create GitHub Release**
   - Uses `actions/create-release@v1`
   - Tag: `v{version}`
   - Release name: `Release {version}`
   - Body: Generated release notes
   - Not a draft, not a prerelease

10. **Upload Artifact**
    - Uses `actions/upload-release-asset@v1`
    - Attaches `.zip` file to release
    - Content-Type: `application/zip`

11. **Trigger Documentation Build**
    - Uses `github/actions/github-script@v7`
    - Dispatches: `Build_DocsSite.yml` workflow
    - Branch: `main`

**Artifacts Created:**

- GitHub release with tag (e.g., `v0.2.2`)
- ZIP archive: `Datto.DBPool.API-0.2.2.zip`
- Release notes from CHANGELOG

**Next Automatic Step:**

- Publishing to PowerShell Gallery

### 3. build-and-release.yml - Release Creation

**Triggers:**

(Publishing to PowerShell Gallery)

---

### 3. publish-psgallery.yml - PowerShell Gallery Publishing

**File:** `.github/workflows/publish-psgallery.yml`

**Triggers:**

- Automatically on GitHub release publication (triggered by `build-and-release.yml`)

**Purpose:** Publish compiled module to PowerShell Gallery

**Prerequisites:**

- GitHub secret `PS_GALLERY_API_KEY` must be configured
- Release must be created by `build-and-release.yml`

**Steps:**

1. **Download Release:** Retrieves artifact from GitHub release
2. **Extract Module:** Unpacks `.zip` file
3. **Validate Structure:** Verifies PSM1, PSD1 present and valid
4. **Publish:** Uses `Publish-Module` with API key to push to PowerShell Gallery
5. **Trigger Docs:** Dispatches `Build_DocsSite.yml` to update documentation

**Outputs:**

- Module version published to PowerShell Gallery
- Users can install with: `Install-Module Datto.DBPool.API -Repository PSGallery`

---

### 4. Build_DocsSite.yml - Documentation Build and Deployment

**File:** `.github/workflows/Build_DocsSite.yml`

**Triggers:**

- Manual: `workflow_dispatch` (Actions tab button)
- File changes: Push to `docs/**` or `mkdocs.yml`
- Auto: After `build-and-release.yml` completes
- Auto: After `publish-psgallery.yml` completes

**Purpose:** Build MkDocs documentation and deploy to GitHub Pages

**Steps:**

1. Checkout repository
2. Setup Python and MkDocs
3. Execute `./build.ps1 -Task PublishDocs`
4. Deploy to GitHub Pages (gh-pages branch)

**Output:**

- Documentation website updated at `https://{org}.github.io/{repo}/`
- Latest module version documented

---

## Release Process Workflow

### Option A: Release via Git Tag (Recommended)

**Why use tags?** Industry standard, immutable, explicit intent

1. **Make code changes** and commit to `main`
2. **Update version files:**
   - `CHANGELOG.md` - Add new section: `## [X.Y.Z] Release`
   - `src/Datto.DBPool.API.psd1` - Update `ModuleVersion = 'X.Y.Z'`
3. **Commit and push:** `git add CHANGELOG.md src/Datto.DBPool.API.psd1 && git commit -m "Bump version to 0.2.3" && git push origin main`
4. **Wait for CI to pass** (check Actions tab - ci.yml workflow must pass)
5. **Create and push annotated git tag:** `git tag -a v0.2.3 -m "Release version 0.2.3" && git push origin v0.2.3`
6. **Automation takes over:**
   - `build-and-release.yml` triggered by tag push
   - Calls `ci.yml` to run fresh CI
   - Validates tag version matches CHANGELOG
   - Creates GitHub release with artifacts
   - `publish-psgallery.yml` auto-triggered on release
   - Module published to PowerShell Gallery
   - Documentation auto-updated

**Tag Format:** `v*.*.*` (e.g., `v0.2.3`, `v1.0.0`)

### Option B: Manual Release Dispatch

**When to use:** One-off releases, hotfixes, testing release process

1. **Update and commit versions** (same as above)
2. **Push to main** and wait for CI
3. **Trigger manually:**
   - Go to GitHub > Actions
   - Find "Build and Release" workflow
   - Click "Run workflow"
   - Select branch: `main`
   - Click green "Run workflow" button
4. **Automation proceeds** (same as above)

---

## Validation Checklist

Before any release is created, these validations are enforced:

| Validation | Stage | Blocks Release |
| --- | --- | --- |
| Tests pass (Pester) | `ci.yml` test job | Yes |
| Code analysis passes | `ci.yml` analyze job | Yes |
| Version in CHANGELOG matches tag | build-and-release | Yes (if tag used) |
| Version differs from last release | build-and-release | Yes |
| Module builds without errors | build-and-release | Yes |
| Help documentation complete | `ci.yml` test job | Yes |
| Manifest version matches CHANGELOG | `ci.yml` test job | Yes |

---

## Configuration

### Required GitHub Secrets

Navigate to: Repository > Settings > Secrets and variables > Actions

| Secret | Purpose | Required |
| --- | --- | --- |
| `PS_GALLERY_API_KEY` | PowerShell Gallery API key | Yes |
| `GITHUB_TOKEN` | GitHub API (auto-provided) | Yes |

### Setting PS_GALLERY_API_KEY

1. Create account at [PowerShell Gallery](https://www.powershellgallery.com/)
2. Navigate to "API Keys"
3. Create new key with "Push new packages" permission
4. Copy the key to clipboard
5. In GitHub: Settings > Secrets and variables > Actions
6. Click "New repository secret"
7. Name: `PS_GALLERY_API_KEY`
8. Value: Paste your API key
9. Save

---

## Workflow Status & Troubleshooting

### Viewing Workflow Runs

- **All workflows:** Repository > Actions tab
- **Specific workflow:** Click workflow name to see all runs
- **Detailed logs:** Click run > Click job > Expand step

### Common Issues

**[ERROR] "CI checks not passed" in build-and-release**

- **Cause:** Tests or analysis failed on latest commit
- **Fix:**
  1. Check Actions tab for failing workflow
  2. Fix code issues
  3. Push fix and wait for CI to pass
  4. Retry release

**[ERROR] "Version has not changed since last release"**

- **Cause:** Version in files matches last published version
- **Fix:**
  1. Update CHANGELOG.md with new version
  2. Update src/Datto.DBPool.API.psd1 with new ModuleVersion
  3. Commit and retry release

**[ERROR] "Git tag version mismatch"**

- **Cause:** Git tag version doesn't match CHANGELOG version
- **Fix:**
  1. Ensure tag created matches CHANGELOG version exactly
  2. Delete incorrect tag: `git tag -d v0.2.4 && git push origin :refs/tags/v0.2.4`
  3. Create correct tag: `git tag -a v0.2.3 -m "Release 0.2.3"`

**[ERROR] PowerShell Gallery publish fails**

- **Cause:** PS_GALLERY_API_KEY invalid, expired, or insufficient permissions
- **Fix:**
  1. Go to PowerShell Gallery > API Keys
  2. Create new key with "Push packages" permission
  3. Update `PS_GALLERY_API_KEY` secret in GitHub
  4. Manually retry publish-psgallery workflow

**[ERROR] Documentation not updating**

- **Cause:** Build_DocsSite workflow disabled or Docker issue
- **Fix:**
  1. Check Build_DocsSite.yml runs
  2. Review MkDocs build logs
  3. Verify `mkdocs.yml` is valid

---

## Best Practices

- **Test locally first:** Run `./build.ps1 -Bootstrap` before pushing
- **Meaningful CHANGELOG entries:** Users read these as release notes
- **Semantic versioning:** MAJOR.MINOR.PATCH
- **Annotated tags:** Use `-a` flag with descriptive message
- **Commit messages:** Write clear, descriptive messages for git log fallback
- **One version bump per release:** Keep versions in sync
- **Review PSScriptAnalyzer results:** Fix findings before release
- **Test in CI environment:** Docker dev container matches GitHub runners

---

## File Reference

| File | Purpose | Key Variables |
| --- | --- | --- |
| `.github/workflows/ci.yml` | Reusable CI workflow | Runs tests & analysis |
| `.github/workflows/build-and-release.yml` | Release creation & CD | Calls ci.yml first |
| `.github/workflows/publish-psgallery.yml` | PSGallery publication | Uses PS_GALLERY_API_KEY |
| `.github/workflows/Build_DocsSite.yml` | Documentation deployment | Builds MkDocs |
| `build.ps1` | Main build orchestrator | Uses psakeFile.ps1 |
| `psakeFile.ps1` | Build task definitions | PowerShellBuild tasks |
| `CHANGELOG.md` | Release notes & versions | `^##\s\[X.Y.Z\]` format |
| `src/Datto.DBPool.API.psd1` | Module manifest | ModuleVersion = 'X.Y.Z' |
| `tests/Manifest.tests.ps1` | Version validation tests | Verifies sync |

---

## Revision History

| Date | Change |
| --- | --- |
| 2026-01-30 | Restructured for reusable CI workflow (ci.yml) |
| 2026-01-29 | Added CI/CD pipeline documentation |
