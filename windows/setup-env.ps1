# --- Architect's Note ---
# This script configures the persistent Windows User PATH environment.
# It ensures that command-line tools installed by winget (like GnuWin32's 'tree')
# are discoverable in all future terminal sessions.
# This script MUST be run in PowerShell.

# --- 1. Define Paths to Add ---
# We store them in an array to make this script easy to extend later.
$pathsToAdd = @(
    "C:\Program Files (x86)\GnuWin32in"
    # We can add more paths here in the future
)

# --- 2. Get Current User PATH ---
Write-Host "Reading current User PATH..."
$envTarget = [EnvironmentVariableTarget]::User
$currentPath = [Environment]::GetEnvironmentVariable("Path", $envTarget)

# Split the path string into an array for easier checking
$pathArray = $currentPath -split ';' -ne ''

# --- 3. Add Missing Paths ---
$needsUpdate = $false
foreach ($path in $pathsToAdd) {
    if ($pathArray -contains $path) {
        Write-Host "  [OK] '$path' is already in the PATH."
    } else {
        Write-Host "  [ADDING] '$path' to the PATH."
        # Add the new path to our $currentPath string
        $currentPath = $currentPath + ";" + $path
        $needsUpdate = $true
    }
}

# --- 4. Apply Update (If Needed) ---
if ($needsUpdate) {
    [Environment]::SetEnvironmentVariable("Path", $currentPath, $envTarget)
    Write-Host "`n✅ SUCCESS: Your User PATH has been updated."
    Write-Host "   You MUST close and re-open all terminal windows for this to take effect."
} else {
    Write-Host "`n✅ Your PATH is already up to date. No changes needed."
}
