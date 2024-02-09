# Brightwheel - Device Readings Interview Project

This repo implements an API that stores device readings and can give information about the readings collected for a device.

## Structure
The application makes use of rails `MemoryCacheStore` to store readings for devices between requests.  This means the data will be lost each time the server is restarted.

Readings for a device are modeled as a `DeviceLog` which maintains a list of the readings modeled as `DeviceReading` and caches the `latest_timestamp` and `cumulative` count.

Retrieval and "persistence" of readings is encapsulated in the `DeviceLogRepository` to abstract interaction with `Rails.cache`.

All of these classes can be found in `/domain`.

## Endpoints

### `[POST] /device-readings/`
Stores device readings for a device. Readings with timestamps already stored are silently ignored.

#### Request Body
```
{
    "id": "36d5658a-6908-479e-887e-a949ec199272",
    "readings": [
        {
            "timestamp": "2021-09-29T16:08:15+01:00",
            "count": 2
        }, 
        {
            "timestamp": "2021-09-29T16:09:15+01:00",
            "count": 15 
        }
    ] 
}
```
`id` and `readings` are required.
`readings` must be an array of objects where each has valid ISO-8061 `timestamp` and positive integer `count` attributes.

#### Responses
##### 200 - Success
```
    { 
        device_id: 'device-id-2', 
        cumulative_count: 1, 
        latest_timestamp: '2024-01-01T00:00:00' 
    }
```

#### 422 - Unprocessable entity
```
    {
        "errors": {
            "field1": ["error1","error2"...]
            "field2": ["error1", "error2"...]
        }
    }
```

### `[GET] /device-readings/:device_id/latest-timestamp`
#### Responses
##### 200 - Success
```
    { "latest_timestamp": "2024-01-01T00:02:00+1:00:00" }
```
##### 404 - Not Found
```
    {
    "errors": "Log for device :device_id not found"
    }
```

### `[GET] /device-readings/:device_id/cumulative-count`
#### Responses
##### 200 - Success
```
    { "cumulative_count": 3 }
```
##### 404 - Not Found
```
    {
    "errors": "Log for device :device_id not found"
    }
```


## Installation:
### Dependencies:
To run this API you'll need the following:
* Ruby 3.3.0
* Access to the command line

### Install and run
1. Clone the repository: `git clone git@github.com:yugen/device-readings-api.git`
2. CD into the working directory: `cd repository_dir`
3. Install ruby dependencies: `bundle install`
4. Run the tests: `bundle exec rspec`
4. Run the server: `rails server`


## TODO:
* Authentication & authorization - Some kind of authentication should be added to prevent unauthorized requests.