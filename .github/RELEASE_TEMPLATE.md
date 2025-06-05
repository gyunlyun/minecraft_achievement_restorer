# Release Template

Use this template when creating manual releases.

## Release Checklist

- [ ] Update version in `pubspec.yaml`
- [ ] Test the application thoroughly
- [ ] Update CHANGELOG.md (if exists)
- [ ] Create and push version tag
- [ ] Verify GitHub Actions build completes successfully
- [ ] Test the released ZIP file

## Version Tag Format

Use semantic versioning: `v1.0.0`, `v1.1.0`, `v2.0.0`

```bash
# Create and push a version tag
git tag v1.0.0
git push origin v1.0.0
```

## Manual Release Steps

If you need to create a release manually:

1. **Build the application**:
   ```bash
   flutter clean
   flutter pub get
   flutter gen-l10n
   flutter build windows --release
   ```

2. **Create release package**:
   ```bash
   mkdir release
   mkdir release/restorer-windows
   xcopy "build\windows\x64\runner\Release\*" "release\restorer-windows\" /E /I /H /Y
   copy "README.md" "release\restorer-windows\"
   copy "README_CN.md" "release\restorer-windows\"
   copy "LICENSE" "release\restorer-windows\"
   ```

3. **Create ZIP**:
   ```bash
   cd release
   powershell Compress-Archive -Path "restorer-windows" -DestinationPath "restorer-windows.zip"
   ```

4. **Upload to GitHub Releases**:
   - Go to GitHub repository
   - Click "Releases" → "Create a new release"
   - Choose tag version
   - Upload the ZIP file
   - Add release notes

## Release Notes Template

```markdown
## Minecraft Achievement Restorer v1.0.0

### 🎉 What's New
- Initial release
- Auto-scan Minecraft worlds
- Batch processing support
- Bilingual interface (English/Chinese)
- Smart sorting and search

### 📦 Download
- **Windows**: Download `minecraft-achievement-restorer-windows.zip`

### 🔧 System Requirements
- Windows 10/11
- Minecraft Bedrock Edition

### ⚠️ Important Notes
- Always backup your worlds before processing
- Close Minecraft completely before using this tool
```

