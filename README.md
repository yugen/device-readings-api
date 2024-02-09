# Brightwheel - Device Readings Interview Project

This repo implements an API that stores device readings and can give information about the readings collected for a device.

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