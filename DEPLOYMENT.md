# MathKids Adventure — Deployment & CI/CD Documentation

> **Last Updated**: 2026-03-06
> **Purpose**: เอกสารนี้สรุปทุกสิ่งที่ทำไปเกี่ยวกับ CI/CD, Production Signing, และ Play Store Deployment เพื่อให้ AI model หรือ developer คนถัดไปทำงานต่อได้ทันที

---

## 1. Project Overview

| Item | Value |
|------|-------|
| **App Name** | MathKids Adventure |
| **Package Name** | `com.mathkids.adventure` |
| **Framework** | Flutter (Dart) |
| **Flutter Version** | 3.41.4 (stable) |
| **Min SDK** | Defined in `flutter.minSdkVersion` |
| **Target SDK** | Defined in `flutter.targetSdkVersion` |
| **Version** | 1.0.0+1 (in `pubspec.yaml`) |
| **GitHub Repo** | https://github.com/Narongyot1990/mathkids |
| **Play Console** | https://play.google.com/console (app: MathKids Adventure) |

---

## 2. Local Development Environment

### Paths (on developer machine — Windows)

| Component | Path |
|-----------|------|
| **Flutter SDK** | `D:\Flutter` |
| **Android SDK** | `D:\Android\sdk` |
| **JDK 17** | `D:\Android\jdk-17.0.13+11` |
| **Project Root** | `D:\projects\java\apps\mathkids_adventure` |
| **Keystore File** | `D:\projects\java\apps\mathkids_adventure\android\app\mathkids_adventure.keystore` |
| **Keystore Base64 (clean)** | `D:\projects\AndroidStudio\keystore_base64_clean.txt` |
| **Keystore Base64 (old, has headers — DO NOT USE)** | `D:\projects\AndroidStudio\keystore_base64.txt` |
| **Service Account JSON** | `D:\DATA\Narongyot.B\Downloads\play-store-deploy-489313-0404103a731b.json` |

### Keystore Credentials

| Item | Value |
|------|-------|
| **Keystore Alias** | `mathkidskey` |
| **Keystore Password** | `mathkids123` |
| **Key Password** | `mathkids123` |

---

## 3. GitHub Actions CI/CD

### Workflow File

`.github/workflows/build.yml`

### What It Does

1. **Checkout** code
2. **Set up Flutter** 3.41.4 stable
3. **Get dependencies** (`flutter pub get`)
4. **Decode Keystore** — decodes `KEYSTORE` secret (base64) → `android/app/mathkids_adventure.keystore`
5. **Build Release AAB** — `flutter build appbundle --release` (for Play Store)
6. **Build Release APK** — `flutter build apk --release` (for direct install)
7. **Upload AAB Artifact** — saves AAB as downloadable GitHub artifact
8. **Upload APK Artifact** — saves APK as downloadable GitHub artifact
9. **Deploy to Play Store** — uses `r0adkll/upload-google-play@v1` to auto-upload AAB to Play Store production track

### Trigger

- **Push to `main`** → full build + deploy to Play Store
- **Pull Request to `main`** → build only (deploy step skipped via `if` condition)

### GitHub Secrets (Settings → Secrets → Actions)

| Secret Name | Description | How It Was Set |
|-------------|-------------|----------------|
| `KEYSTORE` | Base64-encoded keystore file (single line, NO headers/footers). Generated via `[Convert]::ToBase64String([IO.File]::ReadAllBytes('...keystore'))` | `gh secret set` via CLI |
| `KEYSTORE_PASSWORD` | `mathkids123` | `gh secret set` via CLI |
| `KEY_ALIAS` | `mathkidskey` | `gh secret set` via CLI |
| `KEY_PASSWORD` | `mathkids123` | `gh secret set` via CLI |
| `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` | Full JSON content of Google Cloud Service Account key for Play Store API | `gh secret set` via CLI |

### How Secrets Were Set (for reference)

