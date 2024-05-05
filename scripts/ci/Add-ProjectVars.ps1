#!/usr/bin/env pwsh

# Specify the path of the .env file
$dotenv_path = '/root/avd_iac/.env'

# Load the environment variables from the .env file
$env_vars = Get-Content -Path $dotenv_path | ForEach-Object {
    $key, $value = $_ -split '=', 2
    $env:$key = $value
}

$gitlab_hostname = $env:gitlab_hostname
$project_id = $env:project_id
$api_string = "api/v4/projects/$project_id/variables"
$headers = @{"PRIVATE-TOKEN" = $env:gitlab_access_token}

$url = "https://$gitlab_hostname/$api_string"

function Get-Variables {
    $response = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
    return $response
}

function Create-Variables {
    # creates gitlab project variables from environment variables
    foreach ($key in $env_vars.GetEnumerator()) {
        if ($key.Name -like "gitlab*") {
            $body = @{ "key" = $key.Name; "value" = $key.Value }
            $response = Invoke-RestMethod -Uri $url -Headers $headers -Method Post -Body $body
            if ($response.StatusCode -eq 201) {
                Write-Host "Successfully added $($key.Name) to project variables"
            } elseif ($response.StatusCode -eq 400) {
                Write-Host "$($key.Name) already exists in project variables"
            } else {
                Write-Host "$($response.StatusCode): Failed to add $($key.Name) to project variables"
            }
        }
    }
}

function Delete-Variables {
    # deletes all gitlab project variables
    Write-Host 'Deleting project variables'
    $variables = Get-Variables
    foreach ($variable in $variables) {
        $response = Invoke-RestMethod -Uri "$url/$($variable.key)" -Headers $headers -Method Delete
        if ($response.StatusCode -eq 204) {
            Write-Host "Successfully deleted $($variable.key) from project variables"
        } else {
            Write-Host "$($response.StatusCode): Failed to delete $($variable.key) from project variables"
        }
    }
}

# Main execution
Create-Variables