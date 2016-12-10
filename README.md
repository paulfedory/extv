# extv [![Build Status](https://travis-ci.org/paulfedory/extv.svg?branch=master)](https://travis-ci.org/paulfedory/extv)
Elixir API client for the TVDB

## Configuration

Add the following line to your `config.exs` file:

`config :extv, tvdb_api_key: "<your api key>"`


## Usage
```
iex -S mix
iex(1)> ExTV.Series.by_id("<id from theTVDB.com>")
```