```powershell
# GitHub CLI portable was downloaded to:
# $env:TEMP\gh_cli\bin\gh.exe

# Login
echo "<PAT_TOKEN>" | gh auth login --hostname github.com --with-token

# Set KEYSTORE (from clean base64 file)
Get-Content "D:\projects\AndroidStudio\keystore_base64_clean.txt" -Raw | gh secret set KEYSTORE --repo Narongyot1990/mathkids

# Set other secrets
echo "mathkids123" | gh secret set KEYSTORE_PASSWORD --repo Narongyot1990/mathkids
echo "mathkidskey" | gh secret set KEY_ALIAS --repo Narongyot1990/mathkids
echo "mathkids123" | gh secret set KEY_PASSWORD --repo Narongyot1990/mathkids

# Set Service Account JSON
Get-Content "D:\DATA\Narongyot.B\Downloads\play-store-deploy-489313-0404103a731b.json" -Raw | gh secret set GOOGLE_PLAY_SERVICE_ACCOUNT_JSON --repo Narongyot1990/mathkids
```

---

## 4. Production Signing Configuration

### `android/app/build.gradle.kts`

The signing config reads from **environment variables** (set by GitHub Actions):

```kotlin
signingConfigs {
    create("release") {
        storeFile = file(System.getenv("KEYSTORE_PATH") ?: "mathkids_adventure.keystore")
        storePassword = System.getenv("KEYSTORE_PASSWORD") ?: ""
        keyAlias = System.getenv("KEY_ALIAS") ?: ""
        keyPassword = System.getenv("KEY_PASSWORD") ?: ""
    }
}

buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
    }
}
```

### Environment Variables (set in build.yml)

| Env Var | Source |
|---------|--------|
| `KEYSTORE_PATH` | `mathkids_adventure.keystore` (relative path after decode step) |
| `KEYSTORE_PASSWORD` | `${{ secrets.KEYSTORE_PASSWORD }}` |
| `KEY_ALIAS` | `${{ secrets.KEY_ALIAS }}` |
| `KEY_PASSWORD` | `${{ secrets.KEY_PASSWORD }}` |

---

## 5. Google Play Store Setup

### Google Cloud Service Account

| Item | Value |
|------|-------|
| **Project ID** | `766818979478` (play-store-deploy-489313) |
| **Service Account** | `play-store-deploy` |
| **API Enabled** | Google Play Android Developer API (`androidpublisher.googleapis.com`) |
| **Key File** | `D:\DATA\Narongyot.B\Downloads\play-store-deploy-489313-0404103a731b.json` |

### Play Console Permissions

The service account `play-store-deploy` must have **Release manager** permission (or at minimum: "Release to production, exclude devices, and use Play App Signing") in:

**Play Console → Settings → API access → Service accounts**

### First AAB Upload

Google Play API requires **at least one manual AAB upload** via the Play Console web UI before the API can manage releases. This was done via:

1. Play Console → App → Testing → Internal testing → Create new release → Upload `app-release.aab`

### Deploy Action

```yaml
- name: Deploy to Play Store
  if: github.event_name == 'push' && github.ref == 'refs/heads/main'
  uses: r0adkll/upload-google-play@v1
  with:
    serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT_JSON }}
    packageName: com.mathkids.adventure
    releaseFiles: build/app/outputs/bundle/release/app-release.aab
    track: production
    status: completed
```

**Track options**: `internal`, `alpha`, `beta`, `production`
If `production` causes issues (e.g. Play Store review requirements not met), change to `internal` first.

---

## 6. Tools Used

| Tool | Version / Source | Purpose |
|------|-----------------|---------|
| **Flutter** | 3.41.4 stable | App framework |
| **Android SDK** | `D:\Android\sdk` | Android build tools |
| **JDK** | 17.0.13+11 | Java compiler for Gradle |
| **GitHub Actions** | `ubuntu-latest` runner | CI/CD pipeline |
| **GitHub CLI (`gh`)** | v2.67.0 (portable zip) | Set secrets, re-run workflows, watch builds |
| **subosito/flutter-action@v2** | GitHub Action | Install Flutter on CI runner |
| **actions/upload-artifact@v4** | GitHub Action | Save build artifacts |
| **r0adkll/upload-google-play@v1** | GitHub Action | Upload AAB to Play Store |
| **keytool** (JDK) | — | Generated `.keystore` file |
| **PowerShell** | Windows built-in | Base64 encoding, file operations |

---

## 7. Build History & Issues Resolved

### Chronological Summary

