# Stone Loader

## What is it?

A simple powershell script to query Stone's beer finder for me.

## Usage

- Rename the `config.sample.json` to `config.json`
- Update the Locations array to contain the locations for which you'd like to pull data.  
  - `name`: The display name for the location when results are shown
  - `url`: The url for the location.  Basically replace #### with the Location Id (to find a Locatin Id see below)
- Make sure you save your config.json
- run the script `.\stone-loader.ps1`

## Notes

### Find your Location Id
  1.  Use this URL - https://find.stonebrewing.com
  1.  Search for your zipcode
  1.  Click a location and use the number from the #location_XXXX in the URL
     - example: https://find.stonebrewing.com/#location_17846