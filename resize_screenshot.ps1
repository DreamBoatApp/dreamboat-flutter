
Add-Type -AssemblyName System.Drawing

$sourcePath = "C:/Users/guney/.gemini/antigravity/brain/28365488-1e9b-4f2b-9c66-fd66c48af52f/uploaded_media_0_1769615014229.jpg"
$targetPath = "C:/Users/guney/.gemini/antigravity/brain/28365488-1e9b-4f2b-9c66-fd66c48af52f/iap_screenshot_fixed.png"

try {
    $img = [System.Drawing.Image]::FromFile($sourcePath)
    $newImg = New-Object System.Drawing.Bitmap(1290, 2796)
    $graph = [System.Drawing.Graphics]::FromImage($newImg)
    
    # High quality resizing
    $graph.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graph.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $graph.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graph.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality

    $graph.DrawImage($img, 0, 0, 1290, 2796)
    
    $newImg.Save($targetPath, [System.Drawing.Imaging.ImageFormat]::Png)
    
    Write-Host "Success: Resized to 1290x2796"
} catch {
    Write-Host "Error: $_"
} finally {
    if ($img) { $img.Dispose() }
    if ($newImg) { $newImg.Dispose() }
    if ($graph) { $graph.Dispose() }
}