| Build # | Commit | Result | Notes |
|---------|--------|--------|-------|
| ~1-19 | Various | ❌ | Multiple signing failures — tried apksigner, gradle properties, System.getenv |
| 20 | Debug signing fallback | ✅ Build | APK built but with debug signature — cannot upload to Play Store |
| 21 | `feat: production signing` | ✅ Build | Production-signed APK using env vars + keystore secret |
| 22 | `feat: auto deploy AAB` | ✅ Build, ❌ Deploy | API not enabled → enabled `androidpublisher.googleapis.com` |
| 22 rerun 1 | — | ✅ Build, ❌ Deploy | `Package not found: com.mathkids.adventure` → need first manual upload |
| 22 rerun 2 | — | ✅ Build, ❌ Deploy | Same — first manual upload via Play Console needed |
| 22 rerun 3 | — | 🔄 Pending | After manual AAB upload to Play Console |

### Root Causes Fixed

1. **`KEYSTORE` secret had PEM headers** (`-----BEGIN CERTIFICATE-----`) → `base64 --decode` failed
   - **Fix**: Generated clean base64 via `[Convert]::ToBase64String()` without headers

2. **`build.gradle.kts` used debug signing** (`signingConfigs.getByName("debug")`)
   - **Fix**: Created `release` signingConfig using `System.getenv()` for all credentials

3. **Google Play Android Developer API not enabled**
   - **Fix**: Enabled at `console.developers.google.com`

4. **Package not found on Play Store**
   - **Fix**: Must upload first AAB manually via Play Console web UI

---

## 8. Key Files

| File | Purpose |
|------|---------|
| `.github/workflows/build.yml` | CI/CD workflow — build + deploy |
| `android/app/build.gradle.kts` | Android build config with production signing |
| `android/app/mathkids_adventure.keystore` | Production keystore (DO NOT commit to git) |
| `pubspec.yaml` | Flutter dependencies, version (1.0.0+1) |
| `AGENTS.md` | Developer guide, code style, testing commands |
| `DEPLOYMENT.md` | This file — deployment documentation |

---

## 9. Common Operations

### Re-run failed workflow

```powershell
$ghExe = "$env:TEMP\gh_cli\bin\gh.exe"
& $ghExe run rerun <RUN_ID> --repo Narongyot1990/mathkids --failed
```

### Watch a workflow run

```powershell
& $ghExe run watch <RUN_ID> --repo Narongyot1990/mathkids --exit-status
```

### List recent runs

```powershell
& $ghExe run list --repo Narongyot1990/mathkids --limit 5
```

### View workflow logs

```powershell
& $ghExe run view <RUN_ID> --repo Narongyot1990/mathkids --log-failed
```

### Update a secret

```powershell
echo "new_value" | & $ghExe secret set SECRET_NAME --repo Narongyot1990/mathkids
```

### Build locally

```powershell
# AAB (for Play Store)
flutter build appbundle --release

# APK (for direct install)
flutter build apk --release
```

### Bump version before release

Edit `pubspec.yaml` line 19:
```yaml
version: 1.0.1+2   # versionName + versionCode
```
**Note**: Play Store requires `versionCode` to increase with each upload.

---

## 10. Troubleshooting

| Problem | Solution |
|---------|----------|
| `Package not found` on deploy | First AAB must be uploaded manually via Play Console web |
| Signing fails on CI | Check KEYSTORE secret is clean base64 (no headers), verify passwords match |
| `API not enabled` | Enable at `console.developers.google.com/apis/api/androidpublisher.googleapis.com` |
| gh CLI not found | Download portable: `https://github.com/cli/cli/releases/download/v2.67.0/gh_2.67.0_windows_amd64.zip` |
| gh auth expired | Re-login: `echo "<PAT>" \| gh auth login --hostname github.com --with-token` |
| Play Store rejects AAB | Check that `versionCode` in pubspec.yaml is higher than the last uploaded version |
| Deploy to production blocked | Change `track` in build.yml from `production` to `internal` (less restrictions) |

---

## 11. Next Steps / TODO

- [ ] **Verify auto-deploy works** — after first manual AAB upload, re-run workflow to confirm `Deploy to Play Store` step passes
- [ ] **Complete Play Store listing** — fill in store listing (description, screenshots, content rating, privacy policy) in Play Console
- [ ] **Consider changing deploy track** — use `internal` testing first, then promote to `production` after Play Store review
- [ ] **Version bumping** — increment `versionCode` in `pubspec.yaml` before each release
- [ ] **Revoke exposed PAT** — the GitHub PAT `ghp_n105...` was used in chat, should be revoked at https://github.com/settings/tokens and a new one created if needed
- [ ] **Add ProGuard/R8** — consider adding code shrinking for smaller APK/AAB
- [ ] **Add app signing by Google Play** — consider enrolling in Play App Signing for extra security
