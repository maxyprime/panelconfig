param (
    [string]$username,
    [string]$license
)

$name = "Arunkumar.pandi's Application"
$ownerid = "fnnkAQsWWq"
$version = "1.0"
$api_url = "https://keyauth.win/api/1.3/"

$payload = @{
    type = 'login'
    username = $username
    key = $license
    name = $name
    ownerid = $ownerid
    ver = $version
}

try {
    $response = Invoke-RestMethod -Uri $api_url -Method Post -Body $payload -UseBasicParsing
    if ($response.success -eq $true) {
        exit 0
    } else {
        exit 1
    }
} catch {
    exit 1
}
