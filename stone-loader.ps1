# the main driver of the script
function getBeersForLocation($location) {

    # call stone api, get beer data for woodman's in c-vill
    $json = Invoke-WebRequest -Uri $location.url | ConvertFrom-Json

    # open keys file
    $keyJson = (Get-Content beer-key.json) -join "`n" | ConvertFrom-Json

    #sort data
    $jsonSorted = $json.beers | Sort-Object delivered -Descending 

    # build the formatted response
    foreach ($beer in $jsonSorted) {
        $formatted = new-Object PsObject -property @{
            Brand = lookupBrand($beer.brand);
            Delivered = formatDate($beer.delivered);
            #Expires = formatDate($beer.expires);
            Package = $beer.package;
            Location = $location.name;
        }

        $formatted
    }
}

# format an epoc date so it is easier to understand
function formatDate($rawDate) {
    $origin = get-date "1/1/1970"
    $formattedValue = $origin.AddSeconds($rawDate)
    
    return $formattedValue 
}

# translate a brandId to a brand name
function lookupBrand ($brandId) {
    $brand = $keyJson.findstone.brands.$brandId
    $disabledBrand = $keyJson.findstone.brands."144".children.$brandId
    $bastardBrand = $keyJson.findstone.bastard.$brandId
    $disabledBastard = $keyJson.findstone.bastard."144".children.$brandId

    if ($brand.name) {
        return $brand.name
    }
    elseif ($disabledBrand) {
        return $disabledBrand
    }
    elseif ($bastardBrand) {
        return $bastardBrand.name
    }
    elseif ($disabledBastard) {
        return $disabledBastard 
    }
    else {
        return $brandId
    }
}

# translate a packageId to a package name
function lookupPackage ($packageId) {
    $package = $keyJson.findstone.package_types.$packageId
    return $package.name;
}

#
# make the script do something
#
$config = "config.json"
$configData = Get-Content "$config" | ConvertFrom-Json

foreach ($location in $configData.Locations) {
    getBeersForLocation($location);
}
