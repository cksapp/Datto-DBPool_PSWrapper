# GitHub Actions CI/CD Pipeline

This document describes the integrated CI/CD pipeline for the Datto.DBPool.API PowerShell module.

## Workflow Overview

```text
                    ┌──────────────────────────────────────────────────────────┐
                    │         CONTINUOUS INTEGRATION (Every Push/PR)           │
                    ├──────────────────────────────────────────────────────────┤
                    │                                                          │
    Developer   →   │  • Build_Tests.yaml                                      │
    Code Push       │    - Linux & Windows Matrix                              │
                    │    - Version Match: CHANGELOG ↔ Manifest                 │
                    │    - Pester Tests                                        │
                    │    - Module Build                                        │
                    │                                                          │
                    │  • PSScriptAnalyzer.yml                                  │
                    │    - Code Quality Checks                                 │
                    │    - Security Rules                                      │
                    │    - SARIF Upload                                        │
                    │                                                          │
                    └──────────────────┬───────────────────────────────────────┘
                                       │ All CI Checks Pass
                                       ▼
    ┌───────────────────────────────────────────────────────────────────────────┐
    │                     VERSION VALIDATION CHAIN                              │
    │                        (Git Tag Workflow)                                 │
    ├───────────────────────────────────────────────────────────────────────────┤
    │                                                                           │
    │  Git Tag Push   →   Validate Tag Format   →   Extract Version   →         │
    │  (v*.*.*)           (v*.*.* pattern)           from Tag                   │
    │                                                                           │
    │                                     ↓                                     │
    │                                                                           │
    │              Verify in CHANGELOG.md   →   Verify in Manifest.psd1         │
    │                                                                           │
    └───────────────────────────────┬───────────────────────────────────────────┘
                                    │ Tag Validation Complete
                                    ▼
    ┌───────────────────────────────────────────────────────────────────────────┐
    │                    CONTINUOUS DEPLOYMENT                                  │
    ├───────────────────────────────────────────────────────────────────────────┤
    │                                                                           │
    │  Manual Trigger  ─┐                                                       │
    │  (workflow_dispatch) ─→  [ build-and-release.yml ]                        │
    │                                                                           │
    │  Git Tag Trigger ─┘      1. Verify CI Status (Must Pass)                  │
    │                          2. Bootstrap & Build (PowerShellBuild)           │
    │                          3. Extract Version (from CHANGELOG)              │
    │                          4. Validate Version (vs Last Release)            │
    │                          5. Generate Release Notes (CHANGELOG Section)    │
    │                          6. Create Archive (.zip Artifact)                │
    │                          7. Create GitHub Release (Tag v{version})        │
    │                          8. Upload Artifact (Module.zip)                  │
    │                                                                           │
    │                                    │                                      │
    │                                    │ Release Published Event              │
    │                                    ▼                                      │
    │                                                                           │
    │                         [ publish-psgallery.yml ]                         │
    │                                                                           │
    │                          1. Download Artifact (Auto-triggered)            │
    │                          2. Extract Module (from Archive)                 │
    │                          3. Validate Structure (Manifest Check)           │
    │                          4. Publish to PSGallery (Publish-Module)         │
    │                                                                           │
    └────────────────────────────────┬──────────────────────────────────────────┘
                                     │ Trigger Documentation Build
                                     ▼
    ┌───────────────────────────────────────────────────────────────────────────┐
    │                          DOCUMENTATION                                    │
    ├───────────────────────────────────────────────────────────────────────────┤
    │                                                                           │
    │                      [ Build_DocsSite.yml ]                               │
    │                                                                           │
    │                      • Build MkDocs                                       │
    │                      • Deploy to GitHub Pages                             │
    │                      • Update with New Version                            │
    │                                                                           │
    └───────────────────────────────────────────────────────────────────────────┘
```

## Workflow Details

### 1. Build_Tests.yaml - Continuous Integration

**Triggers:**

- Push to `/src` or `/Datto.DBPool.API`
- Pull requests to `main`

**Purpose:** Validate code quality and functionality on every commit

**Steps:**

1. Run on Linux and Windows (matrix strategy)
2. Setup PowerShell 7.3.12
3. Execute `./build.ps1 -Task Test -Bootstrap`
   - Validates CHANGELOG and manifest versions match (Manifest.tests.ps1)
   - Runs all Pester tests
   - Builds module to verify compilation

**Blocking:** Yes - Required for merge and release

---

### 2. PSScriptAnalyzer.yml - Code Quality

**Triggers:**

- Push to `/src` or `/Datto.DBPool.API`
- Pull requests to `main`
- Monthly schedule (17th day, 21:26 UTC)

**Purpose:** Static code analysis and security scanning

**Steps:**

1. Run PSScriptAnalyzer with security rules
2. Upload SARIF results to GitHub Security tab

**Blocking:** Advisory - Results visible in Security tab

---

### 3. build-and-release.yml - Release Creation

**Triggers:**

- Manual (`workflow_dispatch`)
- **Git version tags** (e.g., `v0.2.3`, `v1.0.0`)

**Purpose:** Create official GitHub release with versioned artifact

**Prerequisites:**

- Build_Tests must pass
- PSScriptAnalyzer must pass
- Version in CHANGELOG.md must be updated
- Version in src/Datto.DBPool.API.psd1 must match CHANGELOG
- Git tag version (if used) must match CHANGELOG version

**Steps:**

1. **Determine Source:** Detects if triggered by git tag or manually
2. **CI Status Check:** Verifies latest Build_Tests and PSScriptAnalyzer runs passed
3. **Build:** Runs `./build.ps1 -Bootstrap` to compile module
4. **Version Extraction:** Parses CHANGELOG.md for version (regex: `^##\s\[(?<Version>(\d+\.){1,3}\d+)\]`)
5. **Tag Validation:** If triggered by tag, validates tag version matches CHANGELOG
6. **Version Validation:** Ensures version changed since last release
7. **Release Notes:** Extracts from CHANGELOG.md section for that version (falls back to git commits)
8. **Archive Creation:** Creates `Datto.DBPool.API-{version}.zip` from build output
9. **GitHub Release:** Creates release with tag `v{version}`
10. **Asset Upload:** Attaches module zip to release
11. **Docs Trigger:** Automatically triggers Build_DocsSite.yml

**Outputs:**

- GitHub release with tag (e.g., `v0.2.2`)
- Release artifact: `Datto.DBPool.API-0.2.2.zip`
- Triggers: publish-psgallery.yml

---

### 4. publish-psgallery.yml - PowerShell Gallery Publishing

**Triggers:**

- Automatically on release publication (from build-and-release.yml)

**Purpose:** Publish module to PowerShell Gallery

**Prerequisites:**

- GitHub secret `PS_GALLERY_API_KEY` must be configured

**Steps:**

1. **Download:** Retrieves release artifact from GitHub
2. **Extract:** Unpacks module archive
3. **Validate:** Verifies module manifest and structure
4. **Publish:** Uploads to PowerShell Gallery using `Publish-Module`
5. **Docs Trigger:** Triggers Build_DocsSite.yml to update docs with published version

**Outputs:**

- Module published to PowerShell Gallery
- Documentation updated

---

### 5. Build_DocsSite.yml - Documentation

**Triggers:**

- Manual (`workflow_dispatch`)
- Push to `docs/**` or `mkdocs.yml`
- Automatically triggered by build-and-release.yml
- Automatically triggered by publish-psgallery.yml

**Purpose:** Build and deploy MkDocs documentation to GitHub Pages

**Steps:**

1. Setup PowerShell and dependencies
2. Execute `./build.ps1 -Task PublishDocs`
3. Deploy to GitHub Pages

---

## Release Process Flow

### Developer Workflow

**Option A: Automatic Release via Git Tag (Recommended)** ⭐

1. **Make changes** to code in `src/`
2. **Update version** in:
   - `CHANGELOG.md` - Add `## [X.Y.Z] Release` section with release notes
   - `src/Datto.DBPool.API.psd1` - Update `ModuleVersion`
3. **Commit and push** to `main`
4. **Wait for CI** (Build_Tests + PSScriptAnalyzer must pass)
5. **Create and push git tag:**

   ```powershell
   git tag -a v0.2.3 -m "Release version 0.2.3"
   git push origin v0.2.3
   ```

6. **Automation handles:**
   - Tag validation (must match CHANGELOG)
   - Verification of CI status
   - Build and test
   - Release creation
   - PSGallery publishing
   - Documentation updates

#### Option B: Manual Release

1. **Make changes** to code in `src/`
2. **Update version** in:
   - `CHANGELOG.md` - Add `## [X.Y.Z] Release` section with release notes
   - `src/Datto.DBPool.API.psd1` - Update `ModuleVersion`
3. **Commit and push** to `main`
4. **Wait for CI** (Build_Tests + PSScriptAnalyzer must pass)
5. **Trigger release:**
   - Go to Actions → "Build and Release"
   - Click "Run workflow"
   - Select branch: `main`
6. **Automation handles:**
   - Verification of CI status
   - Version validation
   - Release creation
   - PSGallery publishing
   - Documentation updates

### What Gets Validated

| Check                              | Where             | Enforced               |
|------------------------------------|-------------------|------------------------|
| CHANGELOG ↔ Manifest version match | Build_Tests       | Blocking               |
| Git tag ↔ CHANGELOG version match  | build-and-release | Blocking (if tag used) |
| Code quality                       | PSScriptAnalyzer  | Advisory               |
| Pester tests pass                  | Build_Tests       | Blocking               |
| Version changed since last release | build-and-release | Blocking               |
| CI status passed                   | build-and-release | Blocking               |

---

## Git Tag Release Workflow

### Creating a Release with Git Tags

Git tags provide a clean, industry-standard way to trigger releases:

```powershell
# 1. Update versions in CHANGELOG.md and manifest
# 2. Commit and push changes
git add CHANGELOG.md src/Datto.DBPool.API.psd1
git commit -m "Bump version to 0.2.3"
git push

# 3. Wait for CI to pass (check Actions tab)

# 4. Create annotated tag
git tag -a v0.2.3 -m "Release version 0.2.3"

# 5. Push tag to trigger release
git push origin v0.2.3
```

### Tag Format

- **Required format:** `v*.*.*` (e.g., `v0.2.3`, `v1.0.0`, `v2.1.4`)
- **Must be annotated:** Use `-a` flag with message
- **Must match CHANGELOG:** Tag version must equal CHANGELOG version

### Benefits of Git Tags

- **Industry standard** - Used by most open source projects
- **Permanent markers** - Tags are immutable references in git history
- **Clear intent** - Only triggers when you explicitly tag
- **Integration friendly** - Works with other tools (GitHub Releases, changelogs)
- **Audit trail** - Easy to see what was released and when
- **Rollback support** - Can checkout any tagged version

### CHANGELOG as Release Notes

The workflow extracts release notes from CHANGELOG.md:

```markdown
## [0.2.3] Release

Add new feature for container management

Fix bug in API authentication

Update documentation for new endpoints
```

These notes appear in the GitHub Release automatically!

**Fallback:** If no CHANGELOG section found, uses git commit messages.

---

## Secrets Configuration

### Required Secrets

Navigate to: `Settings` → `Secrets and variables` → `Actions`

| Secret Name          | Purpose                    | Used By               |
|----------------------|----------------------------|-----------------------|
| `PS_GALLERY_API_KEY` | PowerShell Gallery API key | publish-psgallery.yml |
| `GITHUB_TOKEN`       | Auto-provided by GitHub    | All workflows         |

### Setting up PS_GALLERY_API_KEY

1. Go to [PowerShell Gallery](https://www.powershellgallery.com/)
2. Sign in and navigate to API Keys
3. Create new API key with `Push` permission
4. Copy the key
5. In GitHub: Settings → Secrets → New repository secret
6. Name: `PS_GALLERY_API_KEY`
7. Paste key and save

---

## Monitoring and Troubleshooting

### Viewing Workflow Runs

- **CI Status:** Actions tab → Filter by workflow name
- **Release History:** Releases page
- **Security Issues:** Security tab → Code scanning alerts

### Common Issues

#### Release fails with "Version has not changed"

**Cause:** Version in CHANGELOG.md matches the last release
**Fix:** Update version in both CHANGELOG.md and manifest

#### Release fails with "CI checks not passed"

**Cause:** Build_Tests or PSScriptAnalyzer failed on latest commit
**Fix:** Check Actions tab, fix failing tests, push fix

#### PSGallery publish fails

**Cause:** API key expired or invalid
**Fix:** Regenerate PS_GALLERY_API_KEY secret

#### Documentation not updating

**Cause:** Build_DocsSite.yml workflow disabled or failing
**Fix:** Check workflow runs, ensure Docker is available for MkDocs build

---

## Best Practices

1. **Always run tests locally** before pushing: `./build.ps1 -Bootstrap`
2. **Update CHANGELOG.md** with every significant change
3. **Use semantic versioning:** MAJOR.MINOR.PATCH
4. **Wait for CI** to pass before creating releases
5. **Review release notes** generated from commits - write descriptive commit messages
6. **Test in dev container** to match CI environment
7. **Monitor Security tab** for PSScriptAnalyzer findings

---

## File Locations

| File                                      | Purpose                  |
|-------------------------------------------|--------------------------|
| `.github/workflows/build-and-release.yml` | Release creation         |
| `.github/workflows/publish-psgallery.yml` | PSGallery publishing     |
| `.github/workflows/Build_Tests.yaml`      | CI testing               |
| `.github/workflows/PSScriptAnalyzer.yml`  | Code quality             |
| `.github/workflows/Build_DocsSite.yml`    | Documentation            |
| `build.ps1`                               | Main build script        |
| `psakeFile.ps1`                           | Build tasks definition   |
| `requirements.psd1`                       | Build dependencies       |
| `tests/Manifest.tests.ps1`                | Version validation tests |

---

## Version History

- **2026-01-29:** Initial integrated CI/CD pipeline created
  - Added CI status verification to release workflow
  - Automated documentation updates on release
  - Integrated all workflows into cohesive pipeline
